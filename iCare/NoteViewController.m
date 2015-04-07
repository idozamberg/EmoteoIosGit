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
{
    NSInteger currentButtonIndex;
    BOOL      didReturnFromChild;
    UIImage*  currentNumberImage;
    CGPoint   currentButtonCenter;
    NSMutableArray* numbersImagesViews;
    NSInteger numberOfExercisesDone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Creating array with note bubbles
    self.bubbles = [NSMutableArray arrayWithObjects:
                    [UIImage imageNamed:@"round_coter"],
                    [UIImage imageNamed:@"round_notercomp"],
                    [UIImage imageNamed:@"round_sentiments"],
                    nil];
    
    // Reset variables
    currentButtonIndex = 0;
    didReturnFromChild = NO;
    numberOfExercisesDone = 0;
    
    // Listening to notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BubbleWasChoosedInChild) name:@"BubbleChoosedInChild" object:Nil];
    
    // Listening to notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BubbleWasChoosedInChildWithNumber) name:@"BubbleChoosedInChildWithNumber" object:Nil];
    
    // Adding and emotional chain object
    [[AppData sharedInstance] addNewEmotionalChain];
    
    numbersImagesViews = [NSMutableArray new];
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

    if (didReturnFromChild)
    {
        numberOfExercisesDone = numberOfExercisesDone + 1;
        
        // Getting bubble button
        UIButton* currBubble = [self.bubbleMenu.bubbleButtons objectAtIndex:currentButtonIndex];
        
        // Disabling it
        currBubble.enabled = NO;
        
        // Changing bg image
        [currBubble setBackgroundImage:[self.bubbles objectAtIndex:currentButtonIndex] forState:UIControlStateDisabled];
        
        self.lblText.text = @"Poursuivez l’exercice";
        
    }
    
    // When all 3 exercises are done
    if (numberOfExercisesDone == 3)
    {
        self.lblText.text = @"Vous avez terminé l’observation des émotions, des sentiments et des comportements. \n En appuyant sur le rond central, vous validez l’enregistrement de cette observation dans le journal.";
        
        self.btnCenter.enabled = YES;
        [self.view bringSubviewToFront:self.btnCenter];
        [self.view bringSubviewToFront:self.lblCenter];
        self.lblCenter.text = @"Enregistrer";
    
    }
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
    // Setting current button index
    currentButtonIndex = index;
    currentButtonCenter = button.center;
    
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

- (void) BubbleWasChoosedInChild
{
    
    // Getting current chain
    EmotionalChain* currChain = [[AppData sharedInstance] currentChain];
    
    // Getting Image by index
    NSMutableArray* elements = [currChain.chainElements objectForKey:[NSNumber numberWithInteger:currentButtonIndex]];
    
    UIImage* image = [elements objectAtIndex:0];
    
    [self.bubbles replaceObjectAtIndex:currentButtonIndex withObject:image];
    
    didReturnFromChild = YES;
    
    // Setting image
 //   [currBubble setImage:image forState:UIControlStateDisabled];
    
}

- (void) handleNumberedEnteties
{
    if (currentButtonIndex !=1)
    {
        // Getting bubble button
        UIButton* currBubble = [self.bubbleMenu.bubbleButtons objectAtIndex:currentButtonIndex];
        
        // Creating number image
        UIImageView* newNumberImageView = [[UIImageView alloc] initWithImage:currentNumberImage];
        newNumberImageView.frame = self.btnCenter.frame;
        newNumberImageView.alpha = 0;
        
        [newNumberImageView setWidth:50];
        [newNumberImageView setHeight:50];
        
        // Set new origin
        NSInteger newOriginPoint;
        if (currentButtonIndex == 0)
        {
            newOriginPoint = self.btnCenter.frame.origin.x + self.btnCenter.frame.size.width + 18;
            [newNumberImageView setXPosition:newOriginPoint];
            [newNumberImageView setYPosition:newNumberImageView.frame.origin.y + self.btnCenter.frame.size.height - 34];
        }
        else if (currentButtonIndex == 2)
        {
            newOriginPoint = newNumberImageView.frame.origin.x - 54;
            [newNumberImageView setXPosition:newOriginPoint];
            [newNumberImageView setYPosition:newNumberImageView.frame.origin.y - 12];
            
        }

        [self.view addSubview:newNumberImageView];

        
        [UIView animateWithDuration:0.5 animations:^{
            newNumberImageView.alpha = 1;
        }];
        // Adding to view
    }
}

- (void) BubbleWasChoosedInChildWithNumber
{
    // Getting current chain
    EmotionalChain* currChain = [[AppData sharedInstance] currentChain];
    
    // Getting Image by index
    NSMutableArray* elements = [currChain.chainElements objectForKey:[NSNumber numberWithInteger:currentButtonIndex]];
    
    // Getting image and replacing in array
    UIImage* image = [elements objectAtIndex:0];
    currentNumberImage = [elements objectAtIndex:1];
    [self.bubbles replaceObjectAtIndex:currentButtonIndex withObject:image];
    
    didReturnFromChild = YES;

}

-(void)livBubbleMenuDidShow:(LIVBubbleMenu *)bubbleMenu
{
    
    // Adding the level of emotion / feeling
    [self handleNumberedEnteties];
    
}

@end
