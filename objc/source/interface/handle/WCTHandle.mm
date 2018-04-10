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

#import <WCDB/Interface.h>
#import <WCDB/NSData+noCopyData.h>
#import <WCDB/WCTUnsafeHandle+Private.h>

@implementation WCTHandle

- (WCTDatabase *)getDatabase
{
    return [[WCTDatabase alloc] initWithDatabase:_database];
}

#pragma mark - Info
- (long long)getLastInsertedRowID
{
    NSAssert(_handle != nullptr, @"[prepare] or [execute] should be called before this.");
    return _handle->getLastInsertedRowID();
}

- (int)getChanges
{
    NSAssert(_handle != nullptr, @"[prepare] or [execute] should be called before this.");
    return _handle->getChanges();
}

- (BOOL)isStatementReadonly
{
    NSAssert(_handle != nullptr, @"[prepare] or [execute] should be called before this.");
    return _handle->isStatementReadonly();
}

#pragma mark - Statement
- (BOOL)prepare:(const WCDB::Statement &)statement
{
    return [super prepare:statement];
}

- (void)finalizeStatement
{
    [super finalizeStatement];
}

#pragma mark - Stepping
- (BOOL)step:(BOOL &)done
{
    NSAssert(_handle != nullptr, @"[prepare] or [execute] should be called before this.");
    return _handle->step((bool &) done);
}

- (BOOL)step
{
    NSAssert(_handle != nullptr, @"[prepare] or [execute] should be called before this.");
    return _handle->step();
}

- (void)reset
{
    NSAssert(_handle != nullptr, @"[prepare] or [execute] should be called before this.");
    _handle->reset();
}

#pragma mark - Bind row
- (void)bindValue:(WCTColumnCodingValue *)value toIndex:(int)index
{
    [super bindValue:value toIndex:index];
}

- (void)bindBool:(BOOL)value toIndex:(int)index
{
    NSAssert(_handle != nullptr, @"[prepare] or [execute] should be called before this.");
    _handle->bindInteger32(value ? 1 : 0, index);
}

- (void)bindInteger32:(const int32_t &)value toIndex:(int)index
{
    NSAssert(_handle != nullptr, @"[prepare] or [execute] should be called before this.");
    _handle->bindInteger32(value, index);
}

- (void)bindInteger64:(const int64_t &)value toIndex:(int)index
{
    NSAssert(_handle != nullptr, @"[prepare] or [execute] should be called before this.");
    _handle->bindInteger64(value, index);
}

- (void)bindDouble:(const double &)value toIndex:(int)index
{
    NSAssert(_handle != nullptr, @"[prepare] or [execute] should be called before this.");
    _handle->bindDouble(value, index);
}

- (void)bindString:(NSString *)value toIndex:(int)index
{
    NSAssert(_handle != nullptr, @"[prepare] or [execute] should be called before this.");
    _handle->bindText(value.UTF8String, (int) value.length, index);
}

- (void)bindBLOB:(NSData *)value toIndex:(int)index
{
    NSAssert(_handle != nullptr, @"[prepare] or [execute] should be called before this.");
    _handle->bindBLOB(value.noCopyData, index);
}

- (void)bindNullToIndex:(int)index
{
    NSAssert(_handle != nullptr, @"[prepare] or [execute] should be called before this.");
    _handle->bindNull(index);
}

- (void)bindProperty:(const WCTProperty &)property
            ofObject:(WCTObject *)object
             toIndex:(int)index
{
    [super bindProperty:property
               ofObject:object
                toIndex:index];
}

- (void)bindProperties:(const WCTPropertyList &)properties
              ofObject:(WCTObject *)object
{
    [super bindProperties:properties ofObject:object];
}

#pragma mark - Get row
- (WCTValue *)getValueAtIndex:(int)index
{
    return [super getValueAtIndex:index];
}

- (WCTOneRow *)getRow
{
    return [super getRow];
}

- (BOOL)getBoolAtIndex:(int)index
{
    NSAssert(_handle != nullptr, @"[prepare] or [execute] should be called before this.");
    return _handle->getInteger32(index) != 0;
}

- (int32_t)getInteger32AtIndex:(int)index
{
    NSAssert(_handle != nullptr, @"[prepare] or [execute] should be called before this.");
    return _handle->getInteger32(index);
}

- (int64_t)getInteger64AtIndex:(int)index
{
    NSAssert(_handle != nullptr, @"[prepare] or [execute] should be called before this.");
    return _handle->getInteger64(index);
}

- (double)getDouble:(int)index
{
    NSAssert(_handle != nullptr, @"[prepare] or [execute] should be called before this.");
    return _handle->getDouble(index);
}

- (NSString *)getTextAtIndex:(int)index
{
    NSAssert(_handle != nullptr, @"[prepare] or [execute] should be called before this.");
    return @(_handle->getText(index));
}

- (NSData *)getBLOB:(int)index
{
    NSAssert(_handle != nullptr, @"[prepare] or [execute] should be called before this.");
    return [NSData dataWithNoCopyData:_handle->getBLOB(index)];
}

- (WCDB::ColumnType)getColumnTypeAtIndex:(int)index
{
    NSAssert(_handle != nullptr, @"[prepare] or [execute] should be called before this.");
    return _handle->getType(index);
}

- (void)extractValueAtIndex:(int)index
                 toProperty:(const WCTProperty &)property
                   ofObject:(WCTObject *)object
{
    [super extractValueAtIndex:index
                    toProperty:property
                      ofObject:object];
}

- (WCTObject *)getObjectOfClass:(Class)cls
{
    const WCTPropertyList &properties = [cls objectRelationalMappingForWCDB]->getAllProperties();
    return [self getObjectOfClass:cls onProperties:properties];
}

- (WCTObject *)getObjectOnProperties:(const WCTPropertyList &)properties
{
    Class cls = properties.front().getColumnBinding()->getClass();
    return [self getObjectOfClass:cls onProperties:properties];
}

- (int)getColumnCount
{
    NSAssert(_handle != nullptr, @"[prepare] or [execute] should be called before this.");
    return _handle->getColumnCount();
}

- (NSString *)getColumnNameAtIndex:(int)index
{
    NSAssert(_handle != nullptr, @"[prepare] or [execute] should be called before this.");
    return @(_handle->getColumnName(index));
}

- (NSString *)getColumnTableNameAtIndex:(int)index
{
    NSAssert(_handle != nullptr, @"[prepare] or [execute] should be called before this.");
    return @(_handle->getColumnTableName(index));
}

#pragma mark - Execute
- (BOOL)execute:(const WCDB::Statement &)statement
{
    return [super execute:statement];
}

- (BOOL)execute:(const WCDB::Statement &)statement
     withObject:(WCTObject *)object
{
    return [super execute:statement withObject:object];
}

- (BOOL)execute:(const WCDB::Statement &)statement
      withObject:(WCTObject *)object
    onProperties:(const WCTPropertyList &)properties
{
    return [super execute:statement withObject:object onProperties:properties];
}

- (BOOL)execute:(const WCDB::Statement &)statement
      withValue:(WCTColumnCodingValue *)value
{
    return [super execute:statement withValue:value];
}

- (BOOL)execute:(const WCDB::Statement &)statement
        withRow:(WCTOneRow *)row
{
    return [super execute:statement withRow:row];
}

@end