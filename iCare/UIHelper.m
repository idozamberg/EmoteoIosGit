//
//  UIHelper.m
//  iCare
//
//  Created by ido zamberg on 1/10/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import "UIHelper.h"

@implementation UIHelper

+ (void) showMessage : (NSString*) message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Information" message:message delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil];
    
    [alert show];
}

+ (UIColor*) generateRandomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    return color;
}

+ (NSInteger) getRandomNumbergWithMaxNumber : (NSInteger) max
{
    NSInteger number = (arc4random() % max);
    
    return number;
}

+ (NSMutableDictionary*) dictionaryFromPlistWithName : (NSString*) plistName
{
    // Getting files's path
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    
    // Getting data from plist
    NSMutableDictionary* data = [NSMutableDictionary dictionaryWithContentsOfFile:dataPath];
    
    return data;
}

+ (id)viewFromStoryboard:(NSString *)storyboardID
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"NavigationBoard" bundle:nil];
    UIViewController * controller = [storyBoard instantiateViewControllerWithIdentifier:storyboardID];
    
    UIView * vw = controller.view;
    return vw;
}

+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}
@end
