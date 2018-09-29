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

#import "BenchmarkCommon.h"

@interface BaselineBenchmark : Benchmark

@end

@implementation BaselineBenchmark

- (void)test_read
{
    NSString *tableName = [self getTableNameWithIndex:0];
    __block NSArray<BenchmarkObject *> *results = nil;

    [self
    measure:^{
        results = [self.database getObjectsOfClass:BenchmarkObject.class fromTable:tableName];
    }
    setUp:^{
        [self setUpDatabase];
        [self setUpWithPreCreateTable:1];
        [self setUpWithPreCreateObject:self.config.readCount];
        [self setUpWithPreInsertObjects:self.objects intoTable:tableName];

        [self tearDownDatabaseCache];
        [self setUpDatabaseCache];
    }
    tearDown:^{
        results = nil;
        [self tearDownDatabase];
    }
    checkCorrectness:^{
        XCTAssertEqual(results.count, self.config.readCount);
        XCTAssertTrue([results isEqualToBenchmarkObjects:self.objects]);
    }];
}

- (void)test_write
{
    NSString *tableName = [self getTableNameWithIndex:0];
    __block WCTDatabase *database = nil;
    __block NSArray<BenchmarkObject *> *objects = nil;

    [self
    measure:^{
        for (BenchmarkObject *object in objects) {
            [database insertObject:object intoTable:tableName];
        }
    }
    setUp:^{
        [self setUpDatabase];
        [self setUpWithPreCreateTable:1];
        [self setUpWithPreCreateObject:self.config.writeCount];

        [self tearDownDatabaseCache];
        [self setUpDatabaseCache];
        database = self.database;
        objects = self.objects;
    }
    tearDown:^{
        database = nil;
        objects = nil;
        [self tearDownDatabase];
    }
    checkCorrectness:^{
        NSArray<BenchmarkObject *> *objects = [self.database getObjectsOfClass:BenchmarkObject.class fromTable:tableName orderBy:BenchmarkObject.key.asOrder(WCTOrderedAscending)];
        XCTAssertTrue([objects isEqualToBenchmarkObjects:self.objects]);
        XCTAssertEqual(objects.count, self.config.writeCount);
    }];
}

- (void)test_batch_write
{
    NSString *tableName = [self getTableNameWithIndex:0];
    [self
    measure:^{
        [self.database insertObjects:self.objects intoTable:tableName];
    }
    setUp:^{
        [self setUpDatabase];
        [self setUpWithPreCreateTable:1];
        [self setUpWithPreCreateObject:self.config.batchWriteCount];

        [self tearDownDatabaseCache];
        [self setUpDatabaseCache];
    }
    tearDown:^{
        [self tearDownDatabase];
    }
    checkCorrectness:^{
        NSArray<BenchmarkObject *> *objects = [self.database getObjectsOfClass:BenchmarkObject.class fromTable:tableName orderBy:BenchmarkObject.key.asOrder(WCTOrderedAscending)];
        XCTAssertTrue([objects isEqualToBenchmarkObjects:self.objects]);
        XCTAssertEqual(objects.count, self.config.batchWriteCount);
    }];
}

- (void)test_create_index
{
    NSString *tableName = [self getTableNameWithIndex:0];
    __block BOOL result = NO;
    NSString *indexName = [tableName stringByAppendingString:@"_index"];

    [self
    measure:^{
        result = [self.database execute:WCDB::StatementCreateIndex().createIndex(indexName.UTF8String).on(tableName.UTF8String).indexedBy(BenchmarkObject.value)];
    }
    setUp:^{
        result = NO;
        [self setUpDatabase];
        [self setUpWithPreCreateTable:1];
        [self setUpWithPreCreateObject:self.config.writeCount];
        [self setUpWithPreInsertObjects:self.objects intoTable:tableName];

        [self tearDownDatabaseCache];
        [self setUpDatabaseCache];
    }
    tearDown:^{
        [self tearDownDatabase];
    }
    checkCorrectness:^{
        XCTAssertTrue(result);
    }];
}

@end