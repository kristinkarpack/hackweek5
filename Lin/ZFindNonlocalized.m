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
#define UNLOCALIZED_REGEX @"(.*?)@\"(.*?)\""
// Try to avoid nib and image names, CoreData strings, dictionary keys, debug logs and asserts, etc.
#define EXCLUDE_STRINGS @[@"NSNotificationCenter", @"NibNamed", @"isKindOfClass", @"Log", @"assert", @"image", @"objectForKey", @"LocalizedString", @"BUNDLE", @"event", @"Image", @"NSFetch", @"_PROPERTY(", @"predicateWithFormat", @"pathForResource", @"fileURLWithPath", @"fontWithName", @"stringByAppendingPathComponent"]

@implementation ZFindNonlocalized

+ (void)searchForUnlocalizedStringsForIndex:(IDEIndex *)index completionBlock:(void (^)(NSArray *errors))block
{
    // Get all files to parse calls from
    IDEIndexCollection *indexCollection = [index filesContaining:@".m" anchorStart:NO anchorEnd:NO subsequence:NO ignoreCase:YES cancelWhen:nil];
    
    NSMutableSet *fileSet = [NSMutableSet set];
    
    for(DVTFilePath *filePath in indexCollection) {
        NSString *pathString = filePath.pathString;
        if (([pathString rangeOfString:@"Test"].location == NSNotFound) && ([pathString rangeOfString:@"Test"].location == NSNotFound))
        {
            [fileSet addObject:pathString];
        }
    }
    
    // Now search for strings
    NSMutableArray *unlocalizedStrings = [NSMutableArray array];
    for (NSString *sourceFilePath in fileSet)
    {
        NSError *error = nil;
        NSString *contents = [NSString stringWithContentsOfFile:sourceFilePath encoding:NSUTF8StringEncoding error:&error];
        
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:UNLOCALIZED_REGEX options:0 error:NULL];
        [regularExpression enumerateMatchesInString:contents options:0 range:NSMakeRange(0, contents.length)
                                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
         {
             NSString *match = [[contents substringWithRange:[result range]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
             BOOL shouldExclude = NO;
             for (NSString *exclude in EXCLUDE_STRINGS)
             {
                 if ([match rangeOfString:exclude].location != NSNotFound)
                 {
                     shouldExclude = YES;
                 }
             }
             if (!shouldExclude) {
                 [unlocalizedStrings addObject:
                    [NSString stringWithFormat:@"Possible unlocalized string in file %@: %@", [sourceFilePath lastPathComponent], match]];
              }
         }];
    }
    block(unlocalizedStrings);
}

+ (void)searchForKeysWithoutValuesForIndex:(IDEIndex *)index withLocalization:(Localization *)localization completionBlock:(void (^)(NSArray *errors))block
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
    NSMutableDictionary *localizationKeysFromStringsFilesGroupedByLibraryAndLanguage = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *allLanguagesGroupedByLibraries = [[NSMutableDictionary alloc] init];
    for (LocalizationItem *item in [localization localizationItems])
    {
        NSString *library = [ZLocalizableParser getLibraryNameFromStringsFilename:item.stringsFilename];
        NSMutableDictionary *allKeysForLibrary = [localizationKeysFromStringsFilesGroupedByLibraryAndLanguage objectForKey:library];
        if (allKeysForLibrary == nil)
        {
            allKeysForLibrary = [[NSMutableDictionary alloc] init];
            [localizationKeysFromStringsFilesGroupedByLibraryAndLanguage setObject:allKeysForLibrary forKey:library];
        }
        NSMutableArray *itemsForLibraryAndLanguage = [allKeysForLibrary objectForKey:item.language];
        if (itemsForLibraryAndLanguage == nil)
        {
            itemsForLibraryAndLanguage = [NSMutableArray array];
            [allKeysForLibrary setObject:itemsForLibraryAndLanguage forKey:item.language];
        }
        [itemsForLibraryAndLanguage addObject:item.key];
        NSMutableSet *allLanguagesForLibrary = [allLanguagesGroupedByLibraries objectForKey:library];
        if (allLanguagesForLibrary == nil)
        {
            allLanguagesForLibrary = [[NSMutableSet alloc] init];
            [allLanguagesGroupedByLibraries setObject:allLanguagesForLibrary forKey:library];
        }
        [allLanguagesForLibrary addObject:item.language];
    }
    
    NSMutableArray *errors = [NSMutableArray array];
    
    // Now look at the difference between the two sets
    // TODO(kristini): add extra loop to deal with having a corresponding value for every langauge (one to many relationship)
    for (NSString *library in [dictionaryOfKeysGroupedByLibrary allKeys])
    {
        NSArray *keysInSourceFiles = [dictionaryOfKeysGroupedByLibrary objectForKey:library];
        NSMutableDictionary *keysInStringsFilesGroupedByLanguage = [localizationKeysFromStringsFilesGroupedByLibraryAndLanguage objectForKey:library];
        NSSet *allLanguagesForLibrary = [allLanguagesGroupedByLibraries objectForKey:library];
        for (NSString *keyInSourceFile in keysInSourceFiles)
        {
            for (NSString *language in allLanguagesForLibrary)
            {
                NSArray *keysInStringsFilesForLangauge = [keysInStringsFilesGroupedByLanguage objectForKey:language];
                if (![keysInStringsFilesForLangauge containsObject:keyInSourceFile])
                {
                    [errors addObject:[NSString stringWithFormat:@"Missing key \"%@\" in library %@ for language \"%@\"", keyInSourceFile, library, language]];
                }
            }
        }
    }
    block(errors);
}

@end
