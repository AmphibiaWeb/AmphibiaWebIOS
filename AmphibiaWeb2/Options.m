//
//  Options.m
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 11/4/12.
//  Copyright (c) 2012 Mel Roderick. All rights reserved.
//

#import "Options.h"

@interface Options ()

@end

@implementation Options

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
	// Do any additional setup after loading the view.
    
    [browseSelector setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"browseSelector"]];
    [titleSelector setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"titleSelector"]];
    [pointType setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"pointType"]];
    [mapType setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"mapType"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)browseChanged:(id)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:browseSelector.selectedSegmentIndex forKey:@"browseSelector"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)titleChanged:(id)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:titleSelector.selectedSegmentIndex forKey:@"titleSelector"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)pointChanged:(id)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:pointType.selectedSegmentIndex forKey:@"pointType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)mapChanged:(id)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:mapType.selectedSegmentIndex forKey:@"mapType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
