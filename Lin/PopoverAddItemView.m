//
//  PopoverAddItemView.m
//  Lin
//
//  Created by Kristin Ivarson on 6/10/13.
//  Copyright (c) 2013 Kristin Ivarson. All rights reserved.
//

#import "PopoverAddItemView.h"
#import "ZLocalizableParser.h"
#import "Lin.h"

#define TEXT_FIELD_WIDTH 200
#define TEXT_FIELD_HEIGHT 26

@implementation PopoverAddItemView

- (id)initWithFrame:(NSRect)frame forKey:(NSString *)key
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedKey = [key copy];
        
        
        [[NSColor colorWithDeviceRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1] set];
        [NSBezierPath fillRect:[self bounds]];
        
        NSTextField *label = [self createCenteredLabelForText:@"No matching key found." atHeight:150];
        [self addSubview:label];
        
        label = [self createCenteredLabelForText:@"Add it to the strings file now?" atHeight:130];
        [self addSubview:label];
        
        NSTextField *keyField = [self createCenteredTextFieldWithPlaceholder:@"Key" atHeight:90];
        [keyField setStringValue:self.selectedKey];
        [self addSubview:keyField];
        self.keyField = keyField;
        
        NSTextField *valueField = [self createCenteredTextFieldWithPlaceholder:@"Value" atHeight:50];
        [self addSubview:valueField];
        self.valueField = valueField;
        
        NSButton *submitButton = [[NSButton alloc] initWithFrame:CGRectMake(390, 50, 70, 34)];
        [submitButton setTitle:@"Add"];
        //[submitButton setButtonType:NSMomentaryLightButton];
        [submitButton setEnabled:YES];
        [submitButton setBezelStyle:NSRoundedBezelStyle];
        [submitButton setAction:@selector(buttonPressed)];
        [submitButton setTarget:self];
        [self addSubview:submitButton];
        self.submitButton = submitButton;
    }
    
    return self;
}

- (NSTextField *)createCenteredTextFieldWithPlaceholder:(NSString *)placeholder atHeight:(float)y
{
    float x = (self.frame.size.width/2) - (TEXT_FIELD_WIDTH / 2);
    NSTextField *textField = [[NSTextField alloc] initWithFrame:CGRectMake(x, y, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT)];
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = [[NSColor colorWithDeviceRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:1] CGColor];
    
    // Shadow approximates an inner-shadow
    textField.layer.shadowRadius = 0.3;
    textField.layer.shadowOffset = CGSizeMake(-1,-1);
    textField.layer.shadowOpacity = 0.25;
    textField.layer.shadowColor = [[NSColor blackColor] CGColor];
    [[textField cell] setPlaceholderString:placeholder];
    
    return textField;
}

- (NSTextField *)createCenteredLabelForText:(NSString *)labelText atHeight:(float)y
{
    NSTextField *label = [[NSTextField alloc] initWithFrame:NSMakeRect(0, y, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT)];
    [label setStringValue:labelText];
    [label setAlignment:NSCenterTextAlignment];
    CGRect frame = label.frame;
    frame.origin.x = (self.frame.size.width/2) - (frame.size.width / 2);
    [label setFrame:frame];
    
    [label setFont:[NSFont systemFontOfSize:13.f]];
    [label setBezeled:NO];
    [label setDrawsBackground:NO];
    [label setEditable:NO];
    [label setSelectable:NO];
    [label setWantsLayer:NO];
    return label;
}

- (void)buttonPressed
{
    [self.submitButton setEnabled:NO];
    
    NSString *newKey = self.keyField.stringValue;
    NSString *newValue = self.valueField.stringValue;
    [[Lin sharedPlugin] addLocalizationItemInCurrentPathForKey:newKey value:newValue];
}

@end
