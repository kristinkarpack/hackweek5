//
//  LocalizationTestItems.m
//  Lin
//
//  Created by Kristin Ivarson on 6/7/13.
//  Copyright (c) 2013 Katsuma Tanaka. All rights reserved.
//

#import "LocalizationTestItems.h"

@implementation LocalizationTestItems

- (NSString *)testSingleString
{
    return NSLocalizedString(@"key1", nil);
}

- (NSString *)testAllMatches
{
    return NSLocalizedString(@"key", nil);
}

- (BOOL)testMultipleMatchesOnLine
{
    return [NSLocalizedString(@"key4", nil) isEqualToString:NSLocalizedString(@"key5", nil)];
}

@end
