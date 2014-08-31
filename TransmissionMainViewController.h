//
//  TransmissionMainViewController.h
//  transmission-ios
//
//  Created by Johann Diedrick on 8/26/14.
//  Copyright (c) 2014 Johann Diedrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioUnit/AudioUnit.h>

@interface TransmissionMainViewController : UIViewController
{
    UILabel *frequencyLabel;
    UIButton *playButton;
    UISlider *frequencySlider;
    AudioComponentInstance toneUnit;
    
@public
    double aFrequency;
    double eFrequency;
    double sampleRate;
    double aTheta;
    double eTheta;
    
}

@property (strong, nonatomic) UISlider* frequencySlider;
@property (strong, nonatomic) UIButton* playButton;
@property (strong, nonatomic) UILabel* frequencyLabel;

//second slider
@property (strong, nonatomic) UISlider* secondSlider;

- (void)sliderChanged:(UISlider *)slider;
- (void)togglePlay:(UIButton *)selectedButton;
- (void)stop;

@end
