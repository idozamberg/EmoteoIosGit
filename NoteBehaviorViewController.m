//
//  NoteBehaviorViewController.m
//  iCare
//
//  Created by ido zamberg on 3/27/15.
//  Copyright (c) 2015 ido zamberg. All rights reserved.
//

#import "NoteBehaviorViewController.h"

@interface NoteBehaviorViewController ()

@end

@implementation NoteBehaviorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Creating array with note bubbles
    self.bubbles = [NSArray arrayWithObjects:
                    [UIImage imageNamed:@"round_alcol"],
                    [UIImage imageNamed:@"round_autres"],
                    [UIImage imageNamed:@"round_blessé"],
                    [UIImage imageNamed:@"round_horsnormes"],
                    [UIImage imageNamed:@"round_medicements"],
                    [UIImage imageNamed:@"round_prisedetox"],
                    [UIImage imageNamed:@"round_suicide"],
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

@end
