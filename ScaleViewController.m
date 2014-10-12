//
//  ScaleViewController.m
//  iCare
//
//  Created by ido zamberg on 08/12/13.
//  Copyright (c) 2013 ido zamberg. All rights reserved.
//

#import "ScaleViewController.h"
#import "UIView+Framing.h"
#import "ScaleAnimation.h"
#import "ATCAnimatedTransitioningFade.h"

#define DEFAULT_X   

@interface ScaleViewController ()
{
    NSMutableArray* levelLabelsArray;
    BOOL firstLoad;
    BOOL tensionLowered;
    ScaleAnimation *_scaleAnimationController;
    MPMoviePlayerViewController *theMovie;

}
@end

@implementation ScaleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) showSplash
{
 
    NSString* splashVideoName = @"splash4";
    
    // If it is iphone 5 change splash name
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (screenSize.height == 568)
    {
        splashVideoName = @"splashVideo";
    }
    
    // Setting video
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:splashVideoName ofType:@"mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    theMovie = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
    theMovie.view.frame = [[UIScreen mainScreen] applicationFrame];
    theMovie.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    theMovie.moviePlayer.controlStyle =  MPMovieControlStyleNone;
    
    [theMovie.moviePlayer play];
    
   // [self.navigationController presentViewController:theMovie animated:NO completion:Nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackStateChanged)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [self.navigationController pushViewController:theMovie animated:NO];
}


- (void) playbackStateChanged {

            [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:Nil];
    
}

- (void)viewDidLoad
{
    levelLabelsArray = [NSMutableArray new];
    
    [super viewDidLoad];
    
    // Showing splash video
    [self showSplash];
    
    // Do any additional setup after loading the view from its nib.
   /* [self.svScales setHeight:self.view.bounds.size.height];
    [self.svScales setWidth:self.view.bounds.size.width];
    [self.svScales setXPosition:0];
    [self.svScales setYPosition:0];*/
    
    // Setting initial settings
    firstLoad = YES;
    self.lblLevelNumber.hidden = YES;
    isButtonFlashing = NO;
    
    self.imgUp.alpha = 0;
    self.imgDown.alpha = 0;
    self.imgArrowDown.alpha = 0.0;
    self.imgArrowUp.alpha = 0.0;
    tensionLowered = NO;
    
    // Listening to orientation changes
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    // Activiting scrolling properties
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    [self setEdgesForExtendedLayout:UIRectEdgeAll];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
     _scaleAnimationController = [[ScaleAnimation alloc] initWithNavigationController:self.navigationController];
    
    self.navigationController.delegate = self;
    
    // Listening to background changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleGoTOBakcground) name:UIApplicationWillResignActiveNotification object:Nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

}

- (void) handleGoTOBakcground
{
    [AppData sharedInstance].shouldEvaluateTension = NO;
    
    [self.svScales setContentOffset:CGPointMake(0, 9 * self.svScales.frame.size.height) animated:NO];
}

- (void) arrangeScroleView
{
    // Setting up scroll view
    [self.ivScales setHeight:self.svScales.frame.size.height * 10];
    self.svScales.contentSize = CGSizeMake(self.view.frame.size.width, self.svScales.frame.size.height * 10);
    self.svScales.contentOffset = CGPointMake(0, 9 * self.svScales.frame.size.height);
    self.svScales.delegate = self;
    self.svScales.scrollEnabled = YES;
    
    _scaleAnimationController.viewForInteraction = Nil;
    
    // Creating objects
    [self createAndPlaceButtons];
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    if ([AppData sharedInstance].shouldEvaluateTension)
    {
        // Going to level 1
        [self revaluteLevel];
        
    }
    else
    {
        // Going to first level
        [self returnToFirstLevel];
    }
    
    self.imgbigDown.alpha = 0.0;
    self.imgBigUp.alpha = 0.0;
    
    // Show Tutorial if needed
    [[TutorialManager sharedInstance] showTutorial];
    
    // Arranging scrole view
    [self arrangeScroleView];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    // Arranging scrole view
    [self arrangeScroleView];
    

}


- (void) viewDidDisappear:(BOOL)animated{
    [self returnToFirstLevel];
    // Arranging scrole view
    [self arrangeScroleView];
}

- (void) revaluteLevel
{
    NSString* text = @"Vous avez terminé un exercice, nous allons maintenant vous demander d'évaluer à nouveau votre tension";
    
    [self showInfoViewWithTitle:@"ATTENTION" andText:[text uppercaseString]];

    [self returnToFirstLevel];
}

- (void) returnToFirstLevel
{
    // Show first level
  //  self.svScales.contentOffset = CGPointMake(0, 9 * self.svScales.frame.size.height + 20);
    
    [self.svScales setContentOffset:CGPointMake(0, 9 * self.svScales.frame.size.height + 20) animated:NO];

}

- (void) createAndPlaceButtons
{
    
    //[self.btnEmergency setXPosition:self.view.frame.size.width / 2 - self.btnEmergency.frame.size.width / 2 - 40];
    
   // [self.btnMenu setXPosition:self.view.frame.size.width / 2  - self.btnMenu.frame.size.width / 2 + 40];
    
    long buttonCounter = 0;
    
    // Placing the buttons
    for (buttonCounter = 1;buttonCounter <= 10; buttonCounter++)
    {
        
        UIButton* newLevelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UILabel*  newLevelLable = [UILabel new];
        
        // Setting label color
        newLevelLable.text = [NSString stringWithFormat:@"%li",buttonCounter];
        [newLevelLable setTextColor:[UIColor whiteColor]];
        [newLevelLable setFont:[UIFont fontWithName:@"ITC Avant Garde Gothic" size:80]];
        [newLevelLable setTextAlignment:NSTextAlignmentCenter];
        
        // Setting tag for future use
        newLevelButton.tag = buttonCounter;
        
        // Setting images
        [newLevelButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%li_off",buttonCounter]] forState:UIControlStateNormal];
        [newLevelButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%li_on",buttonCounter]] forState:UIControlStateHighlighted];

        // Setting width and height
        [newLevelButton setWidth:131];
        [newLevelButton setHeight:131];
        
        // Setting width and height
        [newLevelLable setWidth:131];
        [newLevelLable setHeight:131];
        
       // [newLevelLable sizeToFit];
        
        // Placing buttons
        [newLevelButton setXPosition:self.view.frame.size.width / 2 - newLevelButton.frame.size.width / 2];
        [newLevelButton setYPosition:(self.view.frame.size.height * (10-buttonCounter)) + (self.view.frame.size.height / 2 - newLevelButton.frame.size.height / 2)];
        
        // Placing labels
        [newLevelLable setXPosition:self.svScales.frame.size.width / 2 - newLevelLable.frame.size.width / 2];
        [newLevelLable setYPosition:(self.svScales.frame.size.height * (10-buttonCounter)) + (self.svScales.frame.size.height / 2 - newLevelLable.frame.size.height / 2) - 4];
        
        
        // Setting selector
        [newLevelButton addTarget:self action:@selector(levelWasClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [levelLabelsArray addObject:newLevelLable];
        //[levelLabelsArray addObject:newLevelButton];
        
        [self.svScales addSubview:newLevelLable];
       // [self.svScales addSubview:newLevelButton];
    }
    
    // Setting up and down images x&y
    [self.imgDown setXPosition:(self.view.frame.size.width / 2 - self.imgDown.frame.size.width / 2)];
    [self.imgUp   setXPosition:(self.view.frame.size.width / 2 - self.imgUp.frame.size.width / 2)];
    
    // Setting up and down images
    [self.imgDown setYPosition:(self.view.frame.size.height / 2 + (131 / 2)) + 50];
    [self.imgUp   setYPosition:(self.view.frame.size.height / 2 - (131 / 2)) - 100];
    
    [self.imgArrowDown setXPosition:self.imgDown.frame.origin.x - 30];
    [self.imgArrowUp setXPosition:self.imgUp.frame.origin.x - 30];
    
    [self.imgArrowDown setYPosition:self.imgDown.center.y - 10];
    [self.imgArrowUp setYPosition:self.imgUp.frame.origin.y + 10];
    
    [self.btnLevel setYPosition:(self.view.frame.size.height / 2 - self.btnLevel.frame.size.height / 2)];
    
    
   // [self.btnLevel addTarget:self action:@selector(levelWasClicked:) forControlEvents:UIControlEventTouchUpInside];

}

- (void) showInfoViewWithTitle :(NSString*) title andText : (NSString*) text
{
    if (info)
    {
        [info removeFromSuperview];
    }
    
    // Creating info view
    info = [[[NSBundle mainBundle] loadNibNamed:@"MessageView" owner:self options:nil] objectAtIndex:0];
    
    // Setting text and title
    info.lblText.text = text;
    info.lblTitle.text = title;
    [info.lblText setFont:[UIFont fontWithName:@"ITC Avant Garde Gothic MM" size:14]];
    
    info.alpha = 0;
    [info setYPosition:100];
    
    // Adding view
    [self.view addSubview:info];
    
    // Animating the view appearance
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    [info setYPosition:20];
    info.alpha = 1;
    
    [UIView commitAnimations];
}

- (NSInteger) getCurrentLevel
{
    NSInteger level = self.svScales.contentOffset.y / self.view.frame.size.height;
    
    return (10-level);
}
    
/* TODO: DELETE
- (void) levelWasClicked: (UIButton*) sender
{
    // If it's the second time we click
    if (isButtonFlashing)
    {
        // On the same tension level?
        if ([self getCurrentLevel] == currentButtonClicked)
        {
            // Cancel timer
            [self resetFlashingButton:sender];
            
            if ([self getCurrentLevel] == 8)
            {
                // Go to next screen
                LevelViewController* vcLevel = [self.storyboard instantiateViewControllerWithIdentifier:@"levelVC"];
                
                
                [self.navigationController pushViewController:vcLevel animated:YES];
            }
            else if ([self getCurrentLevel] == 7)
            {
                // Go to next screen
                LevelViewController* vcLevel = [self.storyboard instantiateViewControllerWithIdentifier:@"audioVC"];
                
                [self.navigationController pushViewController:vcLevel animated:YES];
            }
            
            [info removeFromSuperview];
        }
        
        currentButtonClicked = [self getCurrentLevel];
    }
    else
    {
        // Saving current button clicked
        currentButtonClicked = [self getCurrentLevel];
        
        NSString* text = [NSString stringWithFormat:@"VOUS ÉVALUEZ VOTRE TENSION À %li, SI VOUS CONFIRMEZ EN APPUYANT À NOUVEAU, NOUS ALLONS ESSAYER DE BAISSER CETTE TENSION AVEC VOUS !",(long)currentButtonClicked];
        
        // Reset for flashing reasons
        buttonOn = NO;
        
        // Show info view
        [self showInfoViewWithTitle:@"ATTENTION" andText:text];
        
        // If not already flashing
        if (!timerFlash)
        {
            // Creating parameters dictionary
            NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:sender forKey:@"button"];
            
            // Creating flash
            timerFlash = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(buttonFlash:) userInfo:params repeats:YES];
            
            isButtonFlashing = YES;
        }
    }
    
    currentPressedButton = sender;
}*/

- (void)orientationChanged:(NSNotification *)notification {
    // Respond to changes in device orientation
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)emergencyClicked:(id)sender {
    
    [[FlowManager sharedInstance] showEmergencyVC];
}


- (void) buttonFlash : (NSTimer *)timer
{
    NSDictionary* dict = [timer userInfo];
    
    if (buttonOn)
    {
       // [sender setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%li_off",sender.tag]] forState:UIControlStateNormal];
        [self.btnLevel setImage:[UIImage imageNamed:@"round_off.png"] forState:UIControlStateNormal];
        buttonOn = NO;
    }
    else
    {
        [self.btnLevel setImage:[UIImage imageNamed:@"round_blink.png"] forState:UIControlStateNormal];
        buttonOn = YES;
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL) shouldAutorotate
{
    return NO;
}

-(NSUInteger) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
  if (![AppData sharedInstance].shouldEvaluateTension)
  {
    // Animating the view appearance
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    info.alpha = 0;
    [info setXPosition:-100];
    long level = [self getCurrentLevel];
    self.lblLevelNumber.text = [NSString stringWithFormat:@"%li",level];
    //self.lblLevelNumber.alpha = 1.0;
    
    [UIView commitAnimations];
        
    // Reseting button
    [self resetFlashingButton:currentPressedButton];
      
    //long level = [self getCurrentLevel];
    //self.lblLevelNumber.text = [NSString stringWithFormat:@"%li",level];


  }

    
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [AppData sharedInstance].shouldEvaluateTension = NO;
    
    long level = [self getCurrentLevel];

    
    self.imgDown.image = [UIImage imageNamed:[NSString stringWithFormat:@"%li_off",level-1]];
    self.imgUp.image = [UIImage imageNamed:[NSString stringWithFormat:@"%li_off",level + 1]];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    self.imgDown.alpha = 0.0;
    self.imgUp.alpha = 0.0;
    self.imgbigDown.alpha = 0.0;
    self.imgBigUp.alpha = 0.0;
    self.lblLevelNumber.alpha = 0.0;
    
    if (level!=1)
    {
        self.imgArrowDown.alpha = 0.0;
    }
    
    if (level != 10)
    {
        self.imgArrowUp.alpha = 0.0;
    }
    
    [UIView commitAnimations];

}

- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{

   // self.lblLevelNumber.text = @"";
    
    // Animating the view appearance
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    self.imgDown.alpha = 0.0;
    self.imgUp.alpha = 0.0;
    self.imgArrowDown.alpha = 0.0;
    self.imgArrowUp.alpha = 0.0;
    self.imgbigDown.alpha = 0.0;
    self.imgBigUp.alpha = 0.0;
    self.lblLevelNumber.alpha = 0.0;
    
    
    [UIView commitAnimations];
}


- (void) resetFlashingButton : (UIButton*) button
{
    // Reseting button
    [timerFlash invalidate];
    timerFlash = Nil;
    isButtonFlashing = NO;
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%li_off",button.tag]] forState:UIControlStateNormal];

}


//We need to detect when a user starts and ends a shake. add the motionEnded:withEvent method
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        NSInteger shakeLevel = [[AppData sharedInstance].shakeLevel integerValue];
        
        // Moving to selected level
        [self.svScales setContentOffset:CGPointMake(0, (10 - shakeLevel) * self.svScales.frame.size.height) animated:YES];
    }
}
//When a gesture is detected (and ended) the showAlert method is called.

- (IBAction)levelClicked:(id)sender {
    
    // If it's the second time we click
    if (isButtonFlashing)
    {
        // On the same tension level?
        if ([self getCurrentLevel] == currentButtonClicked)
        {
            // Cancel timer
            [self resetFlashingButton:sender];
            
            
            // Save current level chosed
            [AppData sharedInstance].currentLevel = [self getCurrentLevel];
            
            if (![AppData sharedInstance].isInStorm)
            {
                // Adding new storm
                [[AppData sharedInstance] addNewStorm];
                
                [AppData sharedInstance].isInStorm = YES;
            }
            
            // If video level
            if ([self getCurrentLevel] > 6)
            {

                // Getting all exercises
                NSMutableArray* exercises = [[AppData sharedInstance].videos objectForKey:[NSNumber numberWithInt:[self getCurrentLevel]]];
                
                // Getting a random number
                NSInteger exerciseIndex = [UIHelper getRandomNumbergWithMaxNumber:exercises.count - 1];
                
                // getting the videio
                VideoFile* theVideo = [exercises objectAtIndex:exerciseIndex];
                
                // Showing video screen
                [[FlowManager sharedInstance] showVideoViewControllerWithVideo:theVideo];
                
            }
            // Consciense level
            else if ([self getCurrentLevel] <= 6)
            {
                NSMutableArray* audios = [[AppData sharedInstance].audioFiles objectForKey:[NSNumber numberWithInt:[self getCurrentLevel]]];
                
                NSInteger exerciseIndex = [UIHelper getRandomNumbergWithMaxNumber:audios.count - 1];
                
                AudioFile* file = [audios objectAtIndex:exerciseIndex];
                
                [[FlowManager sharedInstance] showAudioViewControllerWithAudioFile:file];
            }
            
            // Collection States
            [AnalyticsManager sharedInstance].sendToGoogle =YES;
            [AnalyticsManager sharedInstance].sendToFlurry =YES;
            [AnalyticsManager sharedInstance].flurryParameters = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%i",[self getCurrentLevel]] forKey:@"Tension Level"];
            [[AnalyticsManager sharedInstance] sendEventWithName:@"Tension Button Clicked" Category:@"Exercises" Label:[NSString stringWithFormat:@"%i",[self getCurrentLevel]]];
            
            [info removeFromSuperview];
            
            // Add tension level to storm
            [[AppData sharedInstance].currentStorm addTension:[NSNumber numberWithInteger:[self getCurrentLevel]]];
        }
        
        currentButtonClicked = [self getCurrentLevel];
    }
    else
    {
        // Saving current button clicked
        currentButtonClicked = [self getCurrentLevel];
        
        Exercise* lastExercisesPlayed = [AnalyticsManager sharedInstance].lastExercise;
        
        // If tension was lowered because of the last exercise send info about it 
        if (lastExercisesPlayed &&
            [AppData sharedInstance].currentLevel > [self getCurrentLevel])
        {
            // Send statistics about how much the tensio was lowered
            [AnalyticsManager sharedInstance].sendToFlurry = YES;
           /* [AnalyticsManager sharedInstance].flurryParameters = [NSDictionary dictionaryWithObjectsAndKeys:lastExercisesPlayed.name,@"Exercise Name",[NSString stringWithFormat:@"%i",[AppData sharedInstance].currentLevel],lastExercisesPlayed.name,[NSString stringWithFormat:@"%i",[self getCurrentLevel]],@"Tension After",[NSString stringWithFormat:@"%i",[AppData sharedInstance].currentLevel - [self getCurrentLevel]],@"Total tension change",nil];*/
            
            [AnalyticsManager sharedInstance].flurryParameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%i",[AppData sharedInstance].currentLevel - [self getCurrentLevel]],lastExercisesPlayed.name,Nil];
         
            [[AnalyticsManager sharedInstance] sendEventWithName:@"Tension Change after exercise" Category:@"Tension" Label:Nil];
        }
        
        
        // Check if tension was lowered
        if ([self getCurrentLevel] <= 6)
        {
            if ([AppData sharedInstance].currentLevel > [self getCurrentLevel])
            {
                // Mark that tension was lowered
                tensionLowered = YES;
                [AppData sharedInstance].currentLevel = 0;
            }
        }
        
        NSString* text;
        // Set text by level
        if ([self getCurrentLevel] <= 6 )
        {
            if (tensionLowered)
            {
                text = @"Votre tension a baissé, vous pouvez continuer vos activités ou vous entraîner à la pratique de pleine conscience";
                tensionLowered = NO;
            }
            else
            {
                text = [NSString stringWithFormat:@"Vous évaluez votre tension à %li, si vous confirmez, nous allons vous proposer un exercice de pleine conscience !",(long)currentButtonClicked];
            }
        }
        else
        {
            if ([AppData sharedInstance].currentStorm.exercises.count > 0)
            {
                text = [NSString stringWithFormat:@"Vous évaluez votre tension à %li, si vous confirmez, nous allons continuer à essayer de baisser cette tension avec vous !",(long)currentButtonClicked];
            }
            else
            {
                text = [NSString stringWithFormat:@"Vous évaluez votre tension à %li, si vous confirmez, nous allons essayer de baisser cette tension avec vous !",(long)currentButtonClicked];
            }
        }
        
        text = [text uppercaseString];
        
        // Reset for flashing reasons
        buttonOn = NO;
        
        // Show info view
        [self showInfoViewWithTitle:@"ATTENTION" andText:text];
        
        // If not already flashing
        if (!timerFlash)
        {
            // Creating parameters dictionary
            NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:sender forKey:@"button"];
            
            // Creating flash
            timerFlash = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(buttonFlash:) userInfo:params repeats:YES];
            
            isButtonFlashing = YES;
        }
    }
    
    currentPressedButton = sender;
}

- (IBAction)menuClicked:(id)sender {
    
    // Showing menu
    [[FlowManager sharedInstance] showMenuVCWithType:menuTablePrincipal];
}


-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    self.animator = nil;
    
    self.animator = [ATCAnimatedTransitioningFade new];
  
    if (self.animator) {
        
        [self setupAnimatorForOperation:operation];
    }
    
    return self.animator;
}

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if ([animationController isKindOfClass:[ATCAnimatedTransitioning class]]) {
        ATCAnimatedTransitioningFade *controller = (ATCAnimatedTransitioningFade *)animationController;
        
        
        if (controller.isInteracting) return controller;
        else return nil;
    } else return nil;
}

- (void)setupAnimatorForOperation:(UINavigationControllerOperation)operation
{
     if ([self.animator isKindOfClass:[ATCAnimatedTransitioning class]]) {
        
        [self.animator setIsPush:YES];
        [self.animator setDuration:1.0];
        [self.animator setDismissal:(operation == UINavigationControllerOperationPop)];
        
        if (operation == UINavigationControllerOperationPush) {
            
            [(ATCAnimatedTransitioning *)self.animator setDirection:ATCTransitionAnimationDirectionRight];
        }
        else {
            [(ATCAnimatedTransitioning *)self.animator setDirection:ATCTransitionAnimationDirectionLeft];
        }
    }
    
}

@end
