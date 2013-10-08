//
//  ZUnlocalizedStringErrorViewController.h
//  Lin
//
//  Created by Kristin Ivarson on 6/12/13.
//  Copyright (c) 2013 Kristin Ivarson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ZUnlocalizedStringErrorViewController : NSViewController<NSTableViewDataSource>

@property (nonatomic, copy) void (^closeBlock)(id sender);
@property (nonatomic, copy) NSArray *errorItems;
@property (nonatomic, strong) IBOutlet NSTextField *titleLabel;
@property (nonatomic, strong) IBOutlet NSTableView *tableView;
@property (nonatomic, strong) IBOutlet NSProgressIndicator *spinner;
@property (nonatomic, strong) NSString *titleFormat;

@end
