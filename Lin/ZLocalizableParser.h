//
//  ZLocalizableParser.h
//  Lin
//
//  Created by Kristin Ivarson on 6/7/13.
//  Copyright (c) 2013 Katsuma Tanaka. All rights reserved.
//

@interface ZLocalizableParser : NSObject 

+ (NSString *)getLibraryNameFromFilename:(NSString *)filename;

+ (NSString *)getBestStringsFileForFile:(NSString *)fileName   fromList:(NSArray *)stringFiles;

@end
