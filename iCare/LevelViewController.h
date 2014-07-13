//
//  LevelViewController.h
//  iCare
//
//  Created by ido zamberg on 19/12/13.
//  Copyright (c) 2013 ido zamberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AppData.h"
#import "VideoFile.h"
#import "Exercise.h"

@interface LevelViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIImageView *imgPlay;
@property (weak, nonatomic) IBOutlet UIImageView *imgThumb;
@property (strong, nonatomic) VideoFile* currentVideo;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnChoose;
@property (weak, nonatomic) IBOutlet UILabel *lblLevel;
@property (nonatomic,strong) Exercise* currentExercise;
@property (weak, nonatomic) IBOutlet UIImageView *imgBg;
@property (nonatomic)       BOOL shouldPerformColorTherapy;

- (IBAction)playClicked:(id)sender;
- (void) setVideo : (VideoFile*) video;
- (IBAction)chooseClicked:(id)sender;
- (IBAction)backClicked:(id)sender;

@end
