//
//  NoteViewController.m
//  iCare
//
//  Created by ido zamberg on 3/27/15.
//  Copyright (c) 2015 ido zamberg. All rights reserved.
//

#import "NoteViewController.h"
#import "FlowManager.h"

@interface NoteViewController ()

@end

#define INDEX_COMPORTEMENTS 1
#define INDEX_COTER 0
#define INDEX_SENTIMENTS 2


@implementation NoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Creating array with note bubbles
    self.bubbles = [NSArray arrayWithObjects:
                    [UIImage imageNamed:@"round_coter"],
                    [UIImage imageNamed:@"round_notercomp"],
                    [UIImage imageNamed:@"round_sentiments"],
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
-(void)livBubbleMenu:(LIVBubbleMenu *)bubbleMenu tappedBubbleWithIndex:(NSUInteger)index annButton:(UIButton *)button
{
    
    // Handeling clicking animation
    [super HandleBubbleClickedForBubble:button andIBubbleIndex:index completion:^(BOOL finished){
        
        if (index == INDEX_COMPORTEMENTS)
        {
            [[FlowManager sharedInstance] showNoteBehaviorVC];
        }
        else if (index == INDEX_COTER)
        {
            [[FlowManager sharedInstance] showEstimateViewController];
            
        }
        else
        {
            [[FlowManager sharedInstance] showFeelingsViewController];
        }

    }];
}

// On bubbles hide
-(void)livBubbleMenuDidHide:(LIVBubbleMenu *)bubbleMenu;
{
    
}

@end
