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



@interface LevelViewController ()
{
    UIActivityIndicatorView* indicator;
    MPMoviePlayerViewController *theMovie;
    BOOL isPlaying;
}

@end

@implementation LevelViewController

@synthesize currentVideo;
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
}

- (IBAction)chooseClicked:(id)sender {

    if (_shouldPerformColorTherapy)
    {
        [[FlowManager sharedInstance] showExerciseListWithList:[[AppData sharedInstance] getAllVideos] forLevel:Nil andType:videoType WithColorTherapy:YES];
    }
    else
    {
        // Getting list
        NSArray* list = [[AppData sharedInstance] getExerciseListForLevel:[NSNumber numberWithInteger:[AppData sharedInstance].currentLevel]];
        
        // Show exercise list
        [[FlowManager sharedInstance] showExerciseListWithList:list forLevel:[NSNumber numberWithInteger:[AppData sharedInstance].currentLevel] andType:mixedType];
    }
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
    
    // Setting title
    self.lblTitle.text = currentVideo.title;
    
    // Exercise finished
    if (isPlaying && [AppData sharedInstance].currentLevel > 0 )

    {
        // Going back to the first screen
        [AppData sharedInstance].shouldEvaluateTension = YES;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playClicked:(id)sender {
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.frame = self.imgPlay.frame;
    
    [self.view addSubview:indicator];
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
@end
