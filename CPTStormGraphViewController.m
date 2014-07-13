//
//  CPTTestAppScatterPlotController.m
//  CPTTestApp-iPhone
//
//  Created by Brad Larson on 5/11/2009.
//

#import "CPTStormGraphViewController.h"
#import "AppData.h"
#import "FlowManager.h"

@implementation CPTStormGraphViewController

@synthesize dataForPlot;
@synthesize currentStorm = _currentStorm;

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark Initialization and teardown

- (void) viewWillAppear:(BOOL)animated
{
    // Getting first exercise
    Exercise* firstExercise = [_currentStorm.exercises objectAtIndex:0];
    
    // Setting title
    self.lblDate.text = [NSString stringWithFormat:@"ÉVÈNEMENT DU %@", [DateTimeHelper getDate:_currentStorm.date withDateFormat:@"dd.MM.yyyy"]];
    self.imgLevel.image = [UIImage imageNamed:[NSString stringWithFormat:@"dot%i.png",[firstExercise.level integerValue]]];
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    // Create graph from theme
    graph = [[CPTXYGraph alloc] initWithFrame:self.vwGraphFrame.frame];
  //  CPTTheme *theme = [CPTTheme themeNamed:kCPTSlateTheme];
    //[graph applyTheme:theme];
    
    CPTGraphHostingView *hostingView = (CPTGraphHostingView *)self.vwGraphFrame;
    hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    hostingView.hostedGraph     = graph;

    graph.paddingLeft   = 10.0;
    graph.paddingTop    = 10.0;
    graph.paddingRight  = 10.0;
    graph.paddingBottom = 10.0;

    // Setup plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = NO;
    plotSpace.xRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(1.0) length:CPTDecimalFromFloat(2.0)];
    plotSpace.yRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(1.0) length:CPTDecimalFromFloat(3.0)];

    // Axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.hidden = YES;
    x.majorIntervalLength         = CPTDecimalFromString(@"0.5");
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"2");
    x.minorTicksPerInterval       = 2;
    NSArray *exclusionRanges = [NSArray arrayWithObjects:
                                [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-100) length:CPTDecimalFromFloat(100)],
                                [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.99) length:CPTDecimalFromFloat(0.02)],
                                [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(2.99) length:CPTDecimalFromFloat(0.02)],
                                nil];
    x.labelExclusionRanges = exclusionRanges;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;


    CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength         = CPTDecimalFromString(@"0.5");
    y.minorTicksPerInterval       = 5;
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"2");
    y.hidden = YES;
    exclusionRanges               = [NSArray arrayWithObjects:
                                     [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-100) length:CPTDecimalFromFloat(100)],
                                     [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.99) length:CPTDecimalFromFloat(0.02)],
                                     [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(3.99) length:CPTDecimalFromFloat(0.02)],
                                     nil];
    y.labelExclusionRanges = exclusionRanges;
    y.delegate             = self;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;

    // Create a blue plot area
    CPTScatterPlot *boundLinePlot  = [[CPTScatterPlot alloc] init];
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 1.0f;
    lineStyle.lineColor         = [CPTColor whiteColor];
    boundLinePlot.dataLineStyle = lineStyle;
    boundLinePlot.identifier    = @"Blue Plot";
    boundLinePlot.dataSource    = self;
    [graph addPlot:boundLinePlot];

    // Do a blue gradient
    CPTColor *areaColor1       = [CPTColor clearColor];
    CPTGradient *areaGradient1 = [CPTGradient gradientWithBeginningColor:areaColor1 endingColor:[CPTColor clearColor]];
    areaGradient1.angle = -90.0f;
   // CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient1];
   // boundLinePlot.areaFill      = areaGradientFill;
    //boundLinePlot.areaBaseValue = [[NSDecimalNumber zero] decimalValue];

    // Add plot symbols
    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPTColor whiteColor];
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill          = [CPTFill fillWithColor:[CPTColor whiteColor]];
    plotSymbol.lineStyle     = symbolLineStyle;
    plotSymbol.size          = CGSizeMake(10.0, 10.0);
    boundLinePlot.plotSymbol = plotSymbol;

    boundLinePlot.opacity = 0.0f;
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.duration            = 1.5f;
    fadeInAnimation.removedOnCompletion = NO;
    fadeInAnimation.fillMode            = kCAFillModeBoth;
    fadeInAnimation.toValue             = [NSNumber numberWithFloat:1.0];
    [boundLinePlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];

    [self changePlotRange];

}

-(void)changePlotRange
{
    // Setup plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;

    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1) length:CPTDecimalFromFloat(self.currentStorm.exercises.count + 1)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(10.5)];
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    //return self.currentStorm.exercises.count;
    
    return self.currentStorm.tensions.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    //Exercise* currentEx = [self.currentStorm.exercises objectAtIndex:index];
    
    NSNumber* level = [self.currentStorm.tensions objectAtIndex:index];
    
    NSString *key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
    
    if ([key isEqualToString:@"x"])
    {
        return [NSNumber numberWithInt:index];
    }
    else
    {
        return level;
    }
    
}

#pragma mark -
#pragma mark Axis Delegate Methods

-(BOOL)axis:(CPTAxis *)axis shouldUpdateAxisLabelsAtLocations:(NSSet *)locations
{
    static CPTTextStyle *positiveStyle = nil;
    static CPTTextStyle *negativeStyle = nil;

    NSFormatter *formatter = axis.labelFormatter;
    CGFloat labelOffset    = axis.labelOffset;
    NSDecimalNumber *zero  = [NSDecimalNumber zero];

    NSMutableSet *newLabels = [NSMutableSet set];

    for ( NSDecimalNumber *tickLocation in locations ) {
        CPTTextStyle *theLabelTextStyle;

        if ( [tickLocation isGreaterThanOrEqualTo:zero] ) {
            if ( !positiveStyle ) {
                CPTMutableTextStyle *newStyle = [axis.labelTextStyle mutableCopy];
                newStyle.color = [CPTColor clearColor];
                positiveStyle  = newStyle;
            }
            theLabelTextStyle = positiveStyle;
        }
        else {
            if ( !negativeStyle ) {
                CPTMutableTextStyle *newStyle = [axis.labelTextStyle mutableCopy];
                newStyle.color = [CPTColor clearColor];
                negativeStyle  = newStyle;
            }
            theLabelTextStyle = negativeStyle;
        }

        NSString *labelString       = [formatter stringForObjectValue:tickLocation];
        CPTTextLayer *newLabelLayer = [[CPTTextLayer alloc] initWithText:labelString style:theLabelTextStyle];

        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithContentLayer:newLabelLayer];
        newLabel.tickLocation = tickLocation.decimalValue;
        newLabel.offset       = labelOffset;

        [newLabels addObject:newLabel];
    }

    axis.axisLabels = Nil;

    return NO;
}

- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)emergencyClicked:(id)sender {
    [[FlowManager sharedInstance] showEmergencyVC];
}
@end
