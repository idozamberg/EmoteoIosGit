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
#import "EMGTableView.h"
#import "AudioFile.h"

@interface LevelViewController : UIViewController <EMGTableViewDelegate>
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
@property (weak, nonatomic) IBOutlet UIScrollView *scrlCardTable;
@property (weak, nonatomic) IBOutlet UIView *vwFrame;

- (IBAction)playClicked:(id)sender;
- (void) setVideo : (VideoFile*) video;
- (IBAction)chooseClicked:(id)sender;
- (IBAction)backClicked:(id)sender;


// Audio
@property (weak, nonatomic) IBOutlet UIView *vwAudio;
@property (weak, nonatomic) IBOutlet UIButton *btnPlayAudio;
@property (weak, nonatomic) IBOutlet UIButton *btnShowList;
@property (strong,nonatomic) AudioFile*        currentAudioFile;
@property (weak, nonatomic) IBOutlet UILabel *lblAudioTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTensionLevel;
@property (weak, nonatomic) IBOutlet UIButton *btnStop;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeLeft;
- (IBAction)stopClicked:(id)sender;

- (IBAction)audioPlayClicked:(id)sender;
- (IBAction)showListClicked:(id)sender;
- (void) setAudioFile : (AudioFile*) file;
@end
