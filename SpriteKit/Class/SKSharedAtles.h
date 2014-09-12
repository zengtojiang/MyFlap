//
//  SKSharedAtles.h
//  SpriteKit
//
//  Created by Ray on 14-1-20.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(int, ZLTextureType) {
    ZLTextureTypeBackground = 1,
    ZLTextureTypeBackLayer1 = 2,
    ZLTextureTypeBackLayer2 = 3,
    ZLTextureTypeBird = 5,
    ZLTextureTypeWall = 6,
    ZLTextureTypeCoin = 7,
};

typedef NS_ENUM(int, ZLBackgroundModeType) {
    ZLBackgroundModeDefault = 0,
    ZLBackgroundModeNew1 = 1,
};

#define ZL_MAX_WALL_COUNT      6//墙块数目

@interface SKSharedAtles : SKTextureAtlas

+ (SKTexture *)textureWithType:(ZLTextureType)type;


+(SKAction *)playerAction;

+(SKAction *)coinAction;
@end
