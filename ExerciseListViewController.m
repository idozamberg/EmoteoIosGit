//
//  ExerciseListViewController.m
//  iCare
//
//  Created by ido zamberg on 1/3/14.
//  Copyright (c) 2014 ido zamberg. All rights reserved.
//

#import "ExerciseListViewController.h"
#import "MediaFile.h"

@interface ExerciseListViewController ()

@end


@implementation ExerciseListViewController
{
    NSNumber* level;
    NSTimer*  colorTimer;
}


@synthesize shouldPerformColorTherapy = _shouldPerformColorTherapy;
@synthesize exerciseList;
@synthesize vwFrame;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    vwFrame.backgroundColor = [UIHelper generateRandomColor];

    
	// Do any additional setup after loading the view.
}

- (void) setShouldPerformColorTherapy:(BOOL)shouldPerformColorTherapyParam
{
    _shouldPerformColorTherapy = shouldPerformColorTherapyParam;
    
    // Checking if we should activate timer for changing bgColor
    if (_shouldPerformColorTherapy)
    {
        vwFrame.backgroundColor = [UIHelper generateRandomColor];
        self.imgBg.hidden = YES;
        
        
        if (colorTimer)
        {
            [colorTimer invalidate];
        }
        
        // Setting timer
       colorTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(animateChangeBgColor) userInfo:Nil repeats:YES];
    }
}


- (void) animateChangeBgColor
{
    [UIView animateWithDuration:1.5 animations:^{
        
        vwFrame.backgroundColor = [UIHelper generateRandomColor];
        
    }];
     
    [UIView commitAnimations];
}

- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) setLevel : (NSNumber*) numLevel
{
    level = numLevel;
}

- (IBAction)emergencyClicked:(id)sender {
    [[FlowManager sharedInstance] showEmergencyVC];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.tblExercises reloadData];
    
    if (level)
    {
        // Setting level text
        self.lblLevel.text = [NSString stringWithFormat:@"%i",[AppData sharedInstance].currentLevel];
        [self.imgBg setYPosition:-(10-[AppData sharedInstance].currentLevel) * self.view.frame.size.height];
        
        self.lblTitle.text = @"NIVEAU DE TENSION";
    }
    else
    {
        // Setting titles
        if (self.listType == videoType)
        {
            self.lblLevel.text = @"VIDÉO";
        }
        else if (self.listType == audioType)
        {
            self.lblLevel.text = @"AUDIO";
        }
        
        self.lblTitle.text = @"LES EXERCICES";
        self.imgBg.hidden = YES;
    }
    
}
    // Changing background

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return exerciseList.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* EXERCISE_CELL = @"ExerciseCell";
    
    // Getting current media file
    MediaFile* currentFile = [exerciseList objectAtIndex:indexPath.row];
    
    ExerciseCell* cell = [tableView dequeueReusableCellWithIdentifier:EXERCISE_CELL];
    
    // Checking if we are reusing
    if (cell == Nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ExerciseCell" owner:self options:nil] objectAtIndex:0];
        
    }
    
    cell.lblName.text = currentFile.title;
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    // Shwoing exercise chosen
    if (self.listType == videoType)
    {
        if (!(self.shouldPerformColorTherapy))
        {
            [[FlowManager sharedInstance] showVideoViewControllerWithVideo:[self.exerciseList objectAtIndex:indexPath.row]];
        }
        else
        {
            [[FlowManager sharedInstance] showVideoViewControllerWithVideo:[self.exerciseList objectAtIndex:indexPath.row] WithBackgroundColor:self.vwFrame.backgroundColor];
        }
    }
    else if (self.listType == audioType)
    {
        if (!(self.shouldPerformColorTherapy))
        {
            [[FlowManager sharedInstance] showAudioViewControllerWithAudioFile:[self.exerciseList objectAtIndex:indexPath.row]];
        }
        else
        {
            [[FlowManager sharedInstance] showAudioViewControllerWithAudioFile:[self.exerciseList objectAtIndex:indexPath.row] withBackgroundColor:self.vwFrame.backgroundColor];
        }
    }
    else if (self.listType == mixedType)
    {
        MediaFile* currentFile = [exerciseList objectAtIndex:indexPath.row];

        // Show screen according to file type
        if ([currentFile isKindOfClass:[VideoFile class]])
        {
            [[FlowManager sharedInstance] showVideoViewControllerWithVideo:[self.exerciseList objectAtIndex:indexPath.row]];
        }
        else  if ([currentFile isKindOfClass:[AudioFile class]])
        {
            [[FlowManager sharedInstance] showAudioViewControllerWithAudioFile:[self.exerciseList objectAtIndex:indexPath.row]];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 29;
}

- (BOOL) shouldAutorotate
{
    return NO;
}

@end
