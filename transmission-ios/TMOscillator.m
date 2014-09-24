//
//  TMOscillator.m
//  transmission-ios
//
//  Created by Johann Diedrick on 9/1/14.
//  Copyright (c) 2014 Johann Diedrick. All rights reserved.
//

#import "TMOscillator.h"

@implementation TMOscillator

-(void) setup:(int)newSampleRate{
    sampleRate = newSampleRate;
    type = sineWave;
}

-(void) setVolume:(float)vol{
    volume = vol;
}

-(void)setFrequency:(float)freq{
    frequency = freq;
    //phaseAdder = (float)(frequency * 2.0 * M_PI) / (float)sampleRate; // changing M_2_PI to 2.0 * M_PI gives different result..
    phaseAdder = 2.0 * M_PI * frequency / sampleRate;
}

-(void) setType:(int)oscType{
    type = oscType;
}

-(double)getSample:(double)newPhase{
    /*
    phase = newPhase;
    phase += phaseAdder;
    
    while (phase>M_2_PI) {
        phase-=M_2_PI;
    }
    */
    if (type == sineWave){
     
        return sin(newPhase) * volume;
    
    } else if (type == squareWave){
     
        return (sin(newPhase) > 0 ? 1: -1) * volume;
    
    } else if (type == triangleWave){
        
        float pct = newPhase / M_2_PI;
        return (pct < 0.5 ? [self map:pct inputMin:0.0 inputMax:0.5 outputMin:-1 outputMax:1] : [self map:pct inputMin:0.5 inputMax:1.0 outputMin:1.0 outputMax:-1.0]) * volume;
        
    } else if (type==sawWave){
        
        float pct = newPhase / M_2_PI;
        return [self map:pct inputMin:0.0 inputMax:1.0 outputMin:-1.0 outputMax:1.0] * volume;
        
    } else if(type == inverseSawWave){
        
        float pct = newPhase / M_2_PI;
        return [self map:pct inputMin:0.0 inputMax:1.0 outputMin:1.0 outputMax:-1.0] * volume;
        
    }

    else{
        return 0.0;
    }
      
    
}

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
