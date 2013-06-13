//
//  ZFindNonlocalized.h
//  Lin
//
//  Created by Kristin Ivarson on 6/11/13.
//  Copyright (c) 2013 Katsuma Tanaka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCXcode.h"
#import "Localization.h"
#import "IDEIndexCollection.h"

@interface ZFindNonlocalized : NSObject

+ (void)searchForUnlocalizedStringsForIndex:(IDEIndex *)index  completionBlock:(void (^)(NSArray *errors))block;
+ (void)searchForKeysWithoutValuesForIndex:(IDEIndex *)index withLocalization:(Localization *)localizations completionBlock:(void (^)(NSArray *errors))block;

@end