//
//  NoteViewController.m
//  iCare
//
//  Created by ido zamberg on 3/27/15.
//  Copyright (c) 2015 ido zamberg. All rights reserved.
//

#import "CirclesViewController.h"
#import "FlowManager.h"

@interface CirclesViewController ()

@end

@implementation CirclesViewController

@synthesize bubbles,btnCenter,lblCenter,clickedCircleImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Changing background
    [self.imgBg setYPosition:-(10-[AppData sharedInstance].currentLevel) * self.view.frame.size.height];
}

- (void) viewWillAppear:(BOOL)animated
{
    // Changing background
   // [self.imgBg setYPosition:-(10-[AppData sharedInstance].currentLevel) * self.view.frame.size.height];
    
    if (self.clickedCircleImage)
    {
        [self.clickedCircleImage removeFromSuperview];
    }
    
    self.btnCenter.alpha = 1;
    self.lblCenter.alpha = 1;

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

- (IBAction)centerClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) HandleBubbleClickedForBubble : (UIButton*) button andIBubbleIndex : (NSInteger) index completion:(void (^)(BOOL finished))completion
{
    // Saving clicked image
    self.clickedCircleImage =  [[UIImageView alloc] initWithImage:[self.bubbles objectAtIndex:index]];
    self.clickedCircleImage.frame = button.frame;
    [self.view addSubview:self.clickedCircleImage];
    
    
    CGPoint subViewPoint = button.frame.origin;
    CGPoint newPointSuperView = [self.view convertPoint:subViewPoint fromView:self.bubbleMenu];
    
    [self.clickedCircleImage setXPosition:newPointSuperView.x];
    [self.clickedCircleImage setYPosition:newPointSuperView.y];
    
   // [self.clickedCircleImage setYPosition:self.btnCenter.frame.origin.y];
    
    // Animating
    [UIView animateWithDuration:1 animations:^{
        
        self.clickedCircleImage.frame = self.btnCenter.frame;
        self.btnCenter.alpha = 0;
        self.lblCenter.alpha = 0;

    }
    completion:^(BOOL finished){
        completion(YES);
                     }];
    
    [UIView commitAnimations];
    
}
@end
