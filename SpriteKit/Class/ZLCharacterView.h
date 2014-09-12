//
//  ZLCharacterView.h
//  SpriteKit
//
//  Created by libs on 14-4-10.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLCharacterView : UIButton
{
    //UIImageView     *imvIcon;
    UIView          *maskView;
}

//-(void)setImage:(UIImage *)image;

-(void)setMaskViewShow:(BOOL)show;
@end
