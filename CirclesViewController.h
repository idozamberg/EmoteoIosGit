//
//  NoteViewController.h
//  iCare
//
//  Created by ido zamberg on 3/27/15.
//  Copyright (c) 2015 ido zamberg. All rights reserved.
//

#import "ViewController.h"
#import "LIVBubbleMenu.h"
#import "AppData.h"
#import "EmotionalChain.h"



@interface CirclesViewController : ViewController <LIVBubbleButtonDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblText;
@property (weak, nonatomic) IBOutlet UIButton *btnCenter;
@property (weak, nonatomic) IBOutlet UILabel *lblCenter;
@property (weak, nonatomic) IBOutlet UIImageView *imgBg;

@property (nonatomic,strong) NSMutableArray* bubbles;
@property (nonatomic,strong) LIVBubbleMenu* bubbleMenu;
@property (nonatomic,strong) UIImageView* clickedCircleImage;
- (IBAction)centerClicked:(id)sender;

- (void) HandleBubbleClickedForBubble : (UIButton*) button andIBubbleIndex : (NSInteger) index completion:(void (^)(BOOL finished))completion;


@end
