//
//  TestObjCClass.m
//  genstringsmerge
//
//  Created by Anton Grachev on 27/06/2017.
//  Copyright © 2017 Anton Grachev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestObjCClass : NSObject

- (void)methodWithLocalizedString;

@end

@implementation TestObjCClass

- (void)methodWithLocalizedString {
    NSString *firstString = NSLocalizedString(@"TestObjCClass.firstString", @"Localized string with key and comment only");
    NSString *secondString = NSLocalizedStringFromTable(@"TestObjCClass.secondString",
                                                        @"TestObjCClass",
                                                        @"Localized string from custom table");
    NSString *thirdString = NSLocalizedStringWithDefaultValue(@"TestObjCClass.thirdString",
                                                              nil,
                                                              nil,
                                                              @"default value",
                                                              @"Localized string with default value");
    
    NSLog(@"firstString: %@\nsecondString: %@\nthirdString: %@", firstString, secondString, thirdString);
}

@end
