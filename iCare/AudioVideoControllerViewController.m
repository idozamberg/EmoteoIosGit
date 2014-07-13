//
//  AudioVideoControllerViewController.m
//  iCare
//
//  Created by ido zamberg on 21/12/13.
//  Copyright (c) 2013 ido zamberg. All rights reserved.
//

#import "AudioVideoControllerViewController.h"
#import "AppData.h"
#import "MediaPlayer/MediaPlayer.h"



@interface AudioVideoControllerViewController ()

@end

@implementation AudioVideoControllerViewController
{
    NSTimer * tmrPlaying;
    MPMoviePlayerController* moviePlayer;
    UIImageView* thumbView;
}

@synthesize currentAudioFile,vwFrame,frameColor,vwVideoFrame;
@synthesize shouldPerformColorTherapy = _shouldPerformColorTherapy;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) init
{
    self = [super init];
    
    _shouldPerformColorTherapy = NO;
    
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    // Changing background
    [self.imgBg setYPosition:-(10-[AppData sharedInstance].currentLevel) * self.view.frame.size.height];
    
}

- (void) showAnimation
{
    
    if (moviePlayer)
    {
        [moviePlayer.view removeFromSuperview];
        moviePlayer = Nil;
    }
    
    // Setting video
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"animation" ofType:@"m4v"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    
    // setting video frame
    moviePlayer.view.frame = self.vwFrameVideo.frame;
    [moviePlayer.view setXPosition:0];
    [moviePlayer.view setYPosition:0];
    [moviePlayer setShouldAutoplay:NO];
    
    // Setting properties
    moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    moviePlayer.controlStyle =  MPMovieControlStyleNone;
    
    // Adding view
    [self.vwFrameVideo addSubview:moviePlayer.view];
    [self.vwFrameVideo bringSubviewToFront:moviePlayer.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayer];
    
    // Setting thumb image
    UIImage *thumbnail = [moviePlayer thumbnailImageAtTime:1.0
                                                         timeOption:MPMovieTimeOptionNearestKeyFrame];
    
    
    // Setting thumbnail
    thumbView = [[UIImageView alloc] initWithImage:thumbnail];
    [thumbView setFrame:moviePlayer.view.frame];
    thumbView.contentMode = UIViewContentModeScaleToFill;
    
    [self.vwFrameVideo addSubview:thumbView];
    [self.vwFrameVideo sendSubviewToBack:thumbView];
}

- (void)moviePlayerDidFinish:(NSNotification *)note
{
    if (note.object == moviePlayer) {
        NSInteger reason = [[note.userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
        if (reason == MPMovieFinishReasonPlaybackEnded)
        {
            [moviePlayer play];
        }
    }
}

- (void) setShouldPerformColorTherapy:(BOOL)shouldPerformColorTherapyParam
{
    _shouldPerformColorTherapy = shouldPerformColorTherapyParam;
    
    // Checking if we should activate timer for changing bgColor
    if (_shouldPerformColorTherapy)
    {
        self.vwFrame.backgroundColor = [UIHelper generateRandomColor];
        self.imgBg.hidden = YES;
        
        // Setting timer
        [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(animateChangeBgColor) userInfo:Nil repeats:YES];
    }
}


- (void) animateChangeBgColor
{
    [UIView animateWithDuration:1.5 animations:^{
        
        self.vwFrame.backgroundColor = [UIHelper generateRandomColor];
        
    }];
    
    [UIView commitAnimations];
}


- (void) setAudioFile : (AudioFile*) file
{
    self.currentAudioFile = file;
    
    // Setting file
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath],file.fileName]];
	
	NSError *error;
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	audioPlayer.numberOfLoops = 0;
    
    self.lblLevel.text = @"TOUS";
    
    // Adding the exercise to the data 
    if ([AppData sharedInstance].currentLevel > 0 )
    {
        // Creating new exersice
        Exercise* newExercise = [Exercise new];
        
        newExercise.level = [NSNumber numberWithInteger:[AppData sharedInstance].currentLevel];
        newExercise.practiceTime = [NSDate date];
        newExercise.name = self.currentAudioFile.title;
        newExercise.type = exerciseTypeAudio;
        
        
        // Adding new exercise
        [[[AppData sharedInstance] currentStorm] addExercise:newExercise];
        
    }
    
    
    [AnalyticsManager sharedInstance].sendToGoogle =YES;
    [AnalyticsManager sharedInstance].sendToFlurry =YES;
    [AnalyticsManager sharedInstance].flurryParameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",self.currentAudioFile.title],@"Exercise Name",@"Audio",@"Exercise Type", nil];
    
    if (_shouldPerformColorTherapy)
    {
        [[AnalyticsManager sharedInstance] sendEventWithName:@"Exercise Chosen from menu" Category:@"Exercises" Label:[NSString stringWithFormat:@"%@",self.currentAudioFile.title]];
    }
    else
    {
        [[AnalyticsManager sharedInstance] sendEventWithName:@"Exercise Chosen" Category:@"Exercises" Label:[NSString stringWithFormat:@"%@",self.currentAudioFile.title]];
    }
}

- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    // Setting level
    self.lblLevel.text = [NSString stringWithFormat:@"%i",[AppData sharedInstance].currentLevel];
    self.lblTitle.text = currentAudioFile.title;
    
    self.lblTimeLeft.text = @"";
    
    if (self.shouldPerformColorTherapy)
    {
        self.imgBg.hidden = YES;
        vwFrame.backgroundColor = frameColor;
        self.lblLevel.text = @"TOUS";
        
    }
    
    [self updateTimeLeft];
    
    [self showAnimation];

}

- (void) viewWillDisappear:(BOOL)animated
{
    if ([AppData sharedInstance].currentLevel > 0 )
    {
        [AppData sharedInstance].shouldEvaluateTension = YES;
    }
    
    // stoping music
    [audioPlayer stop];
}


- (IBAction)stopClicked:(id)sender {
    

    // Changing button image
    if ([audioPlayer isPlaying])
    {
        [audioPlayer pause];
        [self.btnPlayAudio setBackgroundImage:[UIImage imageNamed:@"play_off.png"]  forState:UIControlStateNormal];
        [self.btnPlayAudio setBackgroundImage:[UIImage imageNamed:@"play_on.png"]  forState:UIControlStateHighlighted];
        
    }

    // Stoping player
    [audioPlayer stop];
    
    [self backClicked:self];
    
}

- (IBAction)playClicked:(id)sender {
    
  if ([audioPlayer isPlaying])
  {
      [audioPlayer pause];
      [self.btnPlayAudio setBackgroundImage:[UIImage imageNamed:@"play_off.png"]  forState:UIControlStateNormal];
      [self.btnPlayAudio setBackgroundImage:[UIImage imageNamed:@"play_on.png"]  forState:UIControlStateHighlighted];
      
      // Clearing timer
      if (tmrPlaying)
      {
          if ([tmrPlaying isValid])
          {
              [tmrPlaying invalidate];
          }
      }

      
      [moviePlayer pause];
  }
  else
  {
      
      //[self showAnimation];
      
      [moviePlayer performSelectorInBackground:@selector(play) withObject:Nil];
      [thumbView removeFromSuperview];
      
      [self.btnPlayAudio setBackgroundImage:[UIImage imageNamed:@"pause_off.gif"]  forState:UIControlStateNormal];
      [self.btnPlayAudio setBackgroundImage:[UIImage imageNamed:@"pause_off.gif"]  forState:UIControlStateHighlighted];
      [audioPlayer play];
      
      // Setting time timer
      
      // Clearing timer
      if (tmrPlaying)
      {
          if ([tmrPlaying isValid])
          {
              [tmrPlaying invalidate];
          }
      }
      
      tmrPlaying = [NSTimer scheduledTimerWithTimeInterval:1.0
                                       target:self
                                     selector:@selector(updateTimeLeft)
                                     userInfo:nil
                                      repeats:YES];
      
      [AnalyticsManager sharedInstance].sendToGoogle =YES;
      [AnalyticsManager sharedInstance].sendToFlurry =YES;
      [AnalyticsManager sharedInstance].flurryParameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",self.currentAudioFile.title],@"Exercise Name",@"Audio",@"Exercise Type", nil];
      
      if (_shouldPerformColorTherapy)
      {
          [[AnalyticsManager sharedInstance] sendEventWithName:@"Exercise Played from menu" Category:@"Exercises" Label:[NSString stringWithFormat:@"%@",self.currentAudioFile.title]];
      }
      else
      {
          [[AnalyticsManager sharedInstance] sendEventWithName:@"Exercise Played" Category:@"Exercises" Label:[NSString stringWithFormat:@"%@",self.currentAudioFile.title]];
      }
      
      // Saving last exercise done by the user
      [AnalyticsManager sharedInstance].lastExercise =
      [[AppData sharedInstance].currentStorm.exercises objectAtIndex:[AppData sharedInstance].currentStorm.exercises.count - 1];
  }

}

- (IBAction)showListClicked:(id)sender {
    
    if (self.shouldPerformColorTherapy)
    {
        [[FlowManager sharedInstance] showExerciseListWithList:[[AppData sharedInstance] getAllAudios] forLevel:Nil andType:audioType WithColorTherapy:YES];
    }
    else
    {
        // Getting list
        NSArray* list = [[AppData sharedInstance] getExerciseListForLevel:[NSNumber numberWithInteger:[AppData sharedInstance].currentLevel]];
        
        // Show exercise list
        [[FlowManager sharedInstance] showExerciseListWithList:list forLevel:[NSNumber numberWithInteger:[AppData sharedInstance].currentLevel] andType:mixedType];
    }
}

#pragma mark Timer

- (void)updateTimeLeft {
    
    NSInteger timeLeft = audioPlayer.duration - audioPlayer.currentTime;
    
    int minutes = timeLeft / 60;
    int secondsLeft = timeLeft % 60;
    
    
    // Checking if playing finished
    if (minutes <= 0)
    {
        minutes = 0;
        
        if (secondsLeft <= 0)
        {
            secondsLeft = 0;
            [audioPlayer stop];
            [tmrPlaying invalidate];
        }
    }
    
    
    NSString* formattedTime = [NSString stringWithFormat: @"%02i:%02i", minutes, secondsLeft];
    
    self.lblTimeLeft.text = formattedTime;
    
    // update your UI with timeLeft
    //self.timeLeftLabel.text = [NSString stringWithFormat:@"%f seconds left", timeLeft];
}

- (BOOL) shouldAutorotate
{
    return NO;
}
@end
