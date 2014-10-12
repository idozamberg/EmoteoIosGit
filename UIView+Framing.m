//
//  UIView+Framing.m
//  365Scores
//
//  Created by Asaf Shveki on 9/10/12.
//  Copyright (c) 2012 for-each. All rights reserved.
//

#import "UIView+Framing.h"
#import <objc/runtime.h>


@implementation UIView (Framing) 
- (void) setSize:(CGSize)size
{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height)];
}

- (void) setPoint:(CGPoint) point
{
    [self setFrame:CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height)];
}

- (void) setYPosition:(NSInteger) y
{
    [self setFrame:CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height)];
}

- (void) setXPosition:(NSInteger) x
{
    [self setFrame:CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
}

- (void) setHeight:(NSInteger) height
{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height)];
}

- (void) setWidth:(NSInteger) width
{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height)];
}


- (void)setPanGesture:(UIPanGestureRecognizer*)panGesture
{
    objc_setAssociatedObject(self, @selector(panGesture), panGesture, OBJC_ASSOCIATION_RETAIN);
}

- (UIPanGestureRecognizer*)panGesture
{
    return objc_getAssociatedObject(self, @selector(panGesture));
}

- (void)handlePan:(UIPanGestureRecognizer*)sender
{
    [self adjustAnchorPointForGestureRecognizer:sender];
    
    CGPoint translation = [sender translationInView:[self superview]];
    [self setCenter:CGPointMake([self center].x, [self center].y + translation.y)];
    
    [sender setTranslation:(CGPoint){0, 0} inView:[self superview]];
}

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = self;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

- (void)setDraggable:(BOOL)draggable
{
    [self.panGesture setEnabled:draggable];
}

- (void)enableDragging
{
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.panGesture setMaximumNumberOfTouches:1];
    [self.panGesture setMinimumNumberOfTouches:1];
    [self.panGesture setCancelsTouchesInView:NO];
    [self addGestureRecognizer:self.panGesture];
}


- (void) enableTouch
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self addGestureRecognizer:tapGestureRecognizer];
}

-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    // do something, like dismiss your view controller, picker, etc., etc.
    
}
@end
