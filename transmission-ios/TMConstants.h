//
//  TMConstants.h
//  transmission-ios
//
//  Created by Johann Diedrick on 9/29/14.
//  Copyright (c) 2014 Johann Diedrick. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UNICODE_SINE "\u223F"
#define UNICODE_SQUARE "\u25A0"
#define UNICODE_TRIANGLE "\u25B2"
#define UNICODE_SAW "\u26A1\uFE0E"


@interface TMConstants : NSObject

+ (UIColor*)greenColor;
+ (UIColor*)redColor;
+ (UIFont*)orbitronFontRegular:(CGFloat)size;
+ (UIFont*)orbitronFontMedium:(CGFloat)size;
+ (UIFont*)orbitronFontBold:(CGFloat)size;
+ (UIFont*)orbitronFontBlack:(CGFloat)size;
+ (UIFont*)specialEliteFont:(CGFloat)size;

//utility functions

+(void)printFonts;



@end
