//
//  ZUnlocalizedStringErrorViewController.h
//  Lin
//
//  Created by Kristin Ivarson on 6/12/13.
//  Copyright (c) 2013 Katsuma Tanaka. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ZUnlocalizedStringErrorViewController : NSViewController<NSTableViewDataSource>

@property (nonatomic, copy) void (^closeBlock)(id sender);
@property (nonatomic, copy) NSArray *errorItems;

@end
