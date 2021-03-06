//
//  AppDelegate.h
//  transmission-ios
//
//  Created by Johann Diedrick on 8/26/14.
//  Copyright (c) 2014 Johann Diedrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransmissionMainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TransmissionMainViewController* tmvc;
@property (strong, nonatomic) UINavigationController* navigationController;

@end
