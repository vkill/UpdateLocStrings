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
    NSString *firstString = NSLocalizedString(@"TestObjCClass.firstString", @"Updated localized string with key and comment only");
    NSString *secondString = NSLocalizedStringFromTable(@"TestObjCClass.secondString",
                                                        @"TestObjCClass",
                                                        @"Updated localized string from custom table");
    NSString *thirdString = NSLocalizedStringWithDefaultValue(@"TestObjCClass.thirdString",
                                                              nil,
                                                              nil,
                                                              @"Updated default value",
                                                              @"Updated Localized string with default value");
    NSString *fourthString = NSLocalizedStringFromTable(@"TestObjCClass.fourthString",
                                                        @"TestObjCClass",
                                                        @"Updated localized string from custom table");
    NSString *fifthString = NSLocalizedStringWithDefaultValue(@"TestObjCClass.thirdString",
                                                              nil,
                                                              nil,
                                                              @"Updated default value",
                                                              @"Updated Localized string with default value");
    
    NSLog(@"1: %@\2: %@\n3: %@\n4: %@\n5: %@", firstString, secondString, thirdString, fourthString, fifthString);
}

@end
