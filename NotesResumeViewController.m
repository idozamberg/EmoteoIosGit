//
//  NotesResumeViewController.m
//  iCare
//
//  Created by ido zamberg on 4/8/15.
//  Copyright (c) 2015 ido zamberg. All rights reserved.
//

#import "NotesResumeViewController.h"

@interface NotesResumeViewController ()

@end

@implementation NotesResumeViewController
{
    NSMutableArray* numbersImages;
}

@synthesize selectedChain;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Creating array with note bubbles
    self.bubbles = [NSMutableArray new];
    numbersImages = [NSMutableArray new];

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // Changing background
    [self.imgBg setYPosition:-(10-[self.selectedChain.tension integerValue]) * self.view.frame.size.height];
    
    // Setting bubbles array
    [self setBubblesImages];
    
    // Setting date
    self.lblCenter.text = [NSString stringWithFormat:@"OBSERVATION DU %@", [DateTimeHelper getDate:self.selectedChain.date withDateFormat:@"dd.MM.yyyy"]];
    
    // Delete menu
    self.bubbleMenu = Nil;
    
    // Create menu
    self.bubbleMenu = [[LIVBubbleMenu alloc] initWithPoint:self.btnCenter.center radius:150 menuItems:self.bubbles inView:self.view];
    self.bubbleMenu.delegate = self;
    self.bubbleMenu.easyButtons = YES;
    [self.bubbleMenu show];
    
}

- (void) setBubblesImages
{
    NSMutableArray* elements = [self.selectedChain.chainElements objectForKey:[NSNumber numberWithInteger:0]];
    
    // Getting image and setting in array for emotions
    UIImage* emotions = [elements objectAtIndex:0];
    [self setNumberImageForRoundWithIndex:0 andImage:[elements objectAtIndex:1]];
    [self.bubbles addObject:emotions];
    
    // Getting image and setting in array for behvior
    elements = [self.selectedChain.chainElements objectForKey:[NSNumber numberWithInteger:1]];
    UIImage* comportement = [elements objectAtIndex:0];
    [self.bubbles addObject:comportement];
    
    // Getting image and setting in array for feelings
    elements = [self.selectedChain.chainElements objectForKey:[NSNumber numberWithInteger:2]];
    UIImage* sentiments = [elements objectAtIndex:0];
    [self setNumberImageForRoundWithIndex:2 andImage:[elements objectAtIndex:1]];
    [self.bubbles addObject:sentiments];
    
}

- (void) setNumberImageForRoundWithIndex : (NSInteger) index andImage : (UIImage*) currentNumberImage
{
    // Creating number image
    UIImageView* newNumberImageView = [[UIImageView alloc] initWithImage:currentNumberImage];
    [numbersImages addObject:newNumberImageView];
    newNumberImageView.frame = self.btnCenter.frame;
    newNumberImageView.alpha = 0;
    
    [newNumberImageView setWidth:50];
    [newNumberImageView setHeight:50];
    
    // Set new origin
    NSInteger newOriginPoint;
    if (index == 0)
    {
        newOriginPoint = self.btnCenter.frame.origin.x + self.btnCenter.frame.size.width + 18;
        [newNumberImageView setXPosition:newOriginPoint];
        [newNumberImageView setYPosition:newNumberImageView.frame.origin.y + self.btnCenter.frame.size.height - 34];
    }
    else if (index == 2)
    {
        newOriginPoint = newNumberImageView.frame.origin.x - 54;
        [newNumberImageView setXPosition:newOriginPoint];
        [newNumberImageView setYPosition:newNumberImageView.frame.origin.y - 12];
        
    }
    
    // Adding to view
    [self.view addSubview:newNumberImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated
{
    self.bubbleMenu.delegate = Nil;
    self.bubbleMenu = Nil;
    
    // Adding number images
    for (UIImageView* imageView in numbersImages)
    {
        [UIView animateWithDuration:1 animations:^{
            imageView.alpha = 0;
            
        }
                         completion:^(BOOL finished){
                             [imageView removeFromSuperview];
                         }];
    }
}

- (void) livBubbleMenuDidShow:(LIVBubbleMenu *)bubbleMenu
{
    NSInteger index = 0;
    
    for (UIButton* button in bubbleMenu.bubbleButtons)
    {
        // Disabling button
        button.enabled = NO;
        
        // Getting button image
        UIImage* buttonImage = [self.bubbles objectAtIndex:index];
        
        // Setting image
        [button setImage:buttonImage forState:UIControlStateDisabled];
        
        index += 1;
    }
    
    // Adding number images
    for (UIImageView* imageView in numbersImages)
    {
        [UIView animateWithDuration:0.5 animations:^{
            imageView.alpha = 1;
            
        }
                         completion:^(BOOL finished){
                         }];
    }
    

}

- (BOOL) shouldAutorotate
{
    return NO;
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
