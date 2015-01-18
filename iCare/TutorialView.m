//
//  TutorialView.m
//  iCare
//
//  Created by ido zamberg on 11/11/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import "TutorialView.h"

@implementation TutorialView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{
    // Animating dismiss of viewcontroller
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL b){
    }];
    
}

@end
