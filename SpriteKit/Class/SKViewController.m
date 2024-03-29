//
//  SKViewController.m
//  SpriteKit
//
//  Created by Ray on 14-1-20.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import "SKViewController.h"
#import "SKMainScene.h"
#import "SKSharedAtles.h"
#import "SKAppDelegate.h"
#import "ZLHistoryManager.h"

#import <QuartzCore/QuartzCore.h>

@implementation SKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    bSettingShowing=NO;
    [ZLHistoryManager setBackgroundMode:arc4random()%2];
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    // Create and configure the scene.
    SKScene * scene = [SKMainScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    
    UIImage *image = [UIImage imageNamed:@"pause3.png"];
    btnSetting = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSetting setFrame:CGRectMake(10, 25, image.size.width,image.size.height)];
    [btnSetting setImage:image forState:UIControlStateNormal];
    [btnSetting addTarget:self action:@selector(onTapSetting) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSetting];
    
    if ([ZLHistoryManager musicOpened]) {
        [(SKAppDelegate *)([UIApplication sharedApplication].delegate) startBGAudio];
    }
    if ([ZLHistoryManager isFirstLaunch]) {
        //[self onTapSetting];
        [ZLHistoryManager setFirstLaunch];
    }
}


-(void)onTapSetting
{
    if (!bSettingShowing) {
        bSettingShowing=YES;
        btnSetting.enabled=NO;
        ((SKView *)self.view).paused = YES;
        //ZLSettingView *settingview=[[ZLSettingView alloc] initWithFrame:CGRectMake(20, (self.view.frame.size.height-290)/2, self.view.frame.size.width-20*2, 290)];
        ZLSettingView *settingview=[[ZLSettingView alloc] initWithFrame:CGRectMake(20, (self.view.frame.size.height-380)/2, self.view.frame.size.width-20*2, 380)];
        settingview.delegate=self;
        [self.view addSubview:settingview];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskPortrait;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - ZLSettingViewDelegate

-(void)onSettingViewClose:(ZLSettingView *)view
{
    bSettingShowing=NO;
    btnSetting.enabled=YES;
    [view removeFromSuperview];
    view=nil;
    ((SKView *)self.view).paused = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:ZL_RESET_GAME_NOTIFICATION object:nil];
}

-(void)onSettingViewSave:(ZLSettingView *)view
{
    bSettingShowing=NO;
    btnSetting.enabled=YES;
    [view removeFromSuperview];
    view=nil;
    ((SKView *)self.view).paused = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:ZL_RESTART_GAME_NOTIFICATION object:nil];
}
@end
