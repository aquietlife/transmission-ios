//
//  TransmissionMainViewController.m
//  transmission-ios
//
//  Created by Johann Diedrick on 8/26/14.
//  Copyright (c) 2014 Johann Diedrick. All rights reserved.
//
//  Based on the ToneGenerator example by Matt Gallagher, 2010
//  http://www.cocoawithlove.com/2010/10/ios-tone-generator-introduction-to.html
//

#import "TransmissionMainViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>

#define A_FREQUENCY 440.0
#define E_FREQUENCY 330.0
#define SAMPLE_RATE 44100

OSStatus RenderTone(
                    void *inRefCon,
                    AudioUnitRenderActionFlags *ioActionFlags,
                    const AudioTimeStamp *inTimeStamp,
                    UInt32 inBusNumber,
                    UInt32 inNumberFrames,
                    AudioBufferList *ioData)

{
    const double amplitude = 0.25; // fixed amplitude for now, will want to change for individual tone volume
    
    //get tone parameters out of view controller...im not really sure how this works or what it does :x
    //maybe this will make more sense if we have sine synths as objects down the road..w/e
    TransmissionMainViewController *tmvc = (__bridge TransmissionMainViewController *) inRefCon;
    
    
    //setup theta
    double aTheta = tmvc->aTheta;
    double eTheta = tmvc->eTheta;
    
    
    //setup theta increment
    double a_theta_increment = 2.0 * M_PI * tmvc->aFrequency / tmvc->sampleRate;
    double e_theta_increment = 2.0 * M_PI * tmvc->eFrequency / tmvc->sampleRate;
    
    //mono tone generator, only need first buffer
    const int channel = 0;
    Float32 *buffer = (Float32 *) ioData->mBuffers[channel].mData;
    
    //generate the samples
    
    BOOL isAPlaying = tmvc->isAPlaying;
    BOOL isEPlaying = tmvc->isEPlaying;
    
    double aVolume = tmvc->aVolume;
    double eVolume = tmvc->eVolume;
    
//    if (isAPlaying){
//        aVolume = tmvc->aVolume;
//    }else{
//        aVolume = 0.0;
//    }
//    
//    if (isEPlaying){
//        eVolume = tmvc->eVolume;
//    }else{
//        eVolume = 0.0;
//    }
//    
    
    /*
    if (isAPlaying && isEPlaying) {
        for (UInt32 frame = 0; frame < inNumberFrames; frame++) {
            
            buffer[frame] = ( (sin(aTheta) + sin(eTheta)) / 2 ) * amplitude;
            
            aTheta += a_theta_increment;
            eTheta += e_theta_increment;
            
            if (aTheta > 2.0 * M_PI ){ // if theta goes over 2PI, reset by 2PI
                aTheta -= 2.0 * M_PI;
            }
            
            if (eTheta > 2.0 * M_PI ){ // if theta goes over 2PI, reset by 2PI
                eTheta -= 2.0 * M_PI;
            }
            
        }
    }
    
    else if (isAPlaying) {
        for (UInt32 frame = 0; frame < inNumberFrames; frame++) {
            
            buffer[frame] = sin(aTheta)  * amplitude;
            
            aTheta += a_theta_increment;
            
            if (aTheta > 2.0 * M_PI ){ // if theta goes over 2PI, reset by 2PI
                aTheta -= 2.0 * M_PI;
            }
            

            
        }
    } else if (isEPlaying) {
        for (UInt32 frame = 0; frame < inNumberFrames; frame++) {
            
            buffer[frame] = sin(eTheta) * amplitude;
            
            eTheta += e_theta_increment;
            
            
            if (eTheta > 2.0 * M_PI ){ // if theta goes over 2PI, reset by 2PI
                eTheta -= 2.0 * M_PI;
            }
            
        }
    }
     */
    
    TMOscillator* aOscillator = tmvc->aOscillator;
    //[aOscillator setType:inverseSawWave];
    
    TMOscillator* eOscillator = tmvc->eOscillator;
    //[eOscillator setType:squareWave];
    
    
        if (isAPlaying){
            [aOscillator setVolume:tmvc->aVolume];
        }else{
            [aOscillator setVolume:0.0];
        }
    
        if (isEPlaying){
            [eOscillator setVolume:tmvc->eVolume];
        }else{
            [eOscillator setVolume:0.0];
        }
    
    
    
    for (UInt32 frame = 0; frame < inNumberFrames; frame++) {
        
        buffer[frame] = ( [aOscillator getSample:aTheta] + [eOscillator getSample:eTheta] ) / 2;
        //sine
        //buffer[frame] = ( sin(aTheta) * aVolume);//  +  sin(eTheta) * eVolume )  / 2 ;
        
        
        //square
        //buffer[frame] = ( ( (sin(aTheta) > 0 ? 1: -1) * aVolume)  +   (sin(eTheta) > 0 ? 1: -1) * eVolume )  / 2 ;
        
        //(sin(aTheta) > 0 ? 1: -1) * volume;
        
        /*
        //triangle
        float aPct = aTheta / M_2_PI;
        float ePct = eTheta / M_2_PI;
        buffer[frame] = ( ((aPct < 0.5 ? [self map:aPct inputMin:0.0 inputMax:0.5 outputMin:-1 outputMax:1] : [self map:aPct inputMin:0.5 inputMax:1.0 outputMin:1.0 outputMax:-1.0]) * aVolume) + ((ePct < 0.5 ? [self map:ePct inputMin:0.0 inputMax:0.5 outputMin:-1 outputMax:1] : [self map:ePct inputMin:0.5 inputMax:1.0 outputMin:1.0 outputMax:-1.0]) * eVolume) )/ 2;

        
        buffer[frame] = ( ([aOscillator getSample] * aVolume)  +  ([eOscillator getSample] * eVolume) )  / 2 ;
         */
        
        
        aTheta += a_theta_increment;
        eTheta += e_theta_increment;
        
        if (aTheta > 2.0 * M_PI ){ // if theta goes over 2PI, reset by 2PI
            aTheta -= 2.0 * M_PI;
        }
        
        if (eTheta > 2.0 * M_PI ){ // if theta goes over 2PI, reset by 2PI
            eTheta -= 2.0 * M_PI;
        }
        
    }
    
    //NSLog(@"a phase: %f", aOscillator->phase);
    //NSLog(@"a theta: %f", aTheta);

    
    
    //store theta back in the view controller
    
    tmvc->aTheta = aTheta;
    tmvc->eTheta = eTheta;
    
    tmvc->isAPlaying = isAPlaying;
    tmvc->isEPlaying = isEPlaying;
    
    return noErr;
    
}

void ToneInturruptionListener(void *inClientData, UInt32 inInturruptionState){
    TransmissionMainViewController *tmvc = (__bridge TransmissionMainViewController*)inClientData;
    
    [tmvc stop];
}

@interface TransmissionMainViewController ()

@end

@implementation TransmissionMainViewController


-(void)createToneUnit{
    //configure the search parameters to find the default playback output unit
    //kAudioUnitSubType_RemoteIO on iOS, kAudioUnitSubType_DefaultOutput on Mac OS X
    
    AudioComponentDescription defaultOutputDescription;
    defaultOutputDescription.componentType = kAudioUnitType_Output;
    defaultOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
    defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
    defaultOutputDescription.componentFlags = 0;
    defaultOutputDescription.componentFlagsMask = 0;
    
    //get the default playback output unit
    AudioComponent defaultOutput = AudioComponentFindNext(NULL, &defaultOutputDescription);
    NSAssert(defaultOutput, @"Can't find default output!");
    
    //create a new unit based on this that we will use for output
    OSErr err = AudioComponentInstanceNew(defaultOutput, &toneUnit);
    NSAssert1(toneUnit, @"Error creating unit: %ld", err);
    
    //set our tone rendering function on the unit
    AURenderCallbackStruct input;
    input.inputProc = RenderTone;
    input.inputProcRefCon = (__bridge void *)(self);
    err = AudioUnitSetProperty(toneUnit,
                               kAudioUnitProperty_SetRenderCallback,
                               kAudioUnitScope_Input,
                               0,
                               &input,
                               sizeof(input));
    NSAssert1(err == noErr, @"Error setting callback: %ld", err);
    
    
    //set the format to 32bit, single channel, floating pt, linear PCM
    const int four_bytes_per_float = 4;
    const int eight_bits_per_byte = 8;
    AudioStreamBasicDescription streamFormat;
    streamFormat.mSampleRate = sampleRate;
    streamFormat.mFormatID = kAudioFormatLinearPCM;
    streamFormat.mFormatFlags = kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
    streamFormat.mBytesPerPacket = four_bytes_per_float;
    streamFormat.mFramesPerPacket = 1; // forgot this!
    streamFormat.mBytesPerFrame = four_bytes_per_float; // forgot this too!
    streamFormat.mChannelsPerFrame = 1;
    streamFormat.mBitsPerChannel = four_bytes_per_float * eight_bits_per_byte;
    err = AudioUnitSetProperty(toneUnit,
                               kAudioUnitProperty_StreamFormat,
                               kAudioUnitScope_Input,
                               0,
                               &streamFormat,
                               sizeof(AudioStreamBasicDescription));
    NSAssert1(err == noErr, @"Error setting stream format: %ld", err); // = != == ...
     
    
    
}

-(void)togglePlay:(UIButton *)selectedButton{
    if (toneUnit) {
        
        AudioOutputUnitStop(toneUnit);
        AudioUnitUninitialize(toneUnit);
        AudioComponentInstanceDispose(toneUnit);
        toneUnit = nil;
        
        [selectedButton setTitle:NSLocalizedString(@"Play", nil) forState:0];
        
    }else{
        [self createToneUnit];
        
        //stop changing parameters on the unit
        OSErr err = AudioUnitInitialize(toneUnit);
        NSAssert1(err == noErr, @"Error initializing unit: %ld", err);
        
        //start playback
        err = AudioOutputUnitStart(toneUnit);
        NSAssert1(err == noErr, @"Error starting unit: %ld", err);
        
        [selectedButton setTitle:NSLocalizedString(@"Stop", nil) forState:0];
    }
}

-(void)stop{
    if (toneUnit) {
        [self togglePlay:playButton];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
        //[fontNames release];
    }
    //[familyNames release];
    
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    
    [self setupOscillators];
    [self setupUI];
    [self setupTorch];
    [self setupAudioPlot];
    
    isAPlaying = NO;
    isEPlaying = NO;
    
    aVolume = _aVolumeSlider.value;
    eVolume = _eVolumeSlider.value;
    
    OSStatus result = AudioSessionInitialize(NULL, NULL, ToneInturruptionListener, (__bridge void *)(self));
    if (result == kAudioSessionNoError) {
        UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                                sizeof(sessionCategory),
                                &sessionCategory);
    }
    AudioSessionSetActive(true);
    
    aFrequency = A_FREQUENCY;
    eFrequency = E_FREQUENCY;
    
    [self togglePlay:playButton];
    [self drawBufferPlot];
}

-(void)viewDidUnload{
    self.frequencyLabel = nil;
    self.playButton = nil;
    self.frequencySlider = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Audio

-(void)setupOscillators{
    sampleRate = SAMPLE_RATE;
    
    //setup a oscillator
    aOscillator = [[TMOscillator alloc] init];
    [aOscillator setup:sampleRate];
    [aOscillator setFrequency:440.0];
    [aOscillator setType:sineWave];
    [aOscillator setVolume:0.25];
    
    eOscillator = [[TMOscillator alloc] init];
    [eOscillator setup:sampleRate];
    [eOscillator setFrequency:330.0];
    [eOscillator setType:sineWave];
    [eOscillator setVolume:0.25];
    
}


#pragma mark - UI


-(void)setupUI{
    
    //about button
    CGFloat about_button_width = 200.0;
    _aboutButton = [[UIButton alloc] initWithFrame:CGRectMake(
                                                              self.view.frame.size.width/2 - about_button_width/2,
                                                              30,
                                                              about_button_width,
                                                              20)];
    [_aboutButton setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_aboutButton setBackgroundColor:[UIColor blackColor]];
    [_aboutButton setTitle:@"TRANSMISSIONS" forState:UIControlStateNormal];
    [_aboutButton.titleLabel setFont:[TMConstants orbitronFontMedium:18]];
    [_aboutButton addTarget:self action:@selector(aboutButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_aboutButton];
    
    
    UIColor* button_color = [TMConstants greenColor];
    
    CGFloat synth_button_size = 100.0;

    //set up a button
    _aButton = [[UIButton alloc] initWithFrame:CGRectMake(
                                                          (self.view.frame.size.width/2)-synth_button_size/2,
                                                          70,
                                                          synth_button_size,
                                                          synth_button_size)];
    [_aButton setTitle:@"A" forState:UIControlStateNormal];
    [_aButton setBackgroundColor:button_color];
    [_aButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_aButton.titleLabel setFont:[TMConstants orbitronFontBlack:64]];
    [_aButton addTarget:self action:@selector(aButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_aButton];
    
    //set up e button
    _eButton = [[UIButton alloc] initWithFrame:CGRectMake(
                                                          (self.view.frame.size.width/2)-synth_button_size/2,
                                                          (self.view.frame.size.height/2)+synth_button_size/2,
                                                          synth_button_size,
                                                          synth_button_size)];
    [_eButton setTitle:@"E" forState:UIControlStateNormal];
    [_eButton setBackgroundColor:button_color];
    [_eButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_eButton.titleLabel setFont:[TMConstants orbitronFontBlack:64]];
    [_eButton addTarget:self action:@selector(eButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_eButton];
    
    CGFloat offset = 50.0;
    CGFloat octave_spacing = 10.0;
    CGFloat octave_button_size = 40.0;
    CGFloat octave_y_position = 200.0;
    
    //set up a octaves
    _a1Button = [[UIButton alloc] initWithFrame:CGRectMake(offset + octave_spacing,
                                                           octave_y_position,
                                                           octave_button_size,
                                                           octave_button_size)];
    [_a1Button setBackgroundColor:[UIColor blackColor]];
    [_a1Button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_a1Button setTitle:@"A1" forState:UIControlStateNormal];
    [_a1Button.titleLabel setFont:[TMConstants orbitronFontBold:16]];
    [_a1Button addTarget:self action:@selector(a1ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_a1Button];
    
    _a2Button = [[UIButton alloc] initWithFrame:CGRectMake(offset + octave_spacing*2+octave_button_size,
                                                           octave_y_position,
                                                           octave_button_size,
                                                           octave_button_size)];
    [_a2Button setBackgroundColor:[UIColor blackColor]];
    [_a2Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_a2Button setTitle:@"A2" forState:UIControlStateNormal];
    [_a2Button.titleLabel setFont:[TMConstants orbitronFontBold:16]];
    [_a2Button addTarget:self action:@selector(a2ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_a2Button];
    
    _a3Button = [[UIButton alloc] initWithFrame:CGRectMake(offset + octave_spacing*3+octave_button_size*2,
                                                           octave_y_position,
                                                           octave_button_size,
                                                           octave_button_size)];
    [_a3Button setBackgroundColor:[UIColor blackColor]];
    [_a3Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_a3Button setTitle:@"A3" forState:UIControlStateNormal];
    [_a3Button.titleLabel setFont:[TMConstants orbitronFontBold:16]];
    [_a3Button addTarget:self action:@selector(a3ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_a3Button];
    
    _a4Button = [[UIButton alloc] initWithFrame:CGRectMake(offset + octave_spacing*4+octave_button_size*3,
                                                           octave_y_position,
                                                           octave_button_size,
                                                           octave_button_size)];
    [_a4Button setBackgroundColor:[UIColor blackColor]];
    [_a4Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_a4Button setTitle:@"A4" forState:UIControlStateNormal];
    [_a4Button.titleLabel setFont:[TMConstants orbitronFontBold:16]];
    [_a4Button addTarget:self action:@selector(a4ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_a4Button];
    
    _a5Button = [[UIButton alloc] initWithFrame:CGRectMake(offset + octave_spacing*5+octave_button_size*4,
                                                           octave_y_position,
                                                           octave_button_size,
                                                           octave_button_size)];
    [_a5Button setBackgroundColor:[UIColor blackColor]];
    [_a5Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_a5Button setTitle:@"A0" forState:UIControlStateNormal];
    [_a5Button.titleLabel setFont:[TMConstants orbitronFontBold:16]];
    [_a5Button addTarget:self action:@selector(a5ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_a5Button];
    
    
    //set up e octaves
    CGFloat e_octave_y_position = self.view.frame.size.height - 40.0;
    

    _e1Button = [[UIButton alloc] initWithFrame:CGRectMake(offset + octave_spacing,
                                                           e_octave_y_position,
                                                           octave_button_size,
                                                           octave_button_size)];
    [_e1Button setBackgroundColor:[UIColor blackColor]];
    [_e1Button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_e1Button setTitle:@"E1" forState:UIControlStateNormal];
    [_e1Button.titleLabel setFont:[TMConstants orbitronFontBold:16]];
    [_e1Button addTarget:self action:@selector(e1ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_e1Button];
    
    _e2Button = [[UIButton alloc] initWithFrame:CGRectMake(offset + octave_spacing*2+octave_button_size,
                                                           e_octave_y_position,
                                                           octave_button_size,
                                                           octave_button_size)];
    [_e2Button setBackgroundColor:[UIColor blackColor]];
    [_e2Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_e2Button setTitle:@"E2" forState:UIControlStateNormal];
    [_e2Button.titleLabel setFont:[TMConstants orbitronFontBold:16]];
    [_e2Button addTarget:self action:@selector(e2ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_e2Button];
    
    _e3Button = [[UIButton alloc] initWithFrame:CGRectMake(offset + octave_spacing*3+octave_button_size*2,
                                                           e_octave_y_position,
                                                           octave_button_size,
                                                           octave_button_size)];
    [_e3Button setBackgroundColor:[UIColor blackColor]];
    [_e3Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_e3Button setTitle:@"E3" forState:UIControlStateNormal];
    [_e3Button.titleLabel setFont:[TMConstants orbitronFontBold:16]];
    [_e3Button addTarget:self action:@selector(e3ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_e3Button];
    
    _e4Button = [[UIButton alloc] initWithFrame:CGRectMake(offset + octave_spacing*4+octave_button_size*3,
                                                           e_octave_y_position,
                                                           octave_button_size,
                                                           octave_button_size)];
    [_e4Button setBackgroundColor:[UIColor blackColor]];
    [_e4Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_e4Button setTitle:@"E4" forState:UIControlStateNormal];
    [_e4Button.titleLabel setFont:[TMConstants orbitronFontBold:16]];
    [_e4Button addTarget:self action:@selector(e4ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_e4Button];
    
    _e5Button = [[UIButton alloc] initWithFrame:CGRectMake(offset + octave_spacing*5+octave_button_size*4,
                                                           e_octave_y_position,
                                                           octave_button_size,
                                                           octave_button_size)];
    [_e5Button setBackgroundColor:[UIColor blackColor]];
    [_e5Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_e5Button setTitle:@"E0" forState:UIControlStateNormal];
    [_e5Button.titleLabel setFont:[TMConstants orbitronFontBold:16]];
    [_e5Button addTarget:self action:@selector(e5ButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_e5Button];
    
    //setup volume sliders
    CGFloat slider_x_spacing = 100.0;
    CGFloat slider_y_spacing = 100.0;
    CGFloat slider_width = 150.0;
    CGFloat slider_height = 20.0;
    CGFloat max_volume = 0.25;
    
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * -0.5);
    
    _aVolumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(
                                                                self.view.frame.size.width
                                                                
                                                                -slider_x_spacing,
                                                                
                                                                slider_y_spacing,
                                                                
                                                                slider_width,
                                                                
                                                                slider_height)];
    [_aVolumeSlider setMinimumValue:0.0];
    [_aVolumeSlider setMaximumValue:max_volume];
    [_aVolumeSlider addTarget:self action:@selector(aVolumeSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [_aVolumeSlider setValue:0.25];
    [_aVolumeSlider setTintColor:button_color];
    [_aVolumeSlider setThumbImage:[UIImage imageNamed:@"launch@2x.png"] forState:UIControlStateNormal]; //hack for known bug
    [_aVolumeSlider setThumbTintColor:button_color];
    [_aVolumeSlider setMaximumTrackTintColor:[UIColor blackColor]];
    _aVolumeSlider.transform = trans;
    [self.view addSubview:_aVolumeSlider];
    
    _eVolumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(
                                                                self.view.frame.size.width-slider_x_spacing,
                                                                
                                                                self.view.frame.size.height/2 + slider_y_spacing,
                                                                
                                                                slider_width,
                                                                
                                                                slider_height)];
    [_eVolumeSlider setMinimumValue:0.0];
    [_eVolumeSlider setMaximumValue:max_volume];
    [_eVolumeSlider setValue:0.25];
    [_eVolumeSlider setTintColor:button_color];
    [_eVolumeSlider setThumbImage:[UIImage imageNamed:@"launch@2x.png"] forState:UIControlStateNormal]; //hack for known bug
    [_eVolumeSlider setThumbTintColor:button_color];
    [_eVolumeSlider setMaximumTrackTintColor:[UIColor blackColor]];
    [_eVolumeSlider addTarget:self action:@selector(eVolumeSliderChanged:) forControlEvents:UIControlEventValueChanged];
    _eVolumeSlider.transform = trans;

    [self.view addSubview:_eVolumeSlider];
    
    //a synth type buttons
    
    CGFloat synth_type_button_size = 35.0;
    CGFloat synth_type_hspacing = 20.0;
    CGFloat synth_type_vspacing = 20.0;
    CGFloat synth_type_top_spacing = 20.0;
    CGFloat synth_type_bottom_spacing = 20.0;
    CGFloat synth_type_radius = synth_type_button_size/2.0;
    
    _aSineButton = [[UIButton alloc] initWithFrame:CGRectMake(synth_type_hspacing,
                                                              synth_type_top_spacing,
                                                              synth_type_button_size,
                                                              synth_type_button_size)];
    [_aSineButton setBackgroundColor:[UIColor redColor]];
    [_aSineButton setTitle:@UNICODE_SINE forState:UIControlStateNormal];
    [_aSineButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_aSineButton addTarget:self action:@selector(aSineButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_aSineButton.layer setCornerRadius:synth_type_radius];
    [self.view addSubview:_aSineButton];
    
    _aSquareButton = [[UIButton alloc] initWithFrame:CGRectMake(synth_type_hspacing,
                                                                synth_type_top_spacing+
                                                                synth_type_vspacing+
                                                                synth_type_button_size,
                                                                synth_type_button_size,
                                                                synth_type_button_size)];
    [_aSquareButton setBackgroundColor:button_color];
    [_aSquareButton setTitle:@UNICODE_SQUARE forState:UIControlStateNormal];
    [_aSquareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_aSquareButton addTarget:self action:@selector(aSquareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_aSquareButton.layer setCornerRadius:synth_type_radius];
    [self.view addSubview:_aSquareButton];
    
    _aTriangleButton = [[UIButton alloc] initWithFrame:CGRectMake(synth_type_hspacing,
                                                                  synth_type_top_spacing+synth_type_vspacing*2+synth_type_button_size*2,
                                                                  synth_type_button_size, synth_type_button_size)];
    [_aTriangleButton setBackgroundColor:button_color];
    [_aTriangleButton setTitle:@UNICODE_TRIANGLE forState:UIControlStateNormal];
    [_aTriangleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_aTriangleButton addTarget:self action:@selector(aTriangleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_aTriangleButton.layer setCornerRadius:synth_type_radius];
    [self.view addSubview:_aTriangleButton];
    
    _aSawButton = [[UIButton alloc] initWithFrame:CGRectMake(synth_type_hspacing,
                                                             synth_type_top_spacing+
                                                             synth_type_vspacing*3+
                                                             synth_type_button_size*3,
                                                             synth_type_button_size,
                                                             synth_type_button_size)];
    [_aSawButton setBackgroundColor:button_color];
    [_aSawButton setTitle:@UNICODE_SAW forState:UIControlStateNormal];
    [_aSawButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_aSawButton addTarget:self action:@selector(aSawButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_aSawButton.layer setCornerRadius:synth_type_radius];
    [self.view addSubview:_aSawButton];
    
    /*
    _aInverseSawButton = [[UIButton alloc] initWithFrame:CGRectMake(synth_type_hspacing,
                                                                    synth_type_top_spacing+
                                                                    synth_type_vspacing*4+
                                                                    synth_type_button_size*4,
                                                                    synth_type_button_size,
                                                                    synth_type_button_size)];
    [_aInverseSawButton setBackgroundColor:button_color];
    [_aInverseSawButton setTitle:@"I" forState:UIControlStateNormal];
    [_aInverseSawButton addTarget:self action:@selector(aInverseSawButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_aInverseSawButton];
     */
    
    //e synth type buttons
    
    CGFloat y_synth_type_buttons_offset = (self.view.frame.size.height/2) + 20;
    
    _eSineButton = [[UIButton alloc] initWithFrame:CGRectMake(synth_type_hspacing,
                                                              
                                                              y_synth_type_buttons_offset,
                                                              
                                                              synth_type_button_size,
                                                              
                                                              synth_type_button_size)];
    [_eSineButton setBackgroundColor:[UIColor redColor]];
    [_eSineButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_eSineButton setTitle:@UNICODE_SINE forState:UIControlStateNormal];
    [_eSineButton.layer setCornerRadius:synth_type_radius];
    [_eSineButton addTarget:self action:@selector(eSineButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_eSineButton];
    
    _eSquareButton = [[UIButton alloc] initWithFrame:CGRectMake(synth_type_hspacing,
                                                                
                                                                y_synth_type_buttons_offset +
                                                                synth_type_vspacing +
                                                                synth_type_button_size,
                                                                
                                                                synth_type_button_size,
                                                                
                                                                synth_type_button_size)];
    [_eSquareButton setBackgroundColor:button_color];
    [_eSquareButton setTitle:@UNICODE_SQUARE forState:UIControlStateNormal];
    [_eSquareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_eSquareButton.layer setCornerRadius:synth_type_radius];
    [_eSquareButton addTarget:self action:@selector(eSquareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_eSquareButton];
    
    _eTriangleButton = [[UIButton alloc] initWithFrame:CGRectMake(synth_type_hspacing,
                                                                  
                                                                  y_synth_type_buttons_offset +
                                                                  synth_type_vspacing*2 +
                                                                  synth_type_button_size*2,
                                                                  
                                                                  synth_type_button_size,
                                                                  
                                                                  synth_type_button_size)];
    [_eTriangleButton setBackgroundColor:button_color];
    [_eTriangleButton setTitle:@UNICODE_TRIANGLE forState:UIControlStateNormal];
    [_eTriangleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_eTriangleButton.layer setCornerRadius:synth_type_radius];
    [_eTriangleButton addTarget:self action:@selector(eTriangleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_eTriangleButton];
    
    _eSawButton = [[UIButton alloc] initWithFrame:CGRectMake(synth_type_hspacing,
                                                             
                                                             y_synth_type_buttons_offset +
                                                             synth_type_vspacing*3 +
                                                             synth_type_button_size*3,
                                                             
                                                             synth_type_button_size,
                                                             
                                                             synth_type_button_size)];
    [_eSawButton setBackgroundColor:button_color];
    [_eSawButton setTitle:@UNICODE_SAW forState:UIControlStateNormal];
    [_eSawButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_eSawButton.layer setCornerRadius:synth_type_radius];
    [_eSawButton addTarget:self action:@selector(eSawButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_eSawButton];
    
    /*
    _eInverseSawButton = [[UIButton alloc] initWithFrame:CGRectMake(synth_type_hspacing,
                                                                    
                                                                    y_synth_type_buttons_offset +
                                                                    synth_type_vspacing*4 +
                                                                    synth_type_button_size*4,
                                                                    
                                                                    synth_type_button_size,
                                                                    
                                                                    synth_type_button_size)];
    [_eInverseSawButton setBackgroundColor:button_color];
    [_eInverseSawButton setTitle:@"I" forState:UIControlStateNormal];
    [_eInverseSawButton addTarget:self action:@selector(eInverseSawButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_eInverseSawButton];
     */
    
    //mid line
    UIView* midline = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 1)];
    [midline setBackgroundColor:[TMConstants greenColor]];
    [self.view addSubview:midline];
    
}


-(void)aboutButtonPressed:(id)sender{
    //setup tmavc and send it over
    _tmavc = [[TMAboutViewController alloc] init];
    //[self presentViewController:_tmavc animated:YES completion:nil];
    NSLog(@"this is being pressed");
    [self.navigationController pushViewController:_tmavc animated:YES];
}

-(void)aButtonPressed:(id)sender{
    
    isAPlaying = !isAPlaying;
    
    NSLog(@"is a playing: %hhd", isAPlaying);
    
    if (isAPlaying) { // if a is playing and e isn't, start strobing
        [_aButton setBackgroundColor:[TMConstants redColor]];
        if (!isEPlaying) {
            if (![_strobe isRunning]) {
                [_strobe turnOn];
                [_strobe startStrobe];
            }
        }
    }
    else if (!isAPlaying){
        [_aButton setBackgroundColor:[TMConstants greenColor]];
        if (!isEPlaying) {
            if ([_strobe isRunning]) {
                [_strobe stopStrobe];
                [_strobe turnOff];
            }
        }
    }
}

-(void)eButtonPressed:(id)sender{
    
    isEPlaying = !isEPlaying;
    NSLog(@"is e playing: %hhd", isEPlaying);

    if (isEPlaying) { // if e is playing and e isn't start strobing
        [_eButton setBackgroundColor:[TMConstants redColor]];
        if (!isAPlaying) {
            if (![_strobe isRunning]){
                [_strobe turnOn];
                [_strobe startStrobe];
            }
        }
    }
    else if(!isEPlaying){
        [_eButton setBackgroundColor:[TMConstants greenColor]];
        if (!isAPlaying) {
            if ([_strobe isRunning]){
                [_strobe stopStrobe];
                [_strobe turnOff];
            }
        }
    }
}


// a octave buttons
-(void)a1ButtonPressed:(id)sender{
    aFrequency = A_FREQUENCY;
    
    [_a1Button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_a2Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_a3Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_a4Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_a5Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    
    [self setStrobeFrequency];

    
}

-(void)a2ButtonPressed:(id)sender{
    aFrequency = A_FREQUENCY * 2;
    
    [_a1Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_a2Button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_a3Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_a4Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_a5Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    
    [self setStrobeFrequency];

}

-(void)a3ButtonPressed:(id)sender{
    aFrequency = A_FREQUENCY * 3;
    
    [_a1Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_a2Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_a3Button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_a4Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_a5Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    
    [self setStrobeFrequency];

}

-(void)a4ButtonPressed:(id)sender{
    aFrequency = A_FREQUENCY * 4;
    
    [_a1Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_a2Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_a3Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_a4Button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_a5Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    
    [self setStrobeFrequency];

}

-(void)a5ButtonPressed:(id)sender{
    aFrequency = A_FREQUENCY / 2;
    
    [_a1Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_a2Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_a3Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_a4Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_a5Button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [self setStrobeFrequency];

}

// e octave buttons
-(void)e1ButtonPressed:(id)sender{
    eFrequency = E_FREQUENCY;
    
    [_e1Button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_e2Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_e3Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_e4Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_e5Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    
    [self setStrobeFrequency];

}

-(void)e2ButtonPressed:(id)sender{
    eFrequency = E_FREQUENCY * 2;
    
    [_e1Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_e2Button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_e3Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_e4Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_e5Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    
    [self setStrobeFrequency];

}

-(void)e3ButtonPressed:(id)sender{
    eFrequency = E_FREQUENCY * 3;
    
    [_e1Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_e2Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_e3Button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_e4Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_e5Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
 
    [self setStrobeFrequency];

}

-(void)e4ButtonPressed:(id)sender{
    eFrequency = E_FREQUENCY * 4;
    
    [_e1Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_e2Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_e3Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_e4Button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_e5Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    
    [self setStrobeFrequency];

}

-(void)e5ButtonPressed:(id)sender{
    eFrequency = E_FREQUENCY / 2;
    
    [_e1Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_e2Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_e3Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_e4Button setTitleColor:[TMConstants greenColor] forState:UIControlStateNormal];
    [_e5Button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [self setStrobeFrequency];

}

//sliders
-(void)aVolumeSliderChanged:(id)sender{
    UISlider* slider = (UISlider*) sender;
    aVolume = slider.value;
}

-(void)eVolumeSliderChanged:(id)sender{
    UISlider* slider = (UISlider*) sender;
    eVolume = slider.value;
}

//a synth type buttons
-(void)aSineButtonPressed:(id)sender{
    [aOscillator setType:sineWave];
    
    [_aSineButton setBackgroundColor:[UIColor redColor]];
    [_aSquareButton setBackgroundColor:[TMConstants greenColor]];
    [_aTriangleButton setBackgroundColor:[TMConstants greenColor]];
    [_aSawButton setBackgroundColor:[TMConstants greenColor]];

    
}

-(void)aSquareButtonPressed:(id)sender{
    [aOscillator setType:squareWave];
    
    [_aSineButton setBackgroundColor:[TMConstants greenColor]];
    [_aSquareButton setBackgroundColor:[UIColor redColor]];
    [_aTriangleButton setBackgroundColor:[TMConstants greenColor]];
    [_aSawButton setBackgroundColor:[TMConstants greenColor]];
    
}

-(void)aTriangleButtonPressed:(id)sender{
    [aOscillator setType:triangleWave];
    
    [_aSineButton setBackgroundColor:[TMConstants greenColor]];
    [_aSquareButton setBackgroundColor:[TMConstants greenColor]];
    [_aTriangleButton setBackgroundColor:[UIColor redColor]];
    [_aSawButton setBackgroundColor:[TMConstants greenColor]];
    
}

-(void)aSawButtonPressed:(id)sender{
    [aOscillator setType:sawWave];
    
    [_aSineButton setBackgroundColor:[TMConstants greenColor]];
    [_aSquareButton setBackgroundColor:[TMConstants greenColor]];
    [_aTriangleButton setBackgroundColor:[TMConstants greenColor]];
    [_aSawButton setBackgroundColor:[UIColor redColor]];
    
}

/*
-(void)aInverseSawButtonPressed:(id)sender{
    [aOscillator setType:inverseSawWave];
}
*/

//e synth type buttons
-(void)eSineButtonPressed:(id)sender{
    [eOscillator setType:sineWave];
    
    [_eSineButton setBackgroundColor:[UIColor redColor]];
    [_eSquareButton setBackgroundColor:[TMConstants greenColor]];
    [_eTriangleButton setBackgroundColor:[TMConstants greenColor]];
    [_eSawButton setBackgroundColor:[TMConstants greenColor]];
    
}

-(void)eSquareButtonPressed:(id)sender{
    [eOscillator setType:squareWave];
    
    [_eSineButton setBackgroundColor:[TMConstants greenColor]];
    [_eSquareButton setBackgroundColor:[UIColor redColor]];
    [_eTriangleButton setBackgroundColor:[TMConstants greenColor]];
    [_eSawButton setBackgroundColor:[TMConstants greenColor]];
    
}

-(void)eTriangleButtonPressed:(id)sender{
    [eOscillator setType:triangleWave];
    
    [_eSineButton setBackgroundColor:[TMConstants greenColor]];
    [_eSquareButton setBackgroundColor:[TMConstants greenColor]];
    [_eTriangleButton setBackgroundColor:[UIColor redColor]];
    [_eSawButton setBackgroundColor:[TMConstants greenColor]];
    
}

-(void)eSawButtonPressed:(id)sender{
    [eOscillator setType:sawWave];
    
    [_eSineButton setBackgroundColor:[TMConstants greenColor]];
    [_eSquareButton setBackgroundColor:[TMConstants greenColor]];
    [_eTriangleButton setBackgroundColor:[TMConstants greenColor]];
    [_eSawButton setBackgroundColor:[UIColor redColor]];
    
}

/*
-(void)eInverseSawButtonPressed:(id)sender{
    [eOscillator setType:inverseSawWave];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - LARSTorch
-(void)setupTorch{
    _torch = [[LARSTorch alloc] initWithTorchState:LARSTorchStateOff];
    _strobe = [[LARSStrobe alloc] initWithLARSTorch:_torch];
    [_strobe setStrobePeriodWithPeriod:0.1];
    //[_strobe setStrobePeriodWithFrequency:4.0];
}

-(void) setStrobeFrequency{
    /*
    CGFloat new_frequency = (aFrequency + eFrequency)/2;
    [_strobe setStrobePeriodWithFrequency:new_frequency/10];
    NSLog(@"setting strobe frequency: %f", new_frequency/100);
     */
}

#pragma mark - EZAudio

-(void)setupAudioPlot{
    /*
     Customizing the audio plot's look
     */
    // Background color
    self.audioPlot.backgroundColor = [UIColor colorWithRed: 0.569 green: 0.82 blue: 0.478 alpha: 1];
    // Waveform color
    self.audioPlot.color           = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    // Plot type
    self.audioPlot.plotType        = EZPlotTypeBuffer;
}

/*
 Give the visualization of the current buffer (this is almost exactly the openFrameworks audio input eample)
 */
-(void)drawBufferPlot {
    // Change the plot type to the buffer plot
    self.audioPlot.plotType = EZPlotTypeBuffer;
    // Don't mirror over the x-axis
    self.audioPlot.shouldMirror = NO;
    // Don't fill
    self.audioPlot.shouldFill = NO;
}


#pragma mark - Helper functions

-(float)map:(float)value inputMin:(float)inputMin inputMax:(float)inputMax outputMin:(float)outputMin outputMax:(float)outputMax{
    //implementation borrowed from openframeworks. thx for being open source! ;)
    if (fabs(inputMin - inputMax) < FLT_EPSILON){
        return outputMin;
    } else {
        float outVal = ((value - inputMin) / (inputMax - inputMin) * (outputMax - outputMin) + outputMin);
        return outVal;
    }
}

@end
