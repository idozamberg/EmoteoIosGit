//
//  ExereciseCell.m
//  iCare
//
//  Created by ido zamberg on 1/3/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import "ExerciseCell.h"

@implementation ExerciseCell

@synthesize lblName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
