//
//  UIView+Framing.h
//  365Scores
//
//  Created by Asaf Shveki on 9/10/12.
//  Copyright (c) 2012 for-each. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Framing) <UIGestureRecognizerDelegate>



- (void) setWidth:(NSInteger) width;
- (void) setHeight:(NSInteger) height;
- (void) setXPosition:(NSInteger) x;
- (void) setYPosition:(NSInteger) y;
- (void) setPoint:(CGPoint) point;
- (void) setSize:(CGSize)size;


/**-----------------------------------------------------------------------------
 * @name UIView+draggable Properties
 * -----------------------------------------------------------------------------
 */

/** The pan gestures that handles the view dragging
 *
 * @param panGesture The tint color of the blurred view. Set to nil to reset.
 */
@property (nonatomic) UIPanGestureRecognizer *panGesture;

/**-----------------------------------------------------------------------------
 * @name UIView+draggable Methods
 * -----------------------------------------------------------------------------
 */

/** Enables the dragging
 *
 * Enables the dragging state of the view
 */
- (void)enableDragging;

/** Disable or enable the view dragging
 *
 * @param draggable The boolean that enables or disables the draggable state
 */
- (void)setDraggable:(BOOL)draggable;

@end
