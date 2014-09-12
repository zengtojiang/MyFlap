//
//  SKMainScene.h
//  SpriteKit
//
//  Created by Ray on 14-1-20.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ZLHistoryManager.h"
/**
 
 具有物理特性的物品的锚地必须在中心
 方法1：把两个body连接在一起，bodyA的密度小于1，bodyB的密度大于1，并且bodyA不能受重力影响，让bodyB带着bodyA运动，连接的锚点在bodyB的中心
 方法2：把两个body连接在一起，给bodyB施加作用力，带动bodyA运动，连接的锚点在bodyB上
 */
@interface SKMainScene : SKScene<SKPhysicsContactDelegate>{
    
    BOOL       _bGameOver;
    BOOL       _bPlayVoice;
    
    int         _velocityTimer;
    int         _birdVelocity;
    ZL_GAME_DIFFICULTY _gameDifficulty;
    ZL_GAME_MODE       _gameMode;
    
    
    int         _topWallHeight;
    int         _bottomWallCount;
    int         _wallGapHeight;
    int         _wallGenerateTimer;
    int         _wallGeneratorDuration;//墙壁生成时间间隔
    float         _wallMoveSpeed;//墙移动速度
    int         _coinGeneraterTimer;
    int         _coinGeneraterDuration;//金币生成时间间隔
    
    //过关记录
    int         _curWallIndex;//当前关卡
    int         _curGold;//当前关卡
    int         _historyGold;//历史关卡

    
    SKSpriteNode    *_playerBird;
    SKLabelNode     *_historyPointLabel;
    SKLabelNode     *_pointLabel;
    
    SKSpriteNode    *_backLayer1;
    int             _adjustmentBackgroundPosition;
    int             _adjustmentBackLayer1Position;
    int             _adjustmentBackLayer2Position;
    SKSpriteNode    *_backLayer2;
    SKSpriteNode    *_backLayer3;
    SKSpriteNode    *_backLayer4;
    SKSpriteNode     *_groundNode1;
    SKSpriteNode     *_groundNode2;
    
    //音效加载
    SKAction        *_playFlapAudio;//拍翅膀
    SKAction        *_playMissionAudio;//过关
    SKAction        *_playDieAudio;//游戏结束
    SKAction        *_playCoinAudio;//捡到金币
    SKAction        *_playNewRecordAudio;//刷新记录
}

@property(nonatomic,retain)SKTexture *mWallTexture;

@end
