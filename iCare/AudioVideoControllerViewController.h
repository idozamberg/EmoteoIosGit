//
//  AudioVideoControllerViewController.h
//  iCare
//
//  Created by ido zamberg on 21/12/13.
//  Copyright (c) 2013 ido zamberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioFile.h"
#import "FlowManager.h"
#import "Exercise.h"
#import "EMGTableView.h"

@interface AudioVideoControllerViewController : UIViewController <EMGTableViewDelegate, UIScrollViewDelegate>
{
	AVAudioPlayer *audioPlayer;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yConstraint;
@property (weak, nonatomic) IBOutlet UIButton *btnPlayAudio;
@property (weak, nonatomic) IBOutlet UIButton *btnShowList;
@property (strong,nonatomic) AudioFile*        currentAudioFile;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblLevel;
@property (weak, nonatomic) IBOutlet UIImageView *imgBg;
@property (nonatomic) BOOL shouldPerformColorTherapy;
@property (weak, nonatomic) IBOutlet UIView *vwFrame;
@property (strong,nonatomic) UIColor* frameColor;
@property (weak, nonatomic) IBOutlet UIButton *btnStop;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeLeft;
- (IBAction)stopClicked:(id)sender;

- (IBAction)playClicked:(id)sender;
- (IBAction)showListClicked:(id)sender;
- (void) setAudioFile : (AudioFile*) file;
- (IBAction)backClicked:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *vwVideoFrame;
@property (weak, nonatomic) IBOutlet UIView *vwFrameVideo;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlCardTable;
@property (weak, nonatomic) IBOutlet UILabel *lblShowList;
@property (weak, nonatomic) IBOutlet UIImageView *imgLastline;

@end
 