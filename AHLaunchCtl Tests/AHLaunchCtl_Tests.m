//
//  AHLaunchCtl_Tests.m
//  AHLaunchCtl Tests
//
//  Created by Eldon on 10/16/14.
//  Copyright (c) 2014 Eldon Ahrold. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "AHLaunchCtl.h"

@interface AHLaunchCtl_Tests : XCTestCase

@end

@implementation AHLaunchCtl_Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each
    // test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each
    // test method in the class.
    [super tearDown];
}


- (void)testAll
{
    [self testAdd];
    [self testLoadAsRoot];
    [self testUnloadAsRoot];
    [self load];
    [self restart];
    [self testGetJob];
    [self remove];
}

#pragma mark - The Job
- (AHLaunchJob*)theJob
{
    AHLaunchJob* job = [AHLaunchJob new];
    job.Program = @"/bin/echo";
    job.Label = @"com.eeaapps.echo.helloworld";
    job.ProgramArguments = @[ @"/bin/echo", @"hello world" ];
    job.StandardOutPath = @"/tmp/hello.txt";
    job.RunAtLoad = YES;
    return job;
}

#pragma mark - Tests
- (void)testAdd
{
    NSError* error;
    AHLaunchJob *job = [self theJob];
    BOOL success = [[AHLaunchCtl sharedController] add:job
                                             toDomain:kAHUserLaunchAgent
                                                error:&error];

    XCTAssertTrue(success, @"Error %@", error);
}

- (void)testRemvoe
{
    NSError* error;
    AHLaunchJob *job = [self theJob];
    BOOL success = [[AHLaunchCtl sharedController] remove:job.Label
                                              fromDomain:kAHUserLaunchAgent
                                                 error:&error];

    XCTAssertTrue(success, @"Error %@", error);
}

- (void)testAddRoot
{
    NSError* error;
    AHLaunchJob *job = [self theJob];
    BOOL success = [[AHLaunchCtl sharedController] add:job
                                              toDomain:kAHGlobalLaunchDaemon
                                                 error:&error];

    XCTAssertTrue(success, @"Error %@", error);
}

- (void)testRemoveRoot
{
    NSError* error;
    AHLaunchJob *job = [self theJob];

    BOOL success = [[AHLaunchCtl sharedController] remove:job.Label fromDomain:kAHGlobalLaunchDaemon error:&error];
    XCTAssertTrue(success, @"Error %@", error);

}

- (void)testGetJob
{
    AHLaunchJob* job =
        [AHLaunchCtl runningJobWithLabel:@"com.eeaapps.echo.helloworld"
                                inDomain:kAHGlobalLaunchDaemon];

    NSLog(@"%@", job);
    XCTAssertTrue(job != nil, @"Could not get job");
}

- (void)load
{
    NSError* error;
    AHLaunchJob* job = [self theJob];

    BOOL success = [[AHLaunchCtl sharedController] load:job
                                              inDomain:kAHGlobalLaunchDaemon
                                                 error:&error];

    XCTAssertFalse(success, @"Error %@", error);
}


- (void)testLoadAsRoot
{
    NSError* error;
    AHLaunchJob* job = [self theJob];

    BOOL success = [[AHLaunchCtl sharedController] load:job
                                              inDomain:kAHGlobalLaunchDaemon
                                                 error:&error];

    XCTAssertTrue(success, @"Error %@", error);
}

- (void)testUnloadAsRoot
{
    NSError* error;

    BOOL success =
        [[AHLaunchCtl sharedController] unload:@"com.eeaapps.echo.helloworld"
                                     inDomain:kAHGlobalLaunchDaemon
                                        error:&error];
    
    XCTAssertTrue(success, @"Error %@", error);
}

- (void)restart
{
    NSError* error;
    XCTAssertTrue(
        [[AHLaunchCtl sharedController] restart:@"com.eeaapps.echo.helloworld"
                                      inDomain:kAHUserLaunchAgent
                                         error:&error],
        @"Error: %@", error.localizedDescription);
}

- (void)remove
{
    NSError* error;
    XCTAssertTrue(
        [[AHLaunchCtl sharedController] remove:@"com.eeaapps.echo.helloworld"
                                   fromDomain:kAHUserLaunchAgent
                                        error:&error],
        @"Error: %@", error.localizedDescription);
}

@end
