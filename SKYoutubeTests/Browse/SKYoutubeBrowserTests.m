 //
//  SKYoutubeBrowserTests.m
//  SKYoutube
//
//  Created by Shin-Kai Chen on 2016/5/5.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SKYoutubeBrowser.h"

@interface SKYoutubeBrowserTests : XCTestCase

@property(nonatomic, strong, readonly, nonnull) SKYoutubeBrowser *browser;

@end

@implementation SKYoutubeBrowserTests {
    XCTestExpectation *expectation;
}

- (void)setUp {
    [super setUp];
    
    _browser = [[SKYoutubeBrowser alloc] initWithKey:@"AIzaSyDXoxTyxuJsbzpqzxHuFCtybfYC1fBqGr0"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testListMostPopular {
    expectation = [self expectationWithDescription:@"testListMostPopular round 1"];
    
    [_browser listMostPopular:NO extend:YES success:^(NSArray * _Nonnull list, BOOL finished) {
        XCTAssertFalse(finished);
        XCTAssertEqual([list count], 50);
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error) {
        XCTFail(@"failed: %@", error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:100 handler:^(NSError * _Nullable error) {
        NSLog(@"Round 1 complete");
    }];
    
    expectation = [self expectationWithDescription:@"testListMostPopular round 2"];
    
    [_browser listMostPopular:NO extend:YES success:^(NSArray * _Nonnull list, BOOL finished) {
        XCTAssertFalse(finished);
        XCTAssertEqual([list count], 100);
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error) {
        XCTFail(@"failed: %@", error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:100 handler:^(NSError * _Nullable error) {
        NSLog(@"Round 2 complete");
    }];
    
    expectation = [self expectationWithDescription:@"testListMostPopular round 3"];
    
    [_browser listMostPopular:NO extend:YES success:^(NSArray * _Nonnull list, BOOL finished) {
        XCTAssertFalse(finished);
        XCTAssertEqual([list count], 150);
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error) {
        XCTFail(@"failed: %@", error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:100 handler:^(NSError * _Nullable error) {
        NSLog(@"Round 3 complete");
    }];
    
    expectation = [self expectationWithDescription:@"testListMostPopular round 4"];
    
    [_browser listMostPopular:NO extend:YES success:^(NSArray * _Nonnull list, BOOL finished) {
        XCTAssertTrue(finished);
        XCTAssertEqual([list count], 200);
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error) {
        XCTFail(@"failed: %@", error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:100 handler:^(NSError * _Nullable error) {
        NSLog(@"Round 4 complete");
    }];
    
    expectation = [self expectationWithDescription:@"testListMostPopular round 5"];
    
    [_browser listMostPopular:NO extend:YES success:^(NSArray * _Nonnull list, BOOL finished) {
        XCTAssertTrue(finished);
        XCTAssertEqual([list count], 200);
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error) {
        XCTFail(@"failed: %@", error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:100 handler:^(NSError * _Nullable error) {
        NSLog(@"Round 5 complete");
    }];
    
    expectation = [self expectationWithDescription:@"testListMostPopular round 6"];
    
    [_browser listMostPopular:YES extend:YES success:^(NSArray * _Nonnull list, BOOL finished) {
        XCTAssertFalse(finished);
        XCTAssertEqual([list count], 50);
        [expectation fulfill];
    } failure:^(NSError * _Nonnull error) {
        XCTFail(@"failed: %@", error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:100 handler:^(NSError * _Nullable error) {
        NSLog(@"Round 6 complete");
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
