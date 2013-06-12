//
//  ZFindNonlocalized.m
//  Lin
//
//  Created by Kristin Ivarson on 6/11/13.
//  Copyright (c) 2013 Katsuma Tanaka. All rights reserved.
//

#import "ZFindNonlocalized.h"
#import "ZLocalizableParser.h"
#import "LocalizationItem.h"

#define NSLOCALIZED_REGEX @"LocalizedString\\s*?\\(\\s*?@\"(.*?)\"\\s*?,\\s*(.*?)\\s*?\\)"

@implementation ZFindNonlocalized

+ (NSArray *)startSearchForUnlocalizedStringsForIndex:(IDEIndex *)index withLocalization:(Localization *)localization
{
    // Get all files to parse calls from
    IDEIndexCollection *indexCollection = [index filesContaining:@".m" anchorStart:NO anchorEnd:NO subsequence:NO ignoreCase:YES cancelWhen:nil];
    
    NSMutableSet *fileSet = [NSMutableSet set];
    
    for(DVTFilePath *filePath in indexCollection) {
        NSString *pathString = filePath.pathString;
        [fileSet addObject:pathString];
    }
    
    // Now get instance of *LocalizedString(*,*) calls from all those files
    NSMutableDictionary *dictionaryOfKeysGroupedByLibrary = [[NSMutableDictionary alloc] init];
    for (NSString *sourceFilePath in fileSet)
    {
        NSError *error = nil;
        NSString *contents = [NSString stringWithContentsOfFile:sourceFilePath encoding:NSUTF8StringEncoding error:&error];

        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:NSLOCALIZED_REGEX options:0 error:NULL];
        [regularExpression enumerateMatchesInString:contents options:0 range:NSMakeRange(0, contents.length)
                                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
        {
            NSString *library = [ZLocalizableParser getLibraryNameFromSourceFilename:sourceFilePath];
            NSString *key = [contents substringWithRange:[result rangeAtIndex:1]];

            NSMutableArray *allKeysForLibrary = [dictionaryOfKeysGroupedByLibrary objectForKey:library];
            if (allKeysForLibrary == nil)
            {
                allKeysForLibrary = [NSMutableArray array];
                [dictionaryOfKeysGroupedByLibrary setObject:allKeysForLibrary forKey:library];
            }
            [allKeysForLibrary addObject:key];
        }];
    }
    
    
    // Also sort the localization keys by library
    NSMutableDictionary *localizationKeysFromStringsFilesGroupedByLibrary = [[NSMutableDictionary alloc] init];
    for (LocalizationItem *item in [localization localizationItems])
    {
        NSString *library = [ZLocalizableParser getLibraryNameFromStringsFilename:item.stringsFilename];
        NSMutableArray *allKeysForLibrary = [localizationKeysFromStringsFilesGroupedByLibrary objectForKey:library];
        if (allKeysForLibrary == nil)
        {
            allKeysForLibrary = [NSMutableArray array];
            [localizationKeysFromStringsFilesGroupedByLibrary setObject:allKeysForLibrary forKey:library];
        }
        [allKeysForLibrary addObject:item.key];
    }
    
    NSMutableArray *errors = [NSMutableArray array];
    
    // Now look at the difference between the two sets
    // TODO(kristini): add extra loop to deal with having a corresponding value for every langauge (one to many relationship)
    for (NSString *library in [dictionaryOfKeysGroupedByLibrary allKeys])
    {
        NSArray *keysInSourceFiles = [dictionaryOfKeysGroupedByLibrary objectForKey:library];
        NSArray *keysInStringsFiles = [localizationKeysFromStringsFilesGroupedByLibrary objectForKey:library];
        for (NSString *keyInSourceFile in keysInSourceFiles)
        {
            if (![keysInStringsFiles containsObject:keyInSourceFile])
            {
                [errors addObject:[NSString stringWithFormat:@"Cannot find value for key \"%@\" in library %@", keyInSourceFile, library]];
            }
        }
    }
    return errors;
}























@end
