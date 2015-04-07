//
//  CPTTestAppScatterPlotController.h
//  CPTTestApp-iPhone
//
//  Created by Brad Larson on 5/11/2009.
//

#import "CorePlot-CocoaTouch.h"
#import <UIKit/UIKit.h>
#import "Storm.h"
#import "SuperViewController.h"

@interface CPTStormGraphViewController : SuperViewController<CPTPlotDataSource, CPTAxisDelegate>
{
    CPTXYGraph *graph;

    NSMutableArray *dataForPlot;
}

@property (readwrite, strong, nonatomic) NSMutableArray *dataForPlot;
@property (weak, nonatomic) IBOutlet UIView *vwGraphFrame;
@property (nonatomic,strong) Storm* currentStorm;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgLevel;

- (IBAction)backClicked:(id)sender;
- (IBAction)emergencyClicked:(id)sender;

@end
