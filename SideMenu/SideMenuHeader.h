//
//  SideMenuHeader.h
//  iCare
//
//  Created by ido zamberg on 4/5/15.
//  Copyright (c) 2015 ido zamberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuHeader : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgMenu;

- (IBAction)headerClicked:(id)sender;

@end
