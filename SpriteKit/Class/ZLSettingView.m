//
//  ZLSettingView.m
//  SpriteKit
//
//  Created by libs on 14-3-26.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import "ZLSettingView.h"
#import "SKAppDelegate.h"
#import "ZLCharacterView.h"

@interface ZLSettingView()

@property(nonatomic,retain)UIColor         *mNormalColor;
@property(nonatomic,retain)UIColor         *mHighlightedColor;

@end

#define CHARACTERITEM_HEIGHT  60

@implementation ZLSettingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.cornerRadius=5;
        mDifficulty=[ZLHistoryManager getDifficulty];
        mCharacterType=[ZLHistoryManager getCharacterType];
        [self initBackground];
        [self initColor];
       // [self initGameModeOptions];
        [self initDifficultyOptions];
        [self initVoiceMusic];
        [self initCharacterScrollView];
    }
    return self;
}

-(void)initCharacterScrollView
{
    mCharacterScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(15, 65, self.frame.size.width-30, CHARACTERITEM_HEIGHT)];
    mCharacterScrollView.scrollEnabled=YES;
    mCharacterScrollView.userInteractionEnabled=YES;
    
    UIImageView *scrollBG=[[UIImageView alloc] initWithFrame:mCharacterScrollView.frame];
    scrollBG.image=[UIImage imageNamed:@"setting_charbg.png"];
    [self addSubview:scrollBG];
    
    [self addSubview:mCharacterScrollView];
    
    float leftMargin=10;
    float contentLength=leftMargin;
    for (int i=ZL_CHARACTER_DEFAULT; i<=ZL_CHARACTER_4; i++) {
        contentLength +=CHARACTERITEM_HEIGHT+leftMargin;
        ZLCharacterView *characterView=[[ZLCharacterView alloc] initWithFrame:CGRectMake(leftMargin*(i+1)+i*CHARACTERITEM_HEIGHT, 5, CHARACTERITEM_HEIGHT-10, CHARACTERITEM_HEIGHT-10)];
        [characterView setBackgroundImage:[UIImage imageNamed:@"alpha.png"] forState:UIControlStateSelected];
        [characterView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"character_%d_0.png",i]] forState:UIControlStateNormal];
        [characterView setSelected:(i!=mCharacterType)];
        //[characterView setMaskViewShow:i!=mCharacterType];
        characterView.tag=300+i;
        [characterView addTarget:self action:@selector(onTapCharacterTypeView:) forControlEvents:UIControlEventTouchUpInside];
        [mCharacterScrollView addSubview:characterView];
    }
    [mCharacterScrollView setContentSize:CGSizeMake(contentLength, CHARACTERITEM_HEIGHT)];
}

-(void)initBackground
{
    self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"alpha2.png"]];
    //self.backgroundColor=[];
    /*
    UIImageView *bgView=[[UIImageView alloc] initWithFrame:self.bounds];
    bgView.image=[UIImage imageNamed:@"setting_bg"];
    [self addSubview:bgView];
    */
    UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(85, 13, self.frame.size.width-170, 40)];
    lblTitle.text=@"Setting";
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.textAlignment=NSTextAlignmentCenter;
    lblTitle.font=[UIFont fontWithName:@"ChalkboardSE-Bold" size:24];
    [self addSubview:lblTitle];
    
    UIButton *btnClose=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *closeImage=[UIImage imageNamed:@"close.png"];
    [btnClose setImage:closeImage forState:UIControlStateNormal];
    btnClose.frame=CGRectMake(14, 13, closeImage.size.width, closeImage.size.height);
    [btnClose addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnClose];
    
    UIButton *btnSave=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *saveImage=[UIImage imageNamed:@"save2.png"];
    [btnSave setImage:saveImage forState:UIControlStateNormal];
    btnSave.frame=CGRectMake(self.frame.size.width-50, 15, saveImage.size.width, saveImage.size.height);
    [btnSave addTarget:self action:@selector(onSave) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnSave];
}

-(void)initColor
{
    self.mNormalColor=HEXCOLOR(0xc1c9cd);//[UIColor whiteColor];
    self.mHighlightedColor=HEXCOLOR(0x3da2d0);//HEXCOLOR(0x1f7cc3);//[UIColor magentaColor];
    
}

/*
-(void)initGameModeOptions
{
    mBtnEasy=[[HSIconButton alloc] initWithFrame:CGRectMake(btnLeftMargin, btnTopMargin, btnWidth, btnHeight)];
    mBtnEasy.imvIcon.frame=CGRectMake(0, 0, btnHeight, btnHeight);
    [mBtnEasy setNormalImage:[UIImage imageNamed:@"nochecked"]];
    [mBtnEasy setSelectedImage:[UIImage imageNamed:@"checked2"]];
    mBtnEasy.lblTitle.frame=CGRectMake(btnHeight+7, 0,btnWidth-btnHeight-(7*2), btnHeight);
    mBtnEasy.lblTitle.font=[UIFont fontWithName:@"ChalkboardSE-Bold" size:18];
    mBtnEasy.tag=100+ZL_DIFFICULTY_EASY;
    mBtnEasy.lblTitle.adjustsFontSizeToFitWidth=YES;
    mBtnEasy.lblTitle.text=@"Easy";
    [mBtnEasy addTarget:self action:@selector(onTapDifficultyButton:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:mBtnEasy];
    
    mBtnNormal=[[HSIconButton alloc] initWithFrame:CGRectMake(btnLeftMargin, btnTopMargin+btnItemHeight, btnWidth, btnHeight)];
    mBtnNormal.imvIcon.frame=CGRectMake(0, 0, btnHeight, btnHeight);
    [mBtnNormal setNormalImage:[UIImage imageNamed:@"nochecked"]];
    [mBtnNormal setSelectedImage:[UIImage imageNamed:@"checked2"]];
    mBtnNormal.lblTitle.frame=CGRectMake(btnHeight+7, 0,btnWidth-btnHeight-(7*2), btnHeight);
    mBtnNormal.lblTitle.font=[UIFont fontWithName:@"ChalkboardSE-Bold" size:18];
    mBtnNormal.tag=100+ZL_DIFFICULTY_NORMAL;
    mBtnNormal.lblTitle.adjustsFontSizeToFitWidth=YES;
    mBtnNormal.lblTitle.text=@"Normal";
    [mBtnNormal addTarget:self action:@selector(onTapDifficultyButton:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:mBtnNormal];
}
 */

-(void)initDifficultyOptions
{
    float btnLeftMargin=45;
    float btnTopMargin=100+CHARACTERITEM_HEIGHT+10;
    float btnHeight   =30;
    float btnItemHeight=35;
    float btnWidth=240;
    
    UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(btnLeftMargin-10, 65+CHARACTERITEM_HEIGHT+10, self.frame.size.width-100, 20)];
    lblTitle.text=@"Difficulty:";
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.font=[UIFont fontWithName:@"ChalkboardSE-Bold" size:20];
    [self addSubview:lblTitle];
    
    mBtnEasy=[[HSIconButton alloc] initWithFrame:CGRectMake(btnLeftMargin, btnTopMargin, btnWidth, btnHeight)];
    mBtnEasy.imvIcon.frame=CGRectMake(0, 0, btnHeight, btnHeight);
    [mBtnEasy setNormalImage:[UIImage imageNamed:@"nochecked"]];
    [mBtnEasy setSelectedImage:[UIImage imageNamed:@"checked2"]];
    mBtnEasy.lblTitle.frame=CGRectMake(btnHeight+7, 0,btnWidth-btnHeight-(7*2), btnHeight);
    mBtnEasy.lblTitle.font=[UIFont fontWithName:@"ChalkboardSE-Bold" size:18];
    mBtnEasy.tag=100+ZL_DIFFICULTY_EASY;
    mBtnEasy.lblTitle.adjustsFontSizeToFitWidth=YES;
    mBtnEasy.lblTitle.text=@"Easy(One gold per 3 points)";
    [mBtnEasy addTarget:self action:@selector(onTapDifficultyButton:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:mBtnEasy];
    
    mBtnNormal=[[HSIconButton alloc] initWithFrame:CGRectMake(btnLeftMargin, btnTopMargin+btnItemHeight, btnWidth, btnHeight)];
    mBtnNormal.imvIcon.frame=CGRectMake(0, 0, btnHeight, btnHeight);
    [mBtnNormal setNormalImage:[UIImage imageNamed:@"nochecked"]];
    [mBtnNormal setSelectedImage:[UIImage imageNamed:@"checked2"]];
    mBtnNormal.lblTitle.frame=CGRectMake(btnHeight+7, 0,btnWidth-btnHeight-(7*2), btnHeight);
    mBtnNormal.lblTitle.font=[UIFont fontWithName:@"ChalkboardSE-Bold" size:18];
    mBtnNormal.tag=100+ZL_DIFFICULTY_NORMAL;
    mBtnNormal.lblTitle.adjustsFontSizeToFitWidth=YES;
    mBtnNormal.lblTitle.text=@"Normal(One gold per point)";
    [mBtnNormal addTarget:self action:@selector(onTapDifficultyButton:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:mBtnNormal];
    
    mBtnDifficult=[[HSIconButton alloc] initWithFrame:CGRectMake(btnLeftMargin, btnTopMargin+2*btnItemHeight, btnWidth, btnHeight)];
    mBtnDifficult.imvIcon.frame=CGRectMake(0, 0, btnHeight, btnHeight);
    [mBtnDifficult setNormalImage:[UIImage imageNamed:@"nochecked"]];
    [mBtnDifficult setSelectedImage:[UIImage imageNamed:@"checked2"]];
    mBtnDifficult.lblTitle.frame=CGRectMake(btnHeight+7, 0,btnWidth-btnHeight-(7*2), btnHeight);
    mBtnDifficult.lblTitle.font=[UIFont fontWithName:@"ChalkboardSE-Bold" size:18];
    mBtnDifficult.tag=100+ZL_DIFFICULTY_DIFFICULT;
    mBtnDifficult.lblTitle.adjustsFontSizeToFitWidth=YES;
    mBtnDifficult.lblTitle.text=@"Difficult(Gold linear growth)";
    [mBtnDifficult addTarget:self action:@selector(onTapDifficultyButton:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:mBtnDifficult];
    [self resetSelectedDifficulty];
}

-(void)initVoiceMusic
{
    UIImageView *imvVoiceBG=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_bg"]];
    imvVoiceBG.frame=CGRectMake(45, self.frame.size.height-80, 60, 60);
    [self addSubview:imvVoiceBG];
    
    UIImageView *imvMusicBG=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_bg"]];
    imvMusicBG.frame=CGRectMake(self.frame.size.width-60-45, self.frame.size.height-80, 60, 60);
    [self addSubview:imvMusicBG];
    
    mBtnVoice=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *voiceImage=[UIImage imageNamed:@"voice.png"];
    [mBtnVoice setBackgroundImage:voiceImage forState:UIControlStateNormal];
    [mBtnVoice setImage:[UIImage imageNamed:@"unused"] forState:UIControlStateSelected];
    mBtnVoice.frame=CGRectMake(55, self.frame.size.height-70, voiceImage.size.width, voiceImage.size.height);
    [mBtnVoice addTarget:self action:@selector(onChangeVoiceState) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mBtnVoice];
    [mBtnVoice setSelected:![ZLHistoryManager voiceOpened]];
    
    
    mBtnMusic=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *musicImage=[UIImage imageNamed:@"music.png"];
    [mBtnMusic setBackgroundImage:musicImage forState:UIControlStateNormal];
    [mBtnMusic setImage:[UIImage imageNamed:@"unused"] forState:UIControlStateSelected];
    mBtnMusic.frame=CGRectMake(self.frame.size.width-musicImage.size.width-55, self.frame.size.height-70, musicImage.size.width, musicImage.size.height);
    [mBtnMusic addTarget:self action:@selector(onChangeMusicState) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mBtnMusic];
    [mBtnMusic setSelected:![ZLHistoryManager musicOpened]];
}

-(void)resetSelectedDifficulty
{
    if (mDifficulty==ZL_DIFFICULTY_EASY) {
        [mBtnEasy setSelected:YES];
        mBtnEasy.lblTitle.textColor=self.mHighlightedColor;
        [mBtnNormal setSelected:NO];
        mBtnNormal.lblTitle.textColor=self.mNormalColor;
        [mBtnDifficult setSelected:NO];
        mBtnDifficult.lblTitle.textColor=self.mNormalColor;
    }else if(mDifficulty==ZL_DIFFICULTY_NORMAL) {
        [mBtnNormal setSelected:YES];
        mBtnNormal.lblTitle.textColor=self.mHighlightedColor;
        [mBtnEasy setSelected:NO];
        mBtnEasy.lblTitle.textColor=self.mNormalColor;
        [mBtnDifficult setSelected:NO];
        mBtnDifficult.lblTitle.textColor=self.mNormalColor;
    }else if(mDifficulty==ZL_DIFFICULTY_DIFFICULT) {
        [mBtnDifficult setSelected:YES];
        mBtnDifficult.lblTitle.textColor=self.mHighlightedColor;
        [mBtnNormal setSelected:NO];
        mBtnNormal.lblTitle.textColor=self.mNormalColor;
        [mBtnEasy setSelected:NO];
        mBtnEasy.lblTitle.textColor=self.mNormalColor;
    }
}

-(void)resetCurrentCharacterType
{
    for (UIView *child in [mCharacterScrollView subviews]) {
        if ([child isKindOfClass:[ZLCharacterView class]]) {
            ZLCharacterView *characterView=(ZLCharacterView *)child;
            [characterView setSelected:((characterView.tag-300)!=mCharacterType)];
            //[characterView setMaskViewShow:(characterView.tag-300)!=mCharacterType];
        }
    }
}



-(void)onTapDifficultyButton:(HSIconButton *)sender
{
    mDifficulty=(int)sender.tag-100;
    [self resetSelectedDifficulty];
}

-(void)onTapCharacterTypeView:(ZLCharacterView *)sender
{
    mCharacterType=(int)sender.tag-300;
    [self resetCurrentCharacterType];
}

-(void)onChangeVoiceState
{
    BOOL open=[ZLHistoryManager voiceOpened];
    [ZLHistoryManager setVoiceOpened:!open];
    [mBtnVoice setSelected:open];
}

-(void)onChangeMusicState
{
    BOOL open=[ZLHistoryManager musicOpened];
    [ZLHistoryManager setMusicOpened:!open];
    [mBtnMusic setSelected:open];
    if ([ZLHistoryManager musicOpened]) {
        [(SKAppDelegate *)([UIApplication sharedApplication].delegate) startBGAudio];
    }else{
        [(SKAppDelegate *)([UIApplication sharedApplication].delegate) stopBGAudio];
    }
}

-(void)onCancel
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(onSettingViewClose:)]) {
//        [ZLHistoryManager setDifficulty:mDifficulty];
//        [ZLHistoryManager setCharacterType:mCharacterType];
        [self.delegate onSettingViewClose:self];
    }
}

-(void)onSave
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(onSettingViewSave:)]) {
        [ZLHistoryManager setDifficulty:mDifficulty];
        [ZLHistoryManager setCharacterType:mCharacterType];
        [self.delegate onSettingViewSave:self];
    }
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
