//
//  ZLHistoryManager.m
//  ScooterBoy
//
//  Created by libs on 14-3-16.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLHistoryManager.h"

@implementation ZLHistoryManager


//获取当前游戏难度
+(int)getDifficulty;
{
    int difficulty=(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ZL_GAME_DIFFICULTY"];
    if (difficulty<=0) {
        return ZL_DIFFICULTY_NORMAL;
    }
    return difficulty;
}

//设置游戏难度
+(void)setDifficulty:(ZL_GAME_DIFFICULTY)difficulty;
{
    if (difficulty<ZL_DIFFICULTY_EASY||difficulty>ZL_DIFFICULTY_DIFFICULT) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:difficulty forKey:@"ZL_GAME_DIFFICULTY"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//获取当前游戏模式
+(ZL_GAME_MODE)getGameMode
{
    int mode=(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ZL_GAME_MODE"];
    if (mode<=0) {
        return ZL_MODE_STANDARD;
    }
    return mode;
}

//设置游戏模式
+(void)setGameMode:(ZL_GAME_MODE)mode
{
    if (mode<ZL_MODE_STANDARD||mode>ZL_MODE_VIVELOCITY) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:mode forKey:@"ZL_GAME_MODE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//获取当前角色
+(ZL_CHARACTER_TYPE)getCharacterType;
{
    int type=(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ZL_CHARACTERTYPE"];
    ZLTRACE(@"type:%d",type);
    if (type<=0) {
        return ZL_CHARACTER_DEFAULT;
    }
    return type;
}

//设置角色
+(void)setCharacterType:(ZL_CHARACTER_TYPE)type;
{
     ZLTRACE(@"type:%d",type);
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:@"ZL_CHARACTERTYPE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//背景
+(int)getBackgroundMode
{
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ZL_BackgroundMode"];
}

//背景
+(void)setBackgroundMode:(int)mode;
{
    [[NSUserDefaults standardUserDefaults] setInteger:mode forKey:@"ZL_BackgroundMode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//get最新关卡
+(int)getLastPoints
{
     return (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ZL_LAST_POINTS"];
}

//set最新关卡
+(void)setLastPoints:(int)point
{
    [[NSUserDefaults standardUserDefaults] setInteger:point forKey:@"ZL_LAST_POINTS"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

//音效开关是否打开
+(BOOL)voiceOpened
{
    int voiceState=(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ZL_VOICE_STATE"];
    if (voiceState==2) {
        return NO;
    }
    return YES;
}

//设置音效开关
+(void)setVoiceOpened:(BOOL)open;
{
    [[NSUserDefaults standardUserDefaults] setInteger:open?1:2 forKey:@"ZL_VOICE_STATE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//背景音乐开关是否打开
+(BOOL)musicOpened;
{
    int voiceState=(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ZL_MUSIC_STATE"];
    if (voiceState==2) {
        return NO;
    }
    return YES;
}

//设置背景音乐开关
+(void)setMusicOpened:(BOOL)open;
{
    [[NSUserDefaults standardUserDefaults] setInteger:open?1:2 forKey:@"ZL_MUSIC_STATE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//是否是第一次进入应用
+(BOOL)isFirstLaunch
{
    BOOL launched=[[NSUserDefaults standardUserDefaults] boolForKey:@"ZL_LAUNCHED"];
    if (!launched) {
        return YES;
    }
    return NO;
}

//设置为不是第一次进入应用
+(void)setFirstLaunch
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ZL_LAUNCHED"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
