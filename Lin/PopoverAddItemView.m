//
//  PopoverAddItemView.m
//  Lin
//
//  Created by Kristin Ivarson on 6/10/13.
//  Copyright (c) 2013 Katsuma Tanaka. All rights reserved.
//

#import "PopoverAddItemView.h"

#define TEXT_FIELD_WIDTH 100
#define TEXT_FIELD_HEIGHT 25

@implementation PopoverAddItemView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    [[NSColor lightGrayColor] set];
    [NSBezierPath fillRect:dirtyRect];
    
    NSTextField *langField = [self createCenteredTextFieldWithPlaceholder:@"Language" atHeight:120];
    [self addSubview:langField];
    NSTextField *keyField = [self createCenteredTextFieldWithPlaceholder:@"Key" atHeight:80];
    [self addSubview:keyField];
    NSTextField *valueField = [self createCenteredTextFieldWithPlaceholder:@"Value" atHeight:40];
    [self addSubview:valueField];
}


- (NSTextField *)createCenteredTextFieldWithPlaceholder:(NSString *)placeholder atHeight:(float)y
{
    float x = (self.frame.size.width/2) - (TEXT_FIELD_WIDTH / 2);
    NSTextField *textField = [[NSTextField alloc] initWithFrame:CGRectMake(x, y, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT)];
    [[textField cell] setPlaceholderString:placeholder];
    
    return textField;
}

@end
