//
//  EMGTableView.m
//  iCare
//
//  Created by ido zamberg on 10/5/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import "EMGTableView.h"
#import "MediaFile.h"
#import "Exercise.h"
#import "ExerciseCell.h"
#import "UIView+Framing.h"
#import "AppData.h"

@implementation EMGTableView
{
    BOOL isResizingLR;
    BOOL isResizingUL;
    BOOL isResizingUR;
    BOOL isResizingLL;
    CGPoint touchStart;
    UIImageView* imgBg ;
    
}
@synthesize tblList,lowerAncorPoint,upperAncorPoint;

CGFloat kResizeThumbSize=45.0;
CGFloat minHeight = 29.0;
CGFloat maxHeight;

- (id) initTableWithData : (NSArray*) data lowerPoint :(CGPoint) lowerAncor upperPoint :(CGPoint) upperPoint andFrame : (CGRect) frame
{
    self = [super init];
    
    if (self)
    {
        // Setting frame
        maxHeight = frame.size.height;
        self.lowerAncorPoint = lowerAncor;
        self.upperAncorPoint = upperPoint;
        self.frame = frame;
        //[self setYPosition:lowerAncor.y];
        //[self setXPosition:lowerAncor.x];
        //[self setHeight:minHeight];
        
        // Setting table view
        tblList = [[UITableView alloc] initWithFrame:frame];
        [tblList setXPosition:0];
        [tblList setYPosition:0];
        dataSourceArray = data;
        tblList.dataSource = self;
        tblList.delegate = self;
       // [tblList setHeight:minHeight];
        
        // Setting properties
        self.backgroundColor = [UIColor clearColor];
        tblList.backgroundColor = [UIColor clearColor];
        tblList.separatorStyle  = UITableViewCellSeparatorStyleNone;
        tblList.bounces = NO;
        
        //[self enableDragging];
        //[self setDraggable:YES];
        
        /*
        // Adding background
        UIImage* bg = [UIImage imageNamed:@"s1.png"];
        imgBg = [[UIImageView alloc] initWithFrame:tblList.frame];
        
        // Cropping image
        CGImageRef imageRef = CGImageCreateWithImageInRect([bg CGImage], CGRectMake(28, 36, frame.size.width * 2, frame.size.height*2));
        [imgBg setImage:[UIImage imageWithCGImage:imageRef]];
        CGImageRelease(imageRef);
    
        [self addSubview:imgBg];
         */
        
        [self addSubview:tblList];
        [self sendSubviewToBack:imgBg];
        
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* EXERCISE_CELL = @"ExerciseCell";
    
    // Getting current media file
    MediaFile* currentFile = [dataSourceArray objectAtIndex:indexPath.row];
    
    ExerciseCell* cell = [tableView dequeueReusableCellWithIdentifier:EXERCISE_CELL];
    
    // Checking if we are reusing
    if (cell == Nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ExerciseCell" owner:self options:nil] objectAtIndex:0];
    }
    
    cell.lblName.text = currentFile.title;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([self.EMGDelegate respondsToSelector:@selector(EMGTableView:didSelectRowAtIndexPath:)])
    {
        [self.EMGDelegate EMGTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 29;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 29;
}
// Section header & footer information. Views are preferred over title should you decide to provide both

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    EMGTableHeader* header = [[[NSBundle mainBundle] loadNibNamed:@"EMGTableHeader" owner:self options:nil] objectAtIndex:0];
                      
    header.lblTitle.text = @"AUTRES EXERCICES";
    
    return header;
}


- (void) moveViewToTop
{
    [UIView animateWithDuration:0.5 animations:^{
        
        [self setYPosition:upperAncorPoint.y];
        [self setHeight:maxHeight];
        [tblList setHeight:maxHeight];
        [imgBg setHeight:maxHeight];
        self.alpha = 1.0;
    }];
    
    [UIView commitAnimations];
    
}


- (void) moveViewToBottom
{
    [UIView animateWithDuration:0.5 animations:^{
        
        [self setHeight:minHeight];
        [tblList setHeight:minHeight];
        [imgBg setHeight:minHeight];
        [self setYPosition:lowerAncorPoint.y];
        self.alpha = 0.0;
    }];
    
    [UIView commitAnimations];

}





- (void) setTableDataSource : (NSArray*) data
{
    dataSourceArray = data;
    
    [tblList reloadData];
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    touchStart = [[touches anyObject] locationInView:self];
    isResizingLR = (self.bounds.size.width - touchStart.x < kResizeThumbSize && self.bounds.size.height - touchStart.y < kResizeThumbSize);
    isResizingUL = (touchStart.x <kResizeThumbSize && touchStart.y <kResizeThumbSize);
    isResizingUR = (self.bounds.size.width-touchStart.x < kResizeThumbSize && touchStart.y<kResizeThumbSize);
    isResizingLL = (touchStart.x <kResizeThumbSize && self.bounds.size.height -touchStart.y <kResizeThumbSize);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    CGPoint previous = [[touches anyObject] previousLocationInView:self];
    
    CGFloat deltaWidth = touchPoint.x - previous.x;
    CGFloat deltaHeight = touchPoint.y - previous.y;
    
    // get the frame values so we can calculate changes below
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    if (isResizingLR) {
        self.frame = CGRectMake(x, y, touchPoint.x+deltaWidth, touchPoint.y+deltaWidth);
    } else if (isResizingUL) {
        self.frame = CGRectMake(x+deltaWidth, y+deltaHeight, width-deltaWidth, height-deltaHeight);
    } else if (isResizingUR) {
        self.frame = CGRectMake(x, y+deltaHeight, width+deltaWidth, height-deltaHeight);
    } else if (isResizingLL) {
        self.frame = CGRectMake(x+deltaWidth, y, width-deltaWidth, height+deltaHeight);
    } else {
        // not dragging from a corner -- move the view
        self.center = CGPointMake(self.center.x + touchPoint.x - touchStart.x,
                                  self.center.y + touchPoint.y - touchStart.y);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
