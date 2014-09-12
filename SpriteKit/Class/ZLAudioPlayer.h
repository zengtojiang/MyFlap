//
//  ZLAudioPlayer.h
//  Toothpaste
//
//  Created by libs on 14-3-23.
//  Copyright (c) 2014年 icow. All rights reserved.
//
/**
 音频播放
 */
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface ZLAudioPlayer : NSObject
{
    AVAudioPlayer *mPlayer;
}

-(void)setBackgroundAudioFileName:(NSString *)fileName fileType:(NSString *)fileType;

-(void)play;

-(void)pause;

-(void)resume;

-(void)stop;
@end
