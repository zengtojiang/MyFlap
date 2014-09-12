//
//  SKSharedAtles.m
//  SpriteKit
//
//  Created by Ray on 14-1-20.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import "SKSharedAtles.h"
#import "ZLHistoryManager.h"

static SKSharedAtles *_shared = nil;

@implementation SKSharedAtles


+ (instancetype)shared{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = (SKSharedAtles *)[SKSharedAtles atlasNamed:@"animations"];
    });
    return _shared;
}


+ (SKTexture *)textureWithType:(ZLTextureType)type{
    
    switch (type) {
        case ZLTextureTypeBackground:
        {
            UIImage *imageTile = [UIImage imageNamed:@"ground2.png"];
            CGRect  textureRect = CGRectMake(0, 0, imageTile.size.width, imageTile.size.height);
            UIGraphicsBeginImageContext(CGSizeMake(320, imageTile.size.height));//[[UIScreen mainScreen] currentMode].size
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextRotateCTM(context, M_PI); //先旋转180度，是按照原先顺时针方向旋转的。这个时候会发现位置偏移了
            CGContextScaleCTM(context, -1, 1); //再水平旋转一下
            CGContextTranslateCTM(context,0, -imageTile.size.height);
            CGContextDrawTiledImage(context, textureRect, imageTile.CGImage);
            UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return [SKTexture textureWithCGImage:retImage.CGImage];
        }
            break;
        case ZLTextureTypeBackLayer1:
            if ([ZLHistoryManager getBackgroundMode]==ZLBackgroundModeDefault) {
                return [SKTexture textureWithImageNamed:@"bg_layer1.png"];
            }else{
                 return [SKTexture textureWithImageNamed:@"portrait_bg3.png"];
            }
            //return [SKTexture textureWithImageNamed:@"bg_layer1.png"];
            break;
        case ZLTextureTypeBackLayer2:
            if ([ZLHistoryManager getBackgroundMode]==ZLBackgroundModeDefault) {
                return [SKTexture textureWithImageNamed:@"bg_layer2.png"];
            }else{
                return [SKTexture textureWithImageNamed:@"portrait_cloud2.png"];
            }
            //return [SKTexture textureWithImageNamed:@"portrait_cloud2.png"];
            //return [SKTexture textureWithImageNamed:@"bg_layer2.png"];
            //return [[[self class] shared] textureNamed:@"bg_layer2"];
            break;
        case ZLTextureTypeBird:
            return [[[self class] shared] textureNamed:[NSString stringWithFormat:@"character_%d_0.png",[ZLHistoryManager getCharacterType]]];
           // return [SKTexture textureWithImageNamed:@"bird_down.png"];
            break;
        case ZLTextureTypeWall:
        {
            UIImage *imageTile = [UIImage imageNamed:@"wall_tile.png"];
            CGRect  textureRect = CGRectMake(0, 0, imageTile.size.width, imageTile.size.height);
            UIGraphicsBeginImageContext(CGSizeMake(imageTile.size.width, imageTile.size.height*ZL_MAX_WALL_COUNT));
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextRotateCTM(context, M_PI); //先旋转180度，是按照原先顺时针方向旋转的。这个时候会发现位置偏移了
            CGContextScaleCTM(context, -1, 1); //再水平旋转一下
            CGContextTranslateCTM(context,0, -imageTile.size.height);
            CGContextDrawTiledImage(context, textureRect, imageTile.CGImage);
            UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return [SKTexture textureWithCGImage:retImage.CGImage];
        }
            break;
        case ZLTextureTypeCoin:
            return [[[self class] shared] textureNamed:@"Coins_0_0.png"];
            // return [SKTexture textureWithImageNamed:@"bird_down.png"];
            break;
        default:
            break;
    }
    return nil;
}

+ (SKTexture *)playerTextureWithIndex:(int)index characterType:(int)type {
    //return [[[self class] shared] textureNamed:[NSString stringWithFormat:@"player1-n%d.png",index]];
    return [[[self class] shared] textureNamed:[NSString stringWithFormat:@"character_%d_%d.png",type,index]];
}

+ (SKTexture *)coinTextureWithIndex:(int)index {
    //return [[[self class] shared] textureNamed:[NSString stringWithFormat:@"player1-n%d.png",index]];
    return [[[self class] shared] textureNamed:[NSString stringWithFormat:@"Coins_0_%d.png",index]];
}


+(SKTexture *)dropBird
{
    return [[[self class] shared] textureNamed:@"bird5.png"];
}

+ (SKAction *)playerAction
{
    NSMutableArray *textures = [[NSMutableArray alloc]init];
    int type=[ZLHistoryManager getCharacterType];
    int startIndex=0;
    int endIndex=0;
    if (type==ZL_CHARACTER_DEFAULT) {
        endIndex=1;
    }else if(type==ZL_CHARACTER_4){
        endIndex=2;
    }else{
        endIndex=3;
    }
    for (int i= startIndex; i<=endIndex; i++) {
        SKTexture *texture = [[self class] playerTextureWithIndex:i characterType:type];
        
        [textures addObject:texture];
    }
    return [SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.1f]];
}

+ (SKAction *)coinAction
{
    NSMutableArray *textures = [[NSMutableArray alloc]init];
    for (int i= 0; i<=5; i++) {
        SKTexture *texture = [[self class] coinTextureWithIndex:i];
        
        [textures addObject:texture];
    }
    return [SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.1f]];
}
@end
