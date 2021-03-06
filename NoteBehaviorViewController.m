//
//  NoteBehaviorViewController.m
//  iCare
//
//  Created by ido zamberg on 3/27/15.
//  Copyright (c) 2015 ido zamberg. All rights reserved.
//

#import "NoteBehaviorViewController.h"

#define OTHER_INDEX 1

@interface NoteBehaviorViewController ()

@end

@implementation NoteBehaviorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Creating array with note bubbles
    self.bubbles = [NSMutableArray arrayWithObjects:
                    [UIImage imageNamed:@"round_bualcool"],
                    [UIImage imageNamed:@"round_autres"],
                    [UIImage imageNamed:@"round_blessé"],
                    [UIImage imageNamed:@"round_horsnormes"],
                    [UIImage imageNamed:@"round_medicements"],
                    [UIImage imageNamed:@"round_prisedetox"],
                    [UIImage imageNamed:@"round_suicide"],
                    [UIImage imageNamed:@"round_pasdcomp.png"],
                    nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
            
    // Delete menu
    self.bubbleMenu = Nil;
    
    // Create menu
    self.bubbleMenu = [[LIVBubbleMenu alloc] initWithPoint:self.btnCenter.center radius:150 menuItems:self.bubbles inView:self.view];
    
    self.bubbleMenu.delegate = self;
    self.bubbleMenu.easyButtons = YES;
    [self.bubbleMenu show];
    
    //self.bubbleMenu.userInteractionEnabled = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)livBubbleMenu:(LIVBubbleMenu *)bubbleMenu tappedBubbleWithIndex:(NSUInteger)index annButton:(UIButton *)button
{
    // Handeling Click
    [super HandleBubbleClickedForBubble:button andIBubbleIndex:index completion:^(BOOL finished){
        
        if (index != OTHER_INDEX)
        {
            // Going to main noting screen
            [self goToMainScreenWithChoice:[self.bubbles objectAtIndex:index]];
        }
        else
        {
            // Showing pop up
            YIPopupTextView* popupTextView = [[YIPopupTextView alloc] initWithPlaceHolder:@"Tapez vos sentiments ici" maxCount:30 buttonStyle:YIPopupTextViewButtonStyleRightDone];
            popupTextView.delegate = self;
            popupTextView.caretShiftGestureEnabled = YES;
            popupTextView.outerBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            
            [popupTextView showInViewController:self.navigationController];
        }
      
    }];
    
}

- (void) livBubbleMenuDidShow:(LIVBubbleMenu *)bubbleMenu
{
    //self.bubbleMenu.userInteractionEnabled = YES;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.bubbleMenu.delegate = Nil;
}

- (void) goToMainScreenWithChoice : (UIImage*) choice
{
    // Getting current chain
    EmotionalChain* currChain = [[AppData sharedInstance] currentChain];
    
    // Adding Selection
    [currChain addNewSelection:choice ToKey:[NSNumber numberWithInteger:1]];
    
    // Posting selection
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BubbleChoosedInChild" object:Nil];
    
    // Going back
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popupTextView:(YIPopupTextView*)textView willDismissWithText:(NSString*)text cancelled:(BOOL)cancelled
{
    // Creating new image view
    CustomRoundView* newRound = (CustomRoundView*)[UIHelper viewFromStoryboard:@"CustomRoundView"];
    newRound.lblCenter.text = text;
    
    [newRound setWidth:132];
    [newRound setHeight:132];
    
    // Creating image from view
    UIImage* finalRoundImage = [UIHelper imageWithView:newRound];
    
    // Go to main noting view
    [self goToMainScreenWithChoice:finalRoundImage];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
