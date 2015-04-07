//
//  CotationViewController.m
//  iCare
//
//  Created by ido zamberg on 4/3/15.
//  Copyright (c) 2015 ido zamberg. All rights reserved.
//

#import "CotationViewController.h"
#import "FlowManager.h"

@interface CotationViewController ()

@end

@implementation CotationViewController

@synthesize centerImage,mainButtonIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Creating array with note bubbles
    self.bubbles = [NSArray arrayWithObjects:
                    [UIImage imageNamed:@"round1"],
                    [UIImage imageNamed:@"round2"],
                    [UIImage imageNamed:@"round3"],
                    [UIImage imageNamed:@"round4"],
                    [UIImage imageNamed:@"round5"],
                    nil];
    
    self.lblCenter.hidden = YES;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    // Setting center image
    [self.btnCenter setBackgroundImage:self.centerImage forState:UIControlStateNormal];
    [self.btnCenter setBackgroundImage:self.centerImage forState:UIControlStateHighlighted];
    [self.btnCenter setBackgroundImage:self.centerImage forState:UIControlStateSelected];
    
    // Setting text
    self.lblText.text = self.text;

    
    // Delete menu
    self.bubbleMenu = Nil;
    
    // Create menu
    self.bubbleMenu = [[LIVBubbleMenu alloc] initWithPoint:self.btnCenter.center radius:150 menuItems:self.bubbles inView:self.view];
    
    self.bubbleMenu.delegate = self;
    self.bubbleMenu.easyButtons = YES;
    [self.bubbleMenu show];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

// On buttons pressed
-(void)livBubbleMenu:(LIVBubbleMenu *)bubbleMenu tappedBubbleWithIndex:(NSUInteger)index annButton:(UIButton *)button
{
    // Handeling Click
    [super HandleBubbleClickedForBubble:button andIBubbleIndex:index completion:^(BOOL finished){
        
        // Getting current chain
        EmotionalChain* currChain = [[AppData sharedInstance] currentChain];
        
        // Adding Selection
        [currChain addNewSelectionWithKeyImage:self.centerImage numberImage:[self.bubbles objectAtIndex:index] andKey:[NSNumber numberWithInteger:self.mainButtonIndex]];
        
        // Posting
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BubbleChoosedInChildWithNumber" object:Nil];
        
        // Getting view controlles
        UIViewController* notationController = [self.navigationController.viewControllers objectAtIndex:1];
        
        // Going back
        [self.navigationController popToViewController:notationController animated:YES];

    }];
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    self.bubbleMenu.delegate = Nil;
    self.bubbleMenu = Nil;
}

// On bubbles hide
-(void)livBubbleMenuDidHide:(LIVBubbleMenu *)bubbleMenu;
{
    
}

@end
