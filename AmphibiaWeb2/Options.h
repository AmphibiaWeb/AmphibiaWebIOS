//
//  Options.h
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 11/4/12.
//  Copyright (c) 2012 Mel Roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Options : UIViewController
{
    IBOutlet UISegmentedControl *browseSelector;
    IBOutlet UISegmentedControl *titleSelector;
    
    IBOutlet UISegmentedControl *pointType;
    IBOutlet UISegmentedControl *mapType;
}

- (IBAction)browseChanged:(id)sender;
- (IBAction)titleChanged:(id)sender;

- (IBAction)pointChanged:(id)sender;
- (IBAction)mapChanged:(id)sender;

@end
