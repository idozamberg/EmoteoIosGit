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
-(void)livBubbleMenu:(LIVBubbleMenu *)bubbleMenu tappedBubbleWithIndex:(NSUInteger)index
{
    
    //[[FlowManager sharedInstance] showNoteBehaviorVC];
    
}

// On bubbles hide
-(void)livBubbleMenuDidHide:(LIVBubbleMenu *)bubbleMenu;
{
    
}

@end
