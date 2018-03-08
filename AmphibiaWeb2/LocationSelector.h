//
//  LocationSelector.h
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 11/4/12.
//  Copyright (c) 2012 Mel Roderick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "coordView.h"
#import "Search.h"

@interface LocationSelector : UIViewController <coordViewDelegate>
{
    IBOutlet coordView *coordSelector;
    IBOutlet MKMapView *map;
    IBOutlet UISegmentedControl *selector;
    
    CLLocationCoordinate2D loc;
    
    BOOL mapFoundUser;
    BOOL locChosen;
    
    Search *search;
    
    MKPlacemark *marker;
}
- (IBAction)selectorChanged:(id)sender;
-(void)passSender:(Search *)sender;

@end
