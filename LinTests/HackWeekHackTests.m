//
//  HackWeekHackTests.m
//  Lin
//
//  Created by Kristin Ivarson on 6/7/13.
//  Copyright (c) 2013 Kristin Ivarson. All rights reserved.
//

#import "HackWeekHackTests.h"
#import "ZLocalizableParser.h"

@implementation HackWeekHackTests


- (void)testZLocalizableParser{
    NSString *filename = @"/Users/kristinivarson/RE2/libs/libZillow/libZMap/ZMap/en.lproj/Localizable.strings";
    NSString *library = [ZLocalizableParser getLibraryNameFromFilename:filename];
    STAssertTrue([library isEqualToString:@"libZMap"], @"Test failed");
    
    filename = @"/Users/kristinivarson/RE2/libs/libZillow/libZCommon/ZCommon/en.lproj/Localizable.strings";
    library = [ZLocalizableParser getLibraryNameFromFilename:filename];
    STAssertTrue([library isEqualToString:@"libZCommon"], @"Test failed");
    
    filename = @"/Users/kristinivarson/RE2/libs/libZillow/libZData/ZData/en.lproj/Localizable.strings";
    library = [ZLocalizableParser getLibraryNameFromFilename:filename];
    STAssertTrue([library isEqualToString:@"libZData"], @"Test failed");
    
    filename = @"/Users/kristinivarson/RE2/libs/libZillow/libZUI/ZUI/en.lproj/Localizable.strings";
    library = [ZLocalizableParser getLibraryNameFromFilename:filename];
    STAssertTrue([library isEqualToString:@"libZUI"], @"Test failed");
    
    filename = @"/Users/kristinivarson/RE2/libs/libZillow/libZWebservices/ZWebservices/en.lproj/Localizable.strings";
    library = [ZLocalizableParser getLibraryNameFromFilename:filename];
    STAssertTrue([library isEqualToString:@"libZWebservices"], @"Test failed");
    
    filename = @"/Users/kristinivarson/RE2/ZMap/en.lproj/Localizable.strings";
    library = [ZLocalizableParser getLibraryNameFromFilename:filename];
    STAssertTrue([library isEqualToString:@"Main"], @"Test failed");
    
    filename = @"malformed/libZ/lib/path";
    library = [ZLocalizableParser getLibraryNameFromFilename:filename];
    STAssertTrue([library isEqualToString:@"Unknown"], @"Test failed");
}

- (void)testZLocalizableStringsFileMatching{
    NSArray *files = @[@"/Users/kristinivarson/RE2/libs/libZillow/libZMap/ZMap/en.lproj/Localizable.strings",
                       @"/Users/kristinivarson/RE2/libs/libZillow/libZCommon/ZCommon/en.lproj/Localizable.strings",
                       @"/Users/kristinivarson/RE2/libs/libZillow/libZData/ZData/en.lproj/Localizable.strings",
                       @"/Users/kristinivarson/RE2/libs/libZillow/libZUI/ZUI/en.lproj/Localizable.strings",
                       @"/Users/kristinivarson/RE2/libs/libZillow/ZUIOptions/UIOptions/en.lproj/Localizable.strings",
                       @"/Users/kristinivarson/RE2/libs/libZillow/libZWebservices/ZWebservices/en.lproj/Localizable.strings",
                       @"/Users/kristinivarson/RE2/ZMap/en.lproj/Localizable.strings"
                       ];

    STAssertTrue([[ZLocalizableParser getBestStringsFileForFile:@"/Users/kristinivarson/RE2/libs/libZillow/libZMap/ZMap/MyMapAnnotationFile.m" fromList:files] isEqualToString:@"/Users/kristinivarson/RE2/libs/libZillow/libZMap/ZMap/en.lproj/Localizable.strings"], @"Test failed");

    STAssertTrue([[ZLocalizableParser getBestStringsFileForFile:@"/Users/kristinivarson/RE2/libs/libZillow/libZCommon/libZCommon/CommonFiles.mm" fromList:files] isEqualToString:@"/Users/kristinivarson/RE2/libs/libZillow/libZCommon/ZCommon/en.lproj/Localizable.strings"], @"Test failed");
    
    STAssertTrue([[ZLocalizableParser getBestStringsFileForFile:@"/Users/kristinivarson/RE2/Source/FavoritesTableViewController.m" fromList:files] isEqualToString:@"/Users/kristinivarson/RE2/ZMap/en.lproj/Localizable.strings"], @"Test failed");
    
    STAssertTrue([[ZLocalizableParser getBestStringsFileForFile:@"/Users/kristinivarson/RE2/libs/libZillow/ZUIOptions/ZUIOptions/PriceRangePickerActionSheet.m" fromList:files] isEqualToString:@"/Users/kristinivarson/RE2/libs/libZillow/ZUIOptions/UIOptions/en.lproj/Localizable.strings"], @"Test failed");
}

@end
