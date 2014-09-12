//
//  ZLSettingView.h
//  SpriteKit
//
//  Created by libs on 14-3-26.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSIconButton.h"
#import "ZLHistoryManager.h"

@protocol ZLSettingViewDelegate;
@interface ZLSettingView : UIView
{
    HSIconButton    *mBtnEasy;
    HSIconButton    *mBtnNormal;
    HSIconButton    *mBtnDifficult;
    
    UIButton        *mBtnVoice;
    UIButton        *mBtnMusic;
    ZL_GAME_DIFFICULTY mDifficulty;
    ZL_CHARACTER_TYPE  mCharacterType;
    UIScrollView    *mCharacterScrollView;
}

@property(nonatomic,assign)id<ZLSettingViewDelegate> delegate;
@end

@protocol ZLSettingViewDelegate <NSObject>


-(void)onSettingViewClose:(ZLSettingView *)view;

-(void)onSettingViewSave:(ZLSettingView *)view;
@end