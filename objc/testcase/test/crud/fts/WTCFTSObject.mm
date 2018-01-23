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

#import "WTCFTSObject.h"
#import "WTCFTSObject+WCTTableCoding.h"
#import <WCDB/WCDB.h>

@implementation WTCFTSObject

WCDB_IMPLEMENTATION(WTCFTSObject)
WCDB_SYNTHESIZE(WTCFTSObject, variable1)
WCDB_SYNTHESIZE(WTCFTSObject, variable2)

WCDB_PRIMARY_ASC_AUTO_INCREMENT(WTCFTSObject, variable1)

WCDB_VIRTUAL_TABLE_MODULE_FTS3(WTCFTSObject)
WCDB_VIRTUAL_TABLE_ARGUMENT_TOKENIZE_WCDB(WTCFTSObject)

+ (NSString *)Name
{
    return NSStringFromClass(self);
}

- (BOOL)isEqual:(NSObject *)object
{
    return self.hash == object.hash;
}

- (NSUInteger)hash
{
    return [NSString stringWithFormat:@"%@_%d_%@", WTCFTSObject.Name, self.variable1, self.variable2].hash;
}

@end