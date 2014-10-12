//
//  LevelViewController.m
//  iCare
//
//  Created by ido zamberg on 19/12/13.
//  Copyright (c) 2013 ido zamberg. All rights reserved.
//

#import "LevelViewController.h"
#import "ExerciseListViewController.h"
#import "FlowManager.h"
#import "UIView+Framing.h"
#import "EMGTableView.h"



@interface LevelViewController ()
{
    UIActivityIndicatorView* indicator;
    MPMoviePlayerViewController *theMovie;
    BOOL isPlaying;
    EMGTableView* exList;
    NSMutableArray* exerciseList;
    AVAudioPlayer *audioPlayer;
    NSTimer * tmrPlaying;

}

@end

@implementation LevelViewController

@synthesize currentVideo,scrlCardTable,vwFrame;
@synthesize shouldPerformColorTherapy = _shouldPerformColorTherapy;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    isPlaying = NO;
    
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
    }
    else
    {
        [[AnalyticsManager sharedInstance] sendEventWithName:@"Exercise Chosen" Category:@"Exercises" Label:[NSString stringWithFormat:@"%@",self.currentAudioFile.title]];
    }
    
}

- (void) setUpLables
{
    // Setting level
    self.lblTensionLevel.text = [NSString stringWithFormat:@"%i",[AppData sharedInstance].currentLevel];
    self.lblAudioTitle.text = self.currentAudioFile.title;
    
    self.lblTimeLeft.text = @"";
    
   /* if (self.shouldPerformColorTherapy)
    {
        self.imgBg.hidden = YES;
        vwFrame.backgroundColor = frameColor;
        self.lblLevel.text = @"TOUS";
        
    }*/
}

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


- (void) setVideo : (VideoFile*) video
{
    self.currentVideo = video;
    
    // Load video
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:currentVideo.fileName ofType:currentVideo.fileType];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    theMovie = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
    theMovie.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    theMovie.view.frame = self.view.frame;
    
    // Setting thumb image
    UIImage *thumbnail = [theMovie.moviePlayer thumbnailImageAtTime:140.0
                                                         timeOption:MPMovieTimeOptionNearestKeyFrame];
    [theMovie.moviePlayer stop];
    
    [self.imgThumb setImage:thumbnail];
    
    
    // Adding exercise 
    if ([AppData sharedInstance].currentLevel > 0 )
    {
        // Creating new exersice
        Exercise* newExercise = [Exercise new];
        
        // Setting excersice data
        newExercise.level = [NSNumber numberWithInteger:[AppData sharedInstance].currentLevel];
        newExercise.practiceTime = [NSDate date];
        newExercise.name = self.currentVideo.title;
        newExercise.type = exerciseTypeVideo;
        
        // Adding new exercise
        [[[AppData sharedInstance] currentStorm] addExercise:newExercise];
    }
    
    [AnalyticsManager sharedInstance].sendToGoogle =YES;
    [AnalyticsManager sharedInstance].sendToFlurry =YES;
    [AnalyticsManager sharedInstance].flurryParameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",self.currentVideo.title],@"Exercise Name",@"Video",@"Exercise Type", nil];
    
    if (_shouldPerformColorTherapy)
    {
        [[AnalyticsManager sharedInstance] sendEventWithName:@"Exercise Chosen from menu" Category:@"Exercises" Label:[NSString stringWithFormat:@"%@",self.currentVideo.title]];
    }
    else
    {
        [[AnalyticsManager sharedInstance] sendEventWithName:@"Exercise Chosen" Category:@"Exercises" Label:[NSString stringWithFormat:@"%@",self.currentVideo.title]];
    }
    
    [self setupLabelsAndThumb];
}

- (IBAction)chooseClicked:(id)sender {

    
    NSArray* list;
    
    if (self.shouldPerformColorTherapy)
    {
        list = [[AppData sharedInstance] getAllVideos];
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
    

    
    /*if (_shouldPerformColorTherapy)
    {
        [[FlowManager sharedInstance] showExerciseListWithList:[[AppData sharedInstance] getAllVideos] forLevel:Nil andType:videoType WithColorTherapy:YES];
    }
    else
    {
        // Getting list
        NSArray* list = [[AppData sharedInstance] getExerciseListForLevel:[NSNumber numberWithInteger:[AppData sharedInstance].currentLevel]];
        
        // Show exercise list
        [[FlowManager sharedInstance] showExerciseListWithList:list forLevel:[NSNumber numberWithInteger:[AppData sharedInstance].currentLevel] andType:mixedType];
    }*/
}

- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    [indicator stopAnimating];
    [indicator removeFromSuperview];
    self.imgPlay.hidden = NO;
    
    if (_shouldPerformColorTherapy)
    {
        self.lblLevel.text = @"TOUS";
    }
    else
    {
        // Setting level text
        self.lblLevel.text = [NSString stringWithFormat:@"%i",[AppData sharedInstance].currentLevel];
    }
    
    // Changing background
    [self.imgBg setYPosition:-(10-[AppData sharedInstance].currentLevel) * self.view.frame.size.height];
    
    
    // Exercise finished
    if (isPlaying && [AppData sharedInstance].currentLevel > 0 )

    {
        // Going back to the first screen
        [AppData sharedInstance].shouldEvaluateTension = YES;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    [self addCardTableView];
}

- (void) setupLabelsAndThumb
{
    // Setting title
    self.lblTitle.text = currentVideo.title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playClicked:(id)sender {
    
    // Adding indicator
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [vwFrame addSubview:indicator];
    indicator.frame = self.imgPlay.frame;
    
    
    self.imgPlay.hidden = YES;
    
    [indicator startAnimating];
    
    [self performSelector:@selector(playVideo:) withObject:@"JZGB" afterDelay:1];
    
    [AnalyticsManager sharedInstance].sendToGoogle =YES;
    [AnalyticsManager sharedInstance].sendToFlurry =YES;
    [AnalyticsManager sharedInstance].flurryParameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",self.currentVideo.title],@"Exercise Name",@"Video",@"Exercise Type", nil];
    
    if (_shouldPerformColorTherapy)
    {
        [[AnalyticsManager sharedInstance] sendEventWithName:@"Exercise Played from menu" Category:@"Exercises" Label:[NSString stringWithFormat:@"%@",self.currentVideo.title]];
    }
    else
    {
        [[AnalyticsManager sharedInstance] sendEventWithName:@"Exercise Played" Category:@"Exercises" Label:[NSString stringWithFormat:@"%@",self.currentVideo.title]];
    }
    
}

- (void) playVideo : (NSString*) movieName
{
    // Saving last exercise done by the user
    [AnalyticsManager sharedInstance].lastExercise =
    [[AppData sharedInstance].currentStorm.exercises objectAtIndex:[AppData sharedInstance].currentStorm.exercises.count - 1];
    
    isPlaying = YES;
    
    [self.navigationController presentMoviePlayerViewControllerAnimated:theMovie];
    
    [theMovie.moviePlayer play];
}

- (BOOL) shouldAutorotate
{
    return NO;
}

#pragma scroll view
- (void) addCardTableView
{
    // Getting exercise list 
    NSArray* list = [[AppData sharedInstance] getExerciseListForLevel:[NSNumber numberWithInteger:[AppData sharedInstance].currentLevel]];
    exList = [[EMGTableView alloc] initTableWithData:list lowerPoint:CGPointMake(28, self.vwFrame.frame.origin.y + self.vwFrame.frame.size.height) upperPoint:CGPointMake(0, self.vwFrame.frame.origin.y+1) andFrame:CGRectMake(0, 0, 265, vwFrame.frame.size.height-2)];
    exList.EMGDelegate = self;
    
    // Reloading rable
    [exList.tblList reloadData];
    
    [self.scrlCardTable addSubview:exList];
    [exList setYPosition:self.scrlCardTable.frame.size.height];
    
    // Setting scroll view
    self.scrlCardTable.scrollEnabled = NO;
    self.scrlCardTable.delegate = self;
    [self.scrlCardTable setContentSize:CGSizeMake(scrlCardTable.frame.size.width, scrlCardTable.frame.size.height * 2)];
}

- (void) EMGTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // [self setAudioFile:[exerciseList objectAtIndex:indexPath.row]];
    
    if ([[exerciseList objectAtIndex:indexPath.row] isKindOfClass:[AudioFile class]])
    {
        [self setAudioFile:[exerciseList objectAtIndex:indexPath.row]];
        self.vwFrame.hidden = YES;
        self.vwAudio.hidden = NO;
    }
    else
    {
        [self setVideo:[exerciseList objectAtIndex:indexPath.row]];
        self.vwFrame.hidden = NO;
        self.vwAudio.hidden = YES;
    }
    // Moving offest
    [self scrollViewGoUp];
}

- (void) scrollViewGoUp
{
    [self.scrlCardTable setContentOffset:CGPointMake(0, 0) animated:YES];

}

- (void) scrollViewGoDown
{
    [self.scrlCardTable setContentOffset:CGPointMake(0, self.scrlCardTable.frame.size.height) animated:YES];

}

# pragma mark AudioView

- (IBAction)audioPlayClicked:(id)sender {
    
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
        
    }
    else
    {
        
        //[self showAnimation];
        
        // [moviePlayer performSelectorInBackground:@selector(play) withObject:Nil];
        
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

- (IBAction)stopClicked:(id)sender {
    
    
    [self stopAudio];
    
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

- (IBAction)showListClicked:(id)sender
{
    // Stoping audio
    [self stopAudio];
    
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
}


@end
