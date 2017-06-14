//
//  TransmissionMainViewController.h
//  transmission-ios
//
//  Created by Johann Diedrick on 8/26/14.
//  Copyright (c) 2014 Johann Diedrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioUnit/AudioUnit.h>
#import "TMOscillator.h"
//#import <LARSTorch.h>
//#import "LARSStrobe.h"
//#import <EZAudio.h>
#import "TMAboutViewController.h"

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
    BOOL isAPlaying;
    BOOL isEPlaying;
    double aVolume;
    double eVolume;
    TMOscillator* aOscillator;
    TMOscillator* eOscillator;
    Float32 audioBuffer;
    
    
}

@property (strong, nonatomic) UISlider* frequencySlider;
@property (strong, nonatomic) UIButton* playButton;
@property (strong, nonatomic) UILabel* frequencyLabel;

//second slider
@property (strong, nonatomic) UISlider* secondSlider;

- (void)sliderChanged:(UISlider *)slider;
- (void)togglePlay:(UIButton *)selectedButton;
- (void)stop;

//ui

//about
@property (strong, nonatomic) UIButton *aboutButton;
@property (strong, nonatomic) UIButton *aboutButton2;

//a-e buttons
@property (strong, nonatomic) UIButton* aButton;
@property (strong, nonatomic) UIButton* eButton;

//a octaves
@property (strong, nonatomic) UIButton* a1Button;
@property (strong, nonatomic) UIButton* a2Button;
@property (strong, nonatomic) UIButton* a3Button;
@property (strong, nonatomic) UIButton* a4Button;
@property (strong, nonatomic) UIButton* a5Button;

//a octaves
@property (strong, nonatomic) UIButton* e1Button;
@property (strong, nonatomic) UIButton* e2Button;
@property (strong, nonatomic) UIButton* e3Button;
@property (strong, nonatomic) UIButton* e4Button;
@property (strong, nonatomic) UIButton* e5Button;

//volume sliders
@property (strong, nonatomic) UISlider* aVolumeSlider;
@property (strong, nonatomic) UISlider* eVolumeSlider;

//a synth types
@property (strong, nonatomic) UIButton* aSineButton;
@property (strong, nonatomic) UIButton* aSquareButton;
@property (strong, nonatomic) UIButton* aTriangleButton;
@property (strong, nonatomic) UIButton* aSawButton;
@property (strong, nonatomic) UIButton* aInverseSawButton;

//e synth types
@property (strong, nonatomic) UIButton* eSineButton;
@property (strong, nonatomic) UIButton* eSquareButton;
@property (strong, nonatomic) UIButton* eTriangleButton;
@property (strong, nonatomic) UIButton* eSawButton;
@property (strong, nonatomic) UIButton* eInverseSawButton;

//torch
//@property (strong, nonatomic) LARSTorch* torch;
//@property (strong, nonatomic) LARSStrobe* strobe;

//ezaudio plotter
//@property (strong, nonatomic) EZAudioPlotGL* audioPlot;

////oscillators!
//@property (strong, nonatomic) TMOscillator* aOscillator;
//@property (strong, nonatomic) TMOscillator* eOscillator;

@property (strong, nonatomic) TMAboutViewController* tmavc;

//about button glow
-(void)animateAboutButton;


@end
