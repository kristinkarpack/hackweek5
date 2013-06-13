//
//  PopoverAddItemView.h
//  Lin
//
//  Created by Kristin Ivarson on 6/10/13.
//  Copyright (c) 2013 Kristin Ivarson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PopoverAddItemView : NSView<NSTextFieldDelegate>

@property (nonatomic, weak) NSTextField *keyField;
@property (nonatomic, weak) NSTextField *valueField;
@property (nonatomic, weak) NSButton *submitButton;
@property (nonatomic, copy) NSString *selectedKey;

- (id)initWithFrame:(NSRect)frameRect forKey:(NSString *)key;

@end
