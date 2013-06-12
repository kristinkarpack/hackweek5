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

+ (NSArray *)startSearchForUnlocalizedStringsForIndex:(IDEIndex *)index withLocalization:(Localization *)localizations;

@end