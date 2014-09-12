//
//  SKMainScene.m
//  SpriteKit
//
//  Created by Ray on 14-1-20.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import "SKMainScene.h"
#import "ZLHistoryManager.h"
#import "SKSharedAtles.h"
#import "SKAppDelegate.h"
#import "ZLCoinNode.h"


#define BIRD_ANCHOR_POINT       0.75f
#define DEFAULT_VELOCITY        (-200)
#define VELOCITY_CHANGE_DELTA   (15)

#define WALL_WIDTH                  70//  60//地板高度

#define BACKGROUND_HEIGHT           60// 51//  60//地板高度

@implementation SKMainScene

- (instancetype)initWithSize:(CGSize)size{
    
    self = [super initWithSize:size];
    if (self) {
        _bGameOver=YES;
        _wallGenerateTimer=-1;
        _coinGeneraterTimer=0;
        _birdVelocity=0;
        _gameDifficulty=ZL_DIFFICULTY_INIT;
        _gameMode=ZL_MODE_STANDARD;
        [self resetGameParams];
        [self initPhysicsWorld];
        [self initBackground];
        [self initScroe];
        [self initPlayerBird];
        [self startPlayerBirdAction];
        [self initStartLabel:YES];
        [self initWallTexture];
        [self initAudio];
       
        //重设游戏参数
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetGameParams) name:ZL_RESET_GAME_NOTIFICATION object:nil];
        
         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(restartGame) name:ZL_RESTART_GAME_NOTIFICATION object:nil];
    }
    return self;
}

//重设游戏参数
-(void)resetGameParams
{
     [self initGameDifficulty];
    _bPlayVoice=[ZLHistoryManager voiceOpened];
}

-(void)restartGame
{
    [self resetGameParams];
    ZL_GAME_MODE newmode=[ZLHistoryManager getGameMode];
    if (newmode!=_gameMode) {
        [self restartGame];
        _gameMode=newmode;
    }
    _bGameOver=YES;
    _birdVelocity=0;
    _wallGenerateTimer=-1;
    _coinGeneraterTimer=0;
    for (SKNode *child in [self children]) {
        if (child.zPosition!=0) {
            [child removeFromParent];
        }
    }
    //[self removeAllChildren];
    [self removeAllActions];
    // [self initBackground];
    [self initScroe];
    [self initPlayerBird];
    [self startPlayerBirdAction];
    [self initStartLabel:YES];
}

-(void)onTapStartGame
{
    _birdVelocity=0;
    _wallGenerateTimer=-1;
    _coinGeneraterTimer=0;
    for (SKNode *child in [self children]) {
        if (child.zPosition!=0) {
            [child removeFromParent];
        }
    }
    //[self removeAllChildren];
    [self removeAllActions];
   // [self initBackground];
    [self initScroe];
    [self initPlayerBird];
    _playerBird.physicsBody.velocity=CGVectorMake(0, _birdVelocity);
    self.physicsWorld.speed=1.0;
    _bGameOver=NO;
    //self.physicsWorld.gravity=CGVectorMake(0, DEFAULT_GRAVITY+_forceGravity);
}

- (void)initPhysicsWorld{
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0,0);
}

//初始化游戏难度
-(void)initGameDifficulty
{
    int difficulty=[ZLHistoryManager getDifficulty];
    if (difficulty!=_gameDifficulty&&_gameDifficulty!=ZL_DIFFICULTY_INIT) {
        //难度变化了
        _wallGenerateTimer=0;
        _coinGeneraterTimer=0;
    }
    _gameDifficulty=difficulty;
    if (difficulty==ZL_DIFFICULTY_NORMAL) {
        _wallGeneratorDuration=60;
        _wallGapHeight=WALL_WIDTH*2;
        _wallMoveSpeed=3.5f;
        _coinGeneraterDuration=150;
    }else  if (difficulty==ZL_DIFFICULTY_EASY) {
        _wallGeneratorDuration=70;
        _wallGapHeight=WALL_WIDTH*2;
        _wallMoveSpeed=4;
        _coinGeneraterDuration=90;
    }else  if (difficulty==ZL_DIFFICULTY_DIFFICULT) {
        _wallGeneratorDuration=47;
        _wallGapHeight=WALL_WIDTH*1.5f;
        _wallMoveSpeed=3.5f;
        _coinGeneraterDuration=60;
    }
    /*
    if (difficulty==ZL_DIFFICULTY_NORMAL) {
        _wallGeneratorDuration=70;
        _wallGapHeight=WALL_WIDTH*2;
        _wallMoveSpeed=4;
    }else  if (difficulty==ZL_DIFFICULTY_EASY) {
        _wallGeneratorDuration=90;
        _wallGapHeight=WALL_WIDTH*2.5f;
        _wallMoveSpeed=5;
    }else  if (difficulty==ZL_DIFFICULTY_DIFFICULT) {
        _wallGeneratorDuration=47;
        _wallGapHeight=WALL_WIDTH*1.5f;
        _wallMoveSpeed=4;
    }
     */
}

-(void)initAudio
{
    //waitForCompletion 音效动作是否和音效长度一样
    _playFlapAudio=[SKAction playSoundFileNamed:@"wingflap.mp3" waitForCompletion:NO];
    _playMissionAudio=[SKAction playSoundFileNamed:@"mission.mp3" waitForCompletion:NO];
    _playDieAudio=[SKAction playSoundFileNamed:@"die.mp3" waitForCompletion:YES];
    _playCoinAudio=[SKAction playSoundFileNamed:@"coinfly.mp3" waitForCompletion:YES];
    //_playNewRecordAudio=[SKAction playSoundFileNamed:@"select.mp3" waitForCompletion:NO];
}

- (void)initBackground{
    if ([ZLHistoryManager getBackgroundMode]==ZLBackgroundModeDefault)
    {
        [self initBackground0];
        return;
    }
    
    SKTexture *layer1Texture=[SKSharedAtles textureWithType:ZLTextureTypeBackLayer1];
    _adjustmentBackLayer1Position=layer1Texture.size.width;
    
    _backLayer1 = [SKSpriteNode spriteNodeWithTexture:layer1Texture];
    _backLayer1.position = CGPointMake(_adjustmentBackLayer1Position-layer1Texture.size.width, 0);
    _backLayer1.anchorPoint = CGPointMake(0, 0);
    _backLayer1.zPosition = 0;
    
    _backLayer2 = [SKSpriteNode spriteNodeWithTexture:layer1Texture];
    _backLayer2.anchorPoint = CGPointMake(0, 0);
    _backLayer2.position = CGPointMake(_adjustmentBackLayer1Position-1, 0);
    _backLayer2.zPosition = 0;
    
    [self addChild:_backLayer1];
    [self addChild:_backLayer2];
    
    
   SKSpriteNode *bottomNode=[SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(self.size.width, BACKGROUND_HEIGHT)];
    bottomNode.position=CGPointMake(0,1.0f*BACKGROUND_HEIGHT/2);
    bottomNode.anchorPoint=CGPointMake(0, 0.5);
    bottomNode.zPosition=0;
    bottomNode.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:bottomNode.size];
    //groundSprite.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:groundSprite.size];
    bottomNode.physicsBody.categoryBitMask=SKRoleCategoryBackground;
    bottomNode.physicsBody.contactTestBitMask=SKRoleCategoryBird;
    bottomNode.physicsBody.dynamic=NO;
    bottomNode.physicsBody.restitution=0;
    [self addChild:bottomNode];
}


- (void)initBackground0{
    
    _adjustmentBackgroundPosition = self.size.width;
    
    SKTexture *layer1Texture=[SKSharedAtles textureWithType:ZLTextureTypeBackLayer1];
    _adjustmentBackLayer1Position=layer1Texture.size.width;
    SKTexture *layer2Texture=[SKSharedAtles textureWithType:ZLTextureTypeBackLayer2];
    _adjustmentBackLayer2Position=layer2Texture.size.width;
    SKTexture *groundTexture=[SKSharedAtles textureWithType:ZLTextureTypeBackground];
    
    _backLayer3 = [SKSpriteNode spriteNodeWithTexture:layer2Texture];
    _backLayer3.position = CGPointMake(_adjustmentBackLayer2Position-layer2Texture.size.width, groundTexture.size.height+20);
    _backLayer3.anchorPoint = CGPointMake(0, 0);
    _backLayer3.zPosition = 0;
    
    _backLayer4 = [SKSpriteNode spriteNodeWithTexture:layer2Texture];
    _backLayer4.anchorPoint = CGPointMake(0, 0);
    _backLayer4.position = CGPointMake(_adjustmentBackLayer2Position-1, groundTexture.size.height+20);
    _backLayer4.zPosition = 0;
    
    [self addChild:_backLayer3];
    [self addChild:_backLayer4];
    
    
    _backLayer1 = [SKSpriteNode spriteNodeWithTexture:layer1Texture];
    _backLayer1.position = CGPointMake(_adjustmentBackLayer1Position-layer1Texture.size.width, groundTexture.size.height);
    _backLayer1.anchorPoint = CGPointMake(0, 0);
    _backLayer1.zPosition = 0;
    
    _backLayer2 = [SKSpriteNode spriteNodeWithTexture:layer1Texture];
    _backLayer2.anchorPoint = CGPointMake(0, 0);
    _backLayer2.position = CGPointMake(_adjustmentBackLayer1Position-1, groundTexture.size.height);
    _backLayer2.zPosition = 0;
    
    [self addChild:_backLayer1];
    [self addChild:_backLayer2];
    
    
   // [self runAction:[SKAction repeatActionForever:[SKAction playSoundFileNamed:@"game_music.mp3" waitForCompletion:YES]]];
   
    _groundNode1=[SKSpriteNode spriteNodeWithTexture:groundTexture];
    _groundNode1.position=CGPointMake(_adjustmentBackgroundPosition-groundTexture.size.width, groundTexture.size.height/2);
    _groundNode1.anchorPoint=CGPointMake(0, 0.5);
    _groundNode1.zPosition=0;
    [self addChild:_groundNode1];
    
    _groundNode2=[SKSpriteNode spriteNodeWithTexture:groundTexture];
    _groundNode2.position=CGPointMake(_adjustmentBackgroundPosition-1, groundTexture.size.height/2);
    _groundNode2.anchorPoint=CGPointMake(0, 0.5);
    _groundNode2.zPosition=0;
    [self addChild:_groundNode2];
    
    SKSpriteNode *bottomNode=[SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(self.size.width, BACKGROUND_HEIGHT)];
    bottomNode.position=CGPointMake(0,1.0f*BACKGROUND_HEIGHT/2);
    bottomNode.anchorPoint=CGPointMake(0, 0.5);
    bottomNode.zPosition=0;
    bottomNode.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:bottomNode.size];
    //groundSprite.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:groundSprite.size];
    bottomNode.physicsBody.categoryBitMask=SKRoleCategoryBackground;
    bottomNode.physicsBody.contactTestBitMask=SKRoleCategoryBird;
    bottomNode.physicsBody.dynamic=NO;
    bottomNode.physicsBody.restitution=0;
    [self addChild:bottomNode];
}

-(void)initWallTexture
{
    self.mWallTexture=[SKSharedAtles textureWithType:ZLTextureTypeWall];
    //ZLTRACE(@"initWallTexture Size:%@",NSStringFromCGSize(self.mWallTexture.size));
}

- (void)scrollBackground{
    
     if ([ZLHistoryManager getBackgroundMode]==ZLBackgroundModeDefault)
     {
         _adjustmentBackLayer1Position -=3;
         _adjustmentBackLayer2Position -=1;
         
         if (_adjustmentBackLayer1Position<=0) {
             _adjustmentBackLayer1Position=_backLayer1.size.width;
         }
         if (_adjustmentBackLayer2Position<=0) {
             _adjustmentBackLayer2Position=_backLayer3.size.width;
         }
         float layer1YPosition=_backLayer1.position.y;
         float layer2YPosition=_backLayer3.position.y;
         
         [_backLayer1 setPosition:CGPointMake(_adjustmentBackLayer1Position - _backLayer1.size.width, layer1YPosition)];
         [_backLayer2 setPosition:CGPointMake(_adjustmentBackLayer1Position-1, layer1YPosition)];
         [_backLayer3 setPosition:CGPointMake(_adjustmentBackLayer2Position - _backLayer3.size.width, layer2YPosition)];
         [_backLayer4 setPosition:CGPointMake(_adjustmentBackLayer2Position-1, layer2YPosition)];
         
         _adjustmentBackgroundPosition -=5;
         if (_adjustmentBackgroundPosition <= 0)
         {
             _adjustmentBackgroundPosition = self.size.width;
         }
         float groundYPosition=_groundNode1.position.y;
         [_groundNode1 setPosition:CGPointMake(_adjustmentBackgroundPosition - self.size.width, groundYPosition)];
         [_groundNode2 setPosition:CGPointMake(_adjustmentBackgroundPosition-1, groundYPosition)];
     }else {
         _adjustmentBackLayer1Position -=4;
         if (_adjustmentBackLayer1Position<=0) {
             _adjustmentBackLayer1Position=_backLayer1.size.width;
         }
         float layer1YPosition=_backLayer1.position.y;
         [_backLayer1 setPosition:CGPointMake(_adjustmentBackLayer1Position - _backLayer1.size.width, layer1YPosition)];
         [_backLayer2 setPosition:CGPointMake(_adjustmentBackLayer1Position-1, layer1YPosition)];
     }
}

- (void)initStartLabel:(BOOL)firsttime
{
    SKLabelNode *_startLabel = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
    _startLabel.text = firsttime?@"Tap to Start":@"Tap to Restart";
    _startLabel.name=@"startLabel";
    _startLabel.zPosition = 4;
    _startLabel.fontColor =  HEXCOLOR(0xe6b003); //HEXCOLOR(0xe6b003);//HEXCOLOR(0x552d19);//[SKColor brownColor];
    _startLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    _startLabel.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    [self addChild:_startLabel];
    [_startLabel runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:1],[SKAction waitForDuration:0.1],[SKAction fadeInWithDuration:1.5],[SKAction waitForDuration:0.1]]]]];
}
/*
- (void)initStartLabel{
    SKLabelNode *_startLabel = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
    _startLabel.text = @"Tap to Start";
    _startLabel.name=@"startLabel";
    _startLabel.zPosition = 3;
    _startLabel.fontColor = HEXCOLOR(0xe6b003);//HEXCOLOR(0x552d19);//[SKColor brownColor];
    _startLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    _startLabel.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    [self addChild:_startLabel];
    [_startLabel runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:2],[SKAction waitForDuration:0.1],[SKAction fadeInWithDuration:3],[SKAction waitForDuration:0.1]]]]];
}
*/
- (void)initScroe{
    _curWallIndex=0;
    _curGold=0;
    _historyGold=[ZLHistoryManager getLastPoints];
    _pointLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _pointLabel.text = [NSString stringWithFormat:@"Gold:%d",_curGold];
    _pointLabel.zPosition = 4;
    _pointLabel.fontSize=16;
    _pointLabel.fontColor = HEXCOLOR(0xe6b003);//[SKColor whiteColor];
    _pointLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    _pointLabel.position = CGPointMake(60 , self.size.height - 50);
    [self addChild:_pointLabel];
    
    _historyPointLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _historyPointLabel.text = [NSString stringWithFormat:@"Record:%d",_historyGold];
    _historyPointLabel.zPosition = 4;
    _historyPointLabel.fontColor = HEXCOLOR(0xe6b003);//[SKColor whiteColor];
    _historyPointLabel.fontSize=16;
    _historyPointLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    _historyPointLabel.position = CGPointMake(CGRectGetMidX(self.frame)+60 , self.size.height - 50);
    [self addChild:_historyPointLabel];
}

- (void)initPlayerBird{
    
    _playerBird = [SKSpriteNode spriteNodeWithTexture:[SKSharedAtles textureWithType:ZLTextureTypeBird]];
    _playerBird.position =  CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)+50);//CGPointMake(160, 300);
    _playerBird.zPosition = 2;
   // _playerBird.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_playerBird.size];
    _playerBird.physicsBody=[SKPhysicsBody bodyWithCircleOfRadius:_playerBird.size.width/3];
    _playerBird.physicsBody.categoryBitMask = SKRoleCategoryBird;
    _playerBird.physicsBody.collisionBitMask = SKRoleCategoryWall;
    _playerBird.physicsBody.contactTestBitMask = SKRoleCategoryWall|SKRoleCategoryBackground|SKRoleCategoryWallPoints|SKRoleCategoryCoin;
    [self addChild:_playerBird];
    if ([ZLHistoryManager getCharacterType]!=ZL_CHARACTER_DEFAULT) {
        [_playerBird runAction:[SKSharedAtles playerAction]];
    }
}

-(void)startPlayerBirdAction
{
    [_playerBird runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction moveByX:0 y:15 duration:0.5],[SKAction waitForDuration:0.1],[SKAction moveByX:0 y:-30 duration:1],[SKAction waitForDuration:0.1],[SKAction moveByX:0 y:15 duration:0.5]]]]];
}


-(void)createIncomingWalls
{
    SKSpriteNode * (^createWall)(BOOL) = ^(BOOL bottomWall){
        
        if (bottomWall) {
            _bottomWallCount= (arc4random() % 3)+1;
        }
//        if (topWall) {
//            
//            _topWallHeight=(arc4random() % (lround(CGRectGetHeight(self.frame)-TOP_BOTTOM_WALL_GAP-100-BACKGROUND_HEIGHT))) + 100;
//        }
        float wallHeight=bottomWall?_bottomWallCount*WALL_WIDTH:(CGRectGetHeight(self.frame)-_bottomWallCount*WALL_WIDTH-_wallGapHeight-BACKGROUND_HEIGHT);
       /// CGSize wallSize=CGSizeMake(WALL_WIDTH, topWall?_topWallHeight:(CGRectGetHeight(self.frame)-_topWallHeight-TOP_BOTTOM_WALL_GAP-BACKGROUND_HEIGHT));
        SKTexture *wallTexture=[SKTexture textureWithRect:CGRectMake(0, 0, 1, wallHeight/self.mWallTexture.size.height) inTexture:self.mWallTexture];
        //SKTexture *wallTexture=[SKTexture textureWithRect:CGRectMake(0, 0, self.mWallTexture.size.width, wallHeight) inTexture:self.mWallTexture];
        SKSpriteNode *wallSprite=[SKSpriteNode spriteNodeWithTexture:wallTexture];
        wallSprite.anchorPoint=CGPointMake(0.5, 0.5);
        wallSprite.position=CGPointMake(CGRectGetMaxX(self.frame)+self.mWallTexture.size.width/2, bottomWall?CGRectGetMinY(self.frame)+wallSprite.size.height/2+BACKGROUND_HEIGHT:CGRectGetMaxY(self.frame)-wallSprite.size.height/2);
        wallSprite.zPosition=1;
        wallSprite.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:wallSprite.size];
        wallSprite.physicsBody.categoryBitMask=SKRoleCategoryWall;
        wallSprite.physicsBody.collisionBitMask = SKRoleCategoryBird;
        wallSprite.physicsBody.contactTestBitMask=SKRoleCategoryBird;
        wallSprite.physicsBody.dynamic=NO;
        wallSprite.physicsBody.restitution=0;
        
        return wallSprite;
    };
    if (_wallGenerateTimer > _wallGeneratorDuration||_wallGenerateTimer==-1)
    {
        SKSpriteNode *bottomWall = createWall(YES);
        [self addChild:bottomWall];
        [bottomWall runAction:[SKAction sequence:@[[SKAction moveToX:-WALL_WIDTH/2 duration:_wallMoveSpeed],[SKAction removeFromParent]]]];
        
        SKSpriteNode *topWall = createWall(NO);
        [self addChild:topWall];
        [topWall runAction:[SKAction sequence:@[[SKAction moveToX:-WALL_WIDTH/2 duration:_wallMoveSpeed],[SKAction removeFromParent]]]];
        
       
        SKSpriteNode *wallLine = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(2, _wallGapHeight)];
        wallLine.zPosition = 1;
        wallLine.position = CGPointMake(CGRectGetMaxX(self.frame)+WALL_WIDTH,CGRectGetMaxY(bottomWall.frame)+_wallGapHeight/2);
        //wallLine.anchorPoint=CGPointMake(0,1);
        wallLine.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:wallLine.size];
        wallLine.physicsBody.mass=1;
       // wallLine.physicsBody.affectedByGravity=NO;
        wallLine.physicsBody.dynamic=NO;
        wallLine.physicsBody.restitution=0;
        wallLine.physicsBody.categoryBitMask = SKRoleCategoryWallPoints;
        wallLine.physicsBody.collisionBitMask=0;
        wallLine.physicsBody.contactTestBitMask = SKRoleCategoryBird;
        
        [self addChild:wallLine];
        [wallLine runAction:[SKAction sequence:@[[SKAction moveToX:0 duration:_wallMoveSpeed],[SKAction removeFromParent]]]];
        
        _wallGenerateTimer = 0;
    }
    _wallGenerateTimer++;
}
-(ZLCoinNode *)createCoin
{
    ZLCoinNode *coinSprite=[ZLCoinNode createCoinWithType:ZLTextureTypeCoin];
    int _coinYPosition=CGRectGetMinY(self.frame)+BACKGROUND_HEIGHT+10+coinSprite.size.height/2+(arc4random()%lround(CGRectGetHeight(self.frame)-BACKGROUND_HEIGHT-coinSprite.size.height-100));
    //int _wallYPosition=CGRectGetMinY(self.frame)+(position+0.5f)*OBSTACLE_WIDTH+BACKGROUND_HEIGHT;
    
    coinSprite.position=CGPointMake(CGRectGetWidth(self.frame)+WALL_WIDTH/2, _coinYPosition);
    [coinSprite runAction:[SKSharedAtles coinAction]];
    return coinSprite;
}

-(void)createIncomingCoins
{
    _coinGeneraterTimer++;
    if (_coinGeneraterTimer >= _coinGeneraterDuration)
    {
        ZLCoinNode *coinSprite = [self createCoin];
        [self addChild:coinSprite];
        [coinSprite runAction:[SKAction sequence:@[[SKAction moveToX:-WALL_WIDTH/2  duration:_wallMoveSpeed],[SKAction removeFromParent]]]];
        _coinGeneraterTimer = 0;
    }
}


-(void)adjustPlayerBirdAngle
{
    CGVector velocity=_playerBird.physicsBody.velocity;
    if (velocity.dy>0) {
        [_playerBird removeActionForKey:@"turndownaction"];
        if (![_playerBird actionForKey:@"turnupaction"]) {
            [_playerBird runAction:[SKAction rotateToAngle:0 duration:0.1f]];
            //[_playerBird runAction:[SKAction setTexture:[SKSharedAtles textureWithType:ZLTextureTypeBirdUp]]];
            SKAction *rotateAction=[SKAction rotateToAngle:M_PI_4 duration:0.3f];
            rotateAction.timingMode=SKActionTimingEaseOut;
            [_playerBird runAction:rotateAction withKey:@"turnupaction"];
        }
    }else{
        [_playerBird removeActionForKey:@"turnupaction"];
        if (![_playerBird actionForKey:@"turndownaction"]) {
            //[_playerBird runAction:[SKAction setTexture:[SKSharedAtles textureWithType:ZLTextureTypeBirdDown]]];
            SKAction *rotateAction=[SKAction rotateToAngle:M_PI_4*(-1) duration:0.5f];
            rotateAction.timingMode=SKActionTimingEaseIn;
            [_playerBird runAction:rotateAction withKey:@"turndownaction"];
        }
    }
}

-(void)applyForceToPlayer
{
    //_velocityTimer++;
   // if (_velocityTimer>5) {
        _velocityTimer=0;
    
        //if (_birdVelocity>DEFAULT_VELOCITY&&_birdVelocity<=0)
        if (_birdVelocity<=0&&_birdVelocity>DEFAULT_VELOCITY)
        {
            _birdVelocity -=VELOCITY_CHANGE_DELTA;
        }else if(_birdVelocity>0){
            _birdVelocity -=VELOCITY_CHANGE_DELTA;
        }
        ZLTRACE(@"_birdVelocity:%d",_birdVelocity);
        _playerBird.physicsBody.velocity=CGVectorMake(0, _birdVelocity);
    //}
    
    //self.physicsWorld.gravity=CGVectorMake(0, DEFAULT_GRAVITY+_forceGravity);
    //[_massNode.physicsBody applyImpulse:CGVectorMake(0, -2+_tapForce) atPoint:CGPointMake(_playerBird.size.width*BIRD_ANCHOR_POINT, _playerBird.size.height/2)];
    
    //[_playerBird.physicsBody applyForce:CGVectorMake(0, -20)];
    //[_massNode.physicsBody applyImpulse:CGVectorMake(0, -2+_tapForce)];
    //[_playerBird.physicsBody applyImpulse:CGVectorMake(0, -2+_tapForce) atPoint:CGPointMake(BIRD_ANCHOR_POINT, 0.5)];
}

-(void)onCollisionWithCoin:(SKSpriteNode *)sprite
{
    [sprite removeAllActions];
    [sprite removeFromParent];
    [self addGoldAnimation:1];
    if (_bPlayVoice) {
        [self runAction:_playCoinAudio];
    }
}

-(void)addGoldAnimation:(int)goldNumber
{
    if (goldNumber>0) {
        [self showAddGoldAnimation:goldNumber];
        _curGold +=goldNumber;
        [_pointLabel runAction:[SKAction runBlock:^{
            _pointLabel.text = [NSString stringWithFormat:@"Gold:%d",_curGold];
        }]];
        if (_curGold>_historyGold) {
            [ZLHistoryManager setLastPoints:_curGold];
            _historyGold=[ZLHistoryManager getLastPoints];
            [_historyPointLabel runAction:[SKAction runBlock:^{
                _historyPointLabel.text = [NSString stringWithFormat:@"Record:%d",_historyGold];
            }]];
            //        [_historyPointLabel runAction:[SKAction sequence:@[_playNewRecordAudio,[SKAction runBlock:^{
            //            _historyPointLabel.text = [NSString stringWithFormat:@"Record:%d",_historyPoints];
            //        }]]]];
        }
    }
}

-(void)onCommitWallPoint:(SKSpriteNode *)sprite
{
    [sprite removeAllActions];
    [sprite removeFromParent];
    _curWallIndex++;
    int addNumber=0;
    if (_gameDifficulty==ZL_DIFFICULTY_DIFFICULT) {
        //addNumber =powf(2, (_curWallIndex-1));
        addNumber=_curWallIndex;
    }else if(_gameDifficulty==ZL_DIFFICULTY_NORMAL){
        //addNumber=_curWallIndex;
        addNumber=1;
    }else {
        if (_curWallIndex%3==0) {
            addNumber=1;
        }
    }
    if (_bPlayVoice) {
        [self runAction:_playMissionAudio];
    }
    [self addGoldAnimation:addNumber];
}

-(void)showAddGoldAnimation:(int)goldNumber
{
    SKLabelNode *goldAnimation = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];//ChalkboardSE-Bold
    goldAnimation.text = [NSString stringWithFormat:@"+ %d",goldNumber];
    goldAnimation.zPosition = 4;
    goldAnimation.fontSize=40;
    goldAnimation.fontColor = HEXCOLOR(0xe6b003);//[SKColor whiteColor];
    goldAnimation.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    goldAnimation.position = CGPointMake(150 , 120);
    [self addChild:goldAnimation];
    
    [goldAnimation runAction:[SKAction sequence:@[[SKAction moveToY:240 duration:1],[SKAction fadeOutWithDuration:0.5],[SKAction removeFromParent]]] completion:^{
        //[goldAnimation removeFromParent];
    }];
}

-(void)onGameOver
{
    if (_bGameOver) {
        return;
    }
    _bGameOver=YES;
    [self removeAllActions];
//    _playerBird.physicsBody.velocity=CGVectorMake(0, 0);
//    _playerBird.physicsBody.angularVelocity=0;
    _playerBird.physicsBody.resting=YES;
    //self.physicsWorld.speed=0;
    for (SKNode *child in [self children]) {
        if (child.zPosition!=0) {
            child.physicsBody.resting=YES;
            [child removeAllActions];
        }
    }
//    for (SKNode *child in [self children]) {
//        child.physicsBody.resting=YES;
//        [child removeAllActions];
//    }
    if (_bPlayVoice) {
        [self runAction:[SKAction sequence:@[_playDieAudio,[SKAction runBlock:^{
            [self initStartLabel:NO];
            
        }]]]];
    }else{
        [self runAction:[SKAction runBlock:^{
            [self initStartLabel:NO];
        }]];
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    ZLTRACE(@"");
    if (self.paused) {
        ZLTRACE(@"game has paused");
        return;
    }
    if (_bGameOver) {
        if ([self childNodeWithName:@"startLabel"]) {
            //出现了点击开始图标才能开始
            [self onTapStartGame];
        }
    }else{
        if (_bPlayVoice) {
            [self runAction:_playFlapAudio];
        }
        _birdVelocity=DEFAULT_VELOCITY*(-1);
        //[_playerBird.physicsBody applyImpulse:CGVectorMake(0,50)];
    }
}
/*
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode:self];
        
        if (location.x >= self.size.width - (_playerPlane.size.width / 2)) {
            
            location.x = self.size.width - (_playerPlane.size.width / 2);
            
        }else if (location.x <= (_playerPlane.size.width / 2)) {
            
            location.x = _playerPlane.size.width / 2;
            
        }
        
        if (location.y >= self.size.height - (_playerPlane.size.height / 2)) {
            
            location.y = self.size.height - (_playerPlane.size.height / 2);
            
        }else if (location.y <= (_playerPlane.size.height / 2)) {
            
            location.y = (_playerPlane.size.height / 2);
            
        }
        
        SKAction *action = [SKAction moveTo:CGPointMake(location.x, location.y) duration:0];
        
        [_playerPlane runAction:action];
    }
}
*/

- (void)update:(NSTimeInterval)currentTime{
    if (!_bGameOver) {
        [self applyForceToPlayer];
        
        if ([ZLHistoryManager getCharacterType]==ZL_CHARACTER_DEFAULT) {
            [self adjustPlayerBirdAngle];
        }
        [self createIncomingWalls];
        [self createIncomingCoins];
    }
    [self scrollBackground];
}

#pragma mark -
- (void)didBeginContact:(SKPhysicsContact *)contact{
    if (contact.bodyA.categoryBitMask & SKRoleCategoryBird || contact.bodyB.categoryBitMask & SKRoleCategoryBird) {
        if (contact.bodyA.categoryBitMask & SKRoleCategoryWall || contact.bodyB.categoryBitMask & SKRoleCategoryWall) {
            [self onGameOver];
        }else if(contact.bodyA.categoryBitMask & SKRoleCategoryBackground || contact.bodyB.categoryBitMask & SKRoleCategoryBackground){
            [self onGameOver];
        }else if(contact.bodyA.categoryBitMask & SKRoleCategoryCoin || contact.bodyB.categoryBitMask & SKRoleCategoryCoin){
            SKSpriteNode *coinNode = (contact.bodyA.categoryBitMask & SKRoleCategoryCoin) ? (SKSpriteNode *)contact.bodyA.node : (SKSpriteNode *)contact.bodyB.node;
            [self onCollisionWithCoin:coinNode];
        }
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact{
    if (contact.bodyA.categoryBitMask & SKRoleCategoryBird || contact.bodyB.categoryBitMask & SKRoleCategoryBird) {
        if(contact.bodyA.categoryBitMask & SKRoleCategoryWallPoints || contact.bodyB.categoryBitMask & SKRoleCategoryWallPoints){
            SKSpriteNode *wallPoint = (contact.bodyA.categoryBitMask & SKRoleCategoryWallPoints) ? (SKSpriteNode *)contact.bodyA.node : (SKSpriteNode *)contact.bodyB.node;
            [self onCommitWallPoint:wallPoint];
        }
    }
}


@end
