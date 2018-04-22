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

import Foundation

internal struct SteadyClock {
    private var time: TimeInterval //monotonic

    internal init() {
        time = ProcessInfo.processInfo.systemUptime
    }

    private init(with time: TimeInterval) {
        self.time = time
    }

    internal static func >= (lhs: SteadyClock, rhs: SteadyClock) -> Bool {
        return lhs.time >= rhs.time
    }

    internal static func - (lhs: SteadyClock, rhs: SteadyClock) -> TimeInterval {
        return lhs.time - rhs.time
    }

    internal static func + (steadyClock: SteadyClock, timeInterval: TimeInterval) -> SteadyClock {
        return SteadyClock(with: steadyClock.time + timeInterval)
    }

    internal static func now() -> SteadyClock {
        return SteadyClock()
    }
}