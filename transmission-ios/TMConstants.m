//
//  TMConstants.m
//  transmission-ios
//
//  Created by Johann Diedrick on 9/29/14.
//  Copyright (c) 2014 Johann Diedrick. All rights reserved.
//

#import "TMConstants.h"

@implementation TMConstants

+ (UIColor*)greenColor {
    return [UIColor colorWithRed:3.0/255.0 green:255.0/255.0 blue:216.0/255.0 alpha:1.0];

}

+ (UIColor*)redColor {
    return [UIColor redColor];
    
}

+ (UIFont*)orbitronFontRegular:(CGFloat)size{
    return [UIFont fontWithName:@"Orbitron-Regular" size:size];
}

+ (UIFont*)orbitronFontBlack:(CGFloat)size{
    return [UIFont fontWithName:@"Orbitron-Black" size:size];
}

+ (UIFont*)orbitronFontMedium:(CGFloat)size{
    return [UIFont fontWithName:@"Orbitron-Medium" size:size];
}

+ (UIFont*)orbitronFontBold:(CGFloat)size{
    return [UIFont fontWithName:@"Orbitron-Regular" size:size];
}

+ (UIFont*)specialEliteFont:(CGFloat)size{
    return [UIFont fontWithName:@"SpecialElite-Regular" size:size];
}

+ (void) printFonts{
    // List all fonts on iPhone
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
}

@end
