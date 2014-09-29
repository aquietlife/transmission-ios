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

@end
