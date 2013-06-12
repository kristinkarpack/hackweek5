//
//  ZUnlocalizedStringErrorViewController.m
//  Lin
//
//  Created by Kristin Ivarson on 6/12/13.
//  Copyright (c) 2013 Katsuma Tanaka. All rights reserved.
//

#import "ZUnlocalizedStringErrorViewController.h"

@implementation ZUnlocalizedStringErrorViewController

- (id)init
{
    self = [super init];
    if (self) {
        [NSBundle loadNibNamed:@"ZUnlocalizedStringErrorView" owner:self];
    }
    
    return self;
}

#pragma mark - target actions
- (IBAction)closeButtonClicked:(id)sender
{
    self.closeBlock(sender);
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.errorItems.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return [self.errorItems objectAtIndex:row];
}

@end
