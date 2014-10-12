//
//  EMGTableView.h
//  iCare
//
//  Created by ido zamberg on 10/5/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMGTableHeader.h"

@protocol EMGTableViewDelegate <NSObject>

- (void)EMGTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface EMGTableView : UIView <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray* dataSourceArray;
}

- (id) initTableWithData : (NSArray*) data lowerPoint :(CGPoint) lowerAncor upperPoint :(CGPoint) upperPoint andFrame : (CGRect) frame;
- (void) setTableDataSource : (NSArray*) data;
- (void) moveViewToTop;
- (void) moveViewToBottom;

@property (nonatomic,weak)   id <EMGTableViewDelegate> EMGDelegate;
@property (nonatomic,strong) UITableView* tblList;
@property (nonatomic)        CGPoint lowerAncorPoint;
@property (nonatomic)        CGPoint upperAncorPoint;


@end
