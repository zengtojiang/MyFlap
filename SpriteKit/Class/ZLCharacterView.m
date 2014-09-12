//
//  ZLCharacterView.m
//  SpriteKit
//
//  Created by libs on 14-4-10.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import "ZLCharacterView.h"

@implementation ZLCharacterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.userInteractionEnabled=YES;
//        imvIcon=[[UIImageView alloc] initWithFrame:self.bounds];
//        [self addSubview:imvIcon];
//        imvIcon.userInteractionEnabled=YES;
        /*
        maskView=[[UIView alloc] initWithFrame:self.bounds];
        maskView.backgroundColor=[UIColor blackColor];
        maskView.alpha=0.3;
        [self addSubview:maskView];
        */
        //maskView.userInteractionEnabled=YES;
    }
    return self;
}

//-(void)setImage:(UIImage *)image;
//{
//    imvIcon.image=image;
//}

-(void)setMaskViewShow:(BOOL)show
{
    //maskView.hidden=!show;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
