//
//  StormDetailCell.h
//  iCare
//
//  Created by ido zamberg on 1/17/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StormDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgLevel;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@end
