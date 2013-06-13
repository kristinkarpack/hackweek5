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
@property (nonatomic, assign) IBOutlet NSTextField *titleLabel;
@property (nonatomic, assign) IBOutlet NSTableView *tableView;
@property (nonatomic, assign) IBOutlet NSProgressIndicator *spinner;
@property (nonatomic, assign) NSString *titleFormat;

@end
