//
//  ZLAudioPlayer.m
//  Toothpaste
//
//  Created by libs on 14-3-23.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLAudioPlayer.h"

@implementation ZLAudioPlayer

-(void)setBackgroundAudioFileName:(NSString *)fileName fileType:(NSString *)fileType
{
    NSString *filePath=[[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
    mPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:NULL];
    mPlayer.numberOfLoops=-1;
}

-(void)play
{
    [mPlayer play];
}

-(void)pause
{
    [mPlayer pause];
}

-(void)resume
{
    [mPlayer play];
}

-(void)stop
{
    [mPlayer stop];
}

@end
