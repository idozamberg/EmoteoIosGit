//
//  ScaleViewController.h
//  iCare
//
//  Created by ido zamberg on 08/12/13.
//  Copyright (c) 2013 ido zamberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrgenceViewController.h"
#import "MessageView.h"
#import "LevelViewController.h"
#import "AudioVideoControllerViewController.h"
#import "AppData.h"
#import "ATCAnimatedTransitioningFade.h"

@interface ScaleViewController : UIViewController <UIScrollViewDelegate,UINavigationControllerDelegate,UIViewControllerTransitioningDelegate>
{
    BOOL buttonOn;
    BOOL isButtonFlashing;
    NSTimer* timerFlash;
    MessageView* info;
    NSInteger currentButtonClicked;
    UIButton* currentPressedButton;
}

@property (weak, nonatomic) IBOutlet UIScrollView *svScales;
@property (weak, nonatomic) IBOutlet UILabel *lblLevelNumber;
@property (weak, nonatomic) IBOutlet UIImageView *ivScales;
@property (weak, nonatomic) IBOutlet UIImageView *imgBigUp;
@property (weak, nonatomic) IBOutlet UIImageView *imgbigDown;
@property (weak, nonatomic) IBOutlet UIButton *btnLevel;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIImageView *imgUp;
@property (weak, nonatomic) IBOutlet UIImageView *imgDown;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrowUp;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrowDown;
@property (nonatomic, strong) ATCAnimatedTransitioningFade* animator;

- (IBAction)emergencyClicked:(id)sender;
- (IBAction)level8Clicked:(id)sender;
- (IBAction)levelClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnEmergency;
@end
