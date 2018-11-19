/*
 * Tencent is pleased to support the open source community by making
 * WCDB available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef _WCDB_SYNTAXLIST_HPP
#define _WCDB_SYNTAXLIST_HPP

#include <list>
#include <type_traits>

namespace WCDB {

class SQL;

// list is better than vector here by avoiding memory reallocation
// we can add random accessibility for this list since the total size is small, usually less than 10
// all other method is same as std::list, see also: http://www.cplusplus.com/reference/list/list/
template<typename T>
class _SyntaxList : public std::list<T> {
    static_assert(std::is_base_of<SQL, T>::value, "");

protected:
    using Super = std::list<T>;

public:
    using std::list<T>::list;
    typedef T SQLType;
    typedef typename T::SyntaxType SyntaxType;

    _SyntaxList(const T& t) { this->push_back(t); }

    template<typename U, typename Enable = typename std::enable_if<std::is_constructible<T, U>::value>::type>
    _SyntaxList(const U& u)
    {
        this->push_back(u);
    }

    template<typename U, typename Enable = typename std::enable_if<std::is_constructible<T, U>::value>::type>
    _SyntaxList(const SyntaxList<U>& others)
    {
        for (const auto& other : others) {
            this->push_back(other);
        }
    }

    template<typename U, typename Enable = typename std::enable_if<std::is_constructible<T, U>::value>::type>
    _SyntaxList(const std::initializer_list<U>& others)
    {
        for (const auto& other : others) {
            this->push_back(other);
        }
    }

    template<typename U, typename Enable = typename std::enable_if<std::is_constructible<T, U>::value>::type>
    _SyntaxList(const std::list<U>& others)
    {
        for (const auto& other : others) {
            this->push_back(other);
        }
    }

    virtual ~_SyntaxList() {}

    operator std::list<SyntaxType>() const
    {
        std::list<SyntaxType> list;
        for (const auto& sql : *this) {
            list.push_back(sql.syntax());
        }
        return list;
    }

    const T& operator[](size_t index) const
    {
        assert(index < this->size());
        auto iter = this->begin();
        while (index != 0) {
            ++iter;
            --index;
        }
        return *iter;
    }

    T& operator[](size_t index)
    {
        assert(index < this->size());
        auto iter = this->begin();
        while (index != 0) {
            ++iter;
            --index;
        }
        return *iter;
    }

    String getDescription() const
    {
        std::ostringstream stream;
        bool comma = false;
        for (const auto& sql : *this) {
            if (comma) {
                stream << ", ";
            } else {
                comma = true;
            }
            stream << sql.getDescription();
        }
        return stream.str();
    }
};

template<typename T>
class SyntaxList final : public _SyntaxList<T> {
public:
    using _SyntaxList<T>::_SyntaxList;
};

} // namespace WCDB

#endif /* _WCDB_SYNTAXLIST_HPP */