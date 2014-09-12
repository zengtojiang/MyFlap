//
//  ZLHistoryManager.h
//  ScooterBoy
//
//  Created by libs on 14-3-16.
//  Copyright (c) 2014年 icow. All rights reserved.
//
/**
 历史记录保持器
 */
#import <Foundation/Foundation.h>

typedef NS_ENUM(int, ZL_GAME_DIFFICULTY) {
    ZL_DIFFICULTY_INIT=0,//初始化
    ZL_DIFFICULTY_EASY=1,//简单
    ZL_DIFFICULTY_NORMAL=2,//普通
    ZL_DIFFICULTY_DIFFICULT=3,//困难
};

typedef NS_ENUM(int, ZL_GAME_MODE) {
    ZL_MODE_INIT=0,//初始化
    ZL_MODE_STANDARD=1,//标准模式
    ZL_MODE_SURVIVE=2,//逃生模式
    ZL_MODE_VIVELOCITY=3,//变速模式
};

//英雄角色
typedef NS_ENUM(int, ZL_CHARACTER_TYPE) {
    ZL_CHARACTER_DEFAULT=0,//默认角色
    ZL_CHARACTER_0=1,
    ZL_CHARACTER_1=2,
    ZL_CHARACTER_2=3,
    ZL_CHARACTER_3=4,
    ZL_CHARACTER_4=5,
};

@interface ZLHistoryManager : NSObject

//获取当前游戏难度
+(int)getDifficulty;

//设置游戏难度
+(void)setDifficulty:(ZL_GAME_DIFFICULTY)difficulty;

//获取当前游戏模式
+(ZL_GAME_MODE)getGameMode;

//设置游戏模式
+(void)setGameMode:(ZL_GAME_MODE)mode;

//获取当前角色
+(ZL_CHARACTER_TYPE)getCharacterType;

//设置角色
+(void)setCharacterType:(ZL_CHARACTER_TYPE)type;

//背景
+(int)getBackgroundMode;

//背景
+(void)setBackgroundMode:(int)mode;

//get最新关卡
+(int)getLastPoints;

//set最新关卡
+(void)setLastPoints:(int)point;

//音效开关是否打开
+(BOOL)voiceOpened;

//设置音效开关
+(void)setVoiceOpened:(BOOL)open;

//背景音乐开关是否打开
+(BOOL)musicOpened;

//设置背景音乐开关
+(void)setMusicOpened:(BOOL)open;

//是否是第一次进入应用
+(BOOL)isFirstLaunch;

//设置为不是第一次进入应用
+(void)setFirstLaunch;
@end
