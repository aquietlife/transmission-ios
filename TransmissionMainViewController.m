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
    
    //store theta back in the view controller
    
    tmvc->aTheta = aTheta;
    tmvc->eTheta = eTheta;
    
    return noErr;
    
}

void ToneInturruptionListener(void *inClientData, UInt32 inInturruptionState){
    TransmissionMainViewController *tmvc = (__bridge TransmissionMainViewController*)inClientData;
    
    [tmvc stop];
}

@interface TransmissionMainViewController ()

@end

@implementation TransmissionMainViewController

- (void)sliderChanged:(UISlider *)slider{
    aFrequency = slider.value;
    frequencyLabel.text = [NSString stringWithFormat:@"4.1f Hz", aFrequency];
}

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
    [self.view setBackgroundColor:[UIColor redColor]];
    
    
    //add ui elements to view
    frequencySlider = [[UISlider alloc] initWithFrame:CGRectMake(0,
                                                                 20,
                                                                 self.view.frame.size.width,
                                                                 100)];
    [frequencySlider setMinimumValue:40.0];
    [frequencySlider setMaximumValue:4000.0];
    [frequencySlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:frequencySlider];
    
    _secondSlider = [[UISlider alloc] initWithFrame:CGRectMake(0,
                                                                 300,
                                                                 self.view.frame.size.width,
                                                                 100)];
    [_secondSlider setMinimumValue:40.0];
    [_secondSlider setMaximumValue:4000.0];
    [_secondSlider addTarget:self action:@selector(secondSliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_secondSlider];
    
    playButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    [playButton addTarget:self action:@selector(togglePlay:) forControlEvents:UIControlEventTouchUpInside];
    [playButton setTitle:@"START" forState:0];
    [self.view addSubview:playButton];
    
    sampleRate = 44100;
    
    OSStatus result = AudioSessionInitialize(NULL, NULL, ToneInturruptionListener, (__bridge void *)(self));
    if (result == kAudioSessionNoError) {
        UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                                sizeof(sessionCategory),
                                &sessionCategory);
    }
    AudioSessionSetActive(true);
    
    aFrequency = 440.0;
    eFrequency = 330.0;
    
    
    [self togglePlay:playButton];
    
    
}

-(void)secondSliderChanged:(id)sender{
    UISlider* slider = (UISlider*) sender;
    NSLog(@"slider is changing: %f", slider.value);
    eFrequency = slider.value;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
