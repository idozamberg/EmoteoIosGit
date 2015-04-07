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

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

@interface AudioVideoControllerViewController ()

@end

@implementation AudioVideoControllerViewController
{
    NSTimer * tmrPlaying;
    MPMoviePlayerController* moviePlayer;
    UIImageView* thumbView;
    EMGTableView* exList;
    NSMutableArray* exerciseList;
}

@synthesize currentAudioFile,vwFrame,frameColor,vwVideoFrame,scrlCardTable;
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
    
    scrlCardTable.pagingEnabled = YES;
    
    // Activiting scrolling properties
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    [self setEdgesForExtendedLayout:UIRectEdgeAll];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;

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
        self.view.backgroundColor = [UIHelper generateRandomColor];
        self.imgBg.hidden = YES;
        
        // Setting timer
        [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(animateChangeBgColor) userInfo:Nil repeats:YES];
    }
}


- (void) animateChangeBgColor
{
    [UIView animateWithDuration:1.5 animations:^{
        
        self.view.backgroundColor = [UIHelper generateRandomColor];
        
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
        
        [self setUpLables];
        [self updateTimeLeft];

    }
    
    // Sending analytics
    [AnalyticsManager sharedInstance].sendToGoogle =YES;
    [AnalyticsManager sharedInstance].sendToFlurry =YES;
    [AnalyticsManager sharedInstance].flurryParameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",self.currentAudioFile.title],@"Exercise Name",@"Audio",@"Exercise Type", nil];
    
    if (_shouldPerformColorTherapy)
    {
        [[AnalyticsManager sharedInstance] sendEventWithName:@"Exercise Chosen from menu" Category:@"Exercises" Label:[NSString stringWithFormat:@"%@",self.currentAudioFile.title]];
        
        [self setUpLables];
        [self updateTimeLeft];
        [self showAnimation];
    }
    else
    {
        [[AnalyticsManager sharedInstance] sendEventWithName:@"Exercise Chosen" Category:@"Exercises" Label:[NSString stringWithFormat:@"%@",self.currentAudioFile.title]];
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [self setUpLables];
    
    [self updateTimeLeft];
    
    [self showAnimation];
    
    [self addCardTableView];

}

- (void) setUpLables
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
    
    // Stopping audio
    [self stopAudio];
    
    // Going back
    [self backClicked:self];
    
}

- (void) stopAudio
{
    // Changing button image
    if ([audioPlayer isPlaying])
    {
        [audioPlayer pause];
        [self.btnPlayAudio setBackgroundImage:[UIImage imageNamed:@"play_off.png"]  forState:UIControlStateNormal];
        [self.btnPlayAudio setBackgroundImage:[UIImage imageNamed:@"play_on.png"]  forState:UIControlStateHighlighted];
        
    }
    
    // Stoping player
    [audioPlayer stop];
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
      
     // [moviePlayer performSelectorInBackground:@selector(play) withObject:Nil];
      
      [moviePlayer play];
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

- (IBAction)showListClicked:(id)sender
{
    
    NSArray* list;
    
    if (self.shouldPerformColorTherapy)
    {
        list = [[AppData sharedInstance] getAllAudios];
    }
    else
    {
        // Getting list
        list = [[AppData sharedInstance] getExerciseListForLevel:[NSNumber numberWithInteger:[AppData sharedInstance].currentLevel]];
    }

    // Setting exercise list
    exerciseList = list;
    [exList setTableDataSource:list];
    

    [self scrollViewGoDown];
    
    /*
    
   
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
    }*/
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

- (void) addCardTableView
{
    // Adding other exercises
    NSArray* list = [[AppData sharedInstance] getExerciseListForLevel:[NSNumber numberWithInteger:[AppData sharedInstance].currentLevel]];
    exList = [[EMGTableView alloc] initTableWithData:list lowerPoint:CGPointMake(28, self.vwFrame.frame.origin.y + self.vwFrame.frame.size.height) upperPoint:CGPointMake(0, self.vwFrame.frame.origin.y+1) andFrame:CGRectMake(0, 0, 265, vwFrame.frame.size.height-2)];
    exList.EMGDelegate = self;
    
    // Reloading rable
    [exList.tblList reloadData];
    
    [scrlCardTable addSubview:exList];
    [exList setYPosition:scrlCardTable.frame.size.height];
    
    // Setting scroll view
    scrlCardTable.scrollEnabled = NO;
    scrlCardTable.delegate = self;
    [scrlCardTable setContentSize:CGSizeMake(scrlCardTable.frame.size.width, scrlCardTable.frame.size.height * 2)];
}

- (void) EMGTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Stop current audio
    [self stopAudio];

    // Set new audio
    [self setAudioFile:[exerciseList objectAtIndex:indexPath.row]];
 
    // Moving offest 
    [self scrollViewGoUp];
}

- (void) scrollViewGoUp
{
    [self.scrlCardTable setContentOffset:CGPointMake(0, 0) animated:YES];
    self.lblShowList.hidden = NO;
    self.imgLastline.hidden = NO;
}

- (void) scrollViewGoDown
{
    [self.scrlCardTable setContentOffset:CGPointMake(0, self.scrlCardTable.frame.size.height) animated:YES];
    self.lblShowList.hidden = YES;
    self.imgLastline.hidden = YES;
}

CGFloat lastContentOffset;
//
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    
    //self.lblShowList.hidden = YES;
    //self.imgLastline.hidden = YES;
    
    if (lastContentOffset < scrlCardTable.contentOffset.y)
    {
    
    }
    else if (lastContentOffset > scrlCardTable.contentOffset.y)
    {
       // self.lblShowList.hidden = NO;
        //self.imgLastline.hidden = NO;
    }

    lastContentOffset =scrlCardTable.contentOffset.y;
    // do whatever you need to with scrollDirection here.
}

- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat height = scrollView.frame.size.height;
    NSInteger page = (scrollView.contentOffset.y + (0.5f * height)) / height;
    
    if (page == 0)
    {
        self.lblShowList.hidden = NO;
        self.imgLastline.hidden = NO;
    }
    else
    {
        self.lblShowList.hidden = YES;
        self.imgLastline.hidden = YES;
    }
    
}

- (void) scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    self.lblShowList.hidden = NO;
    self.imgLastline.hidden = NO;
}
@end
