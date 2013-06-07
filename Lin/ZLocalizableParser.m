//
//  ZLocalizableParser.m
//  Lin
//
//  Created by Kristin Ivarson on 6/7/13.
//  Copyright (c) 2013 Katsuma Tanaka. All rights reserved.
//

#import "ZLocalizableParser.h"

@implementation ZLocalizableParser

+ (NSString *)getLibraryNameFromFilename:(NSString *)filename
{
    if ([filename rangeOfString:@"lib"].location == NSNotFound)
    {
        return @"Main";
    }
    
    NSArray* pathComponents = [filename componentsSeparatedByString:@"/"];
    if (pathComponents == nil || [pathComponents count] <= 4)
    {
        return @"Unknown";
    }

    return [pathComponents objectAtIndex:([pathComponents count] - 4)];
}

@end
