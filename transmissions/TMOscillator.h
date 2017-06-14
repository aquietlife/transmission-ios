//
//  TMOscillator.h
//  transmission-ios
//
//  Created by Johann Diedrick on 9/1/14.
//  Copyright (c) 2014 Johann Diedrick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMOscillator : NSObject
{
    @public
    enum{
        sineWave, squareWave, triangleWave, sawWave, inverseSawWave
    } waveType;
    
    int type;
    int sampleRate;
    float frequency;
    float volume;
    float phase;
    float phaseAdder;
    
}

-(void)setup:(int)sampRate;
-(void)setFrequency: (float) freq;
-(void)setVolume: (float) vol;
-(void)setType:(int)oscType;
-(double)getSample:(double)newPhase;

@end
