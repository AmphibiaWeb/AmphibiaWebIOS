//
//  MapViewController.h
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 11/4/12.
//  Copyright (c) 2012 Mel Roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

#import "pointFinder.h"
#import "kmlFinder.h"
#import "KMLParser.h"
#import "REVClusterMap.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, pointFinderDelegate, kmlFinderDelegate>
{
    REVClusterMapView *map;
    
    NSString *name;
    
    IBOutlet UIActivityIndicatorView *activity;
    
    pointFinder *pntFin;
    kmlFinder *kmlFin;
    
    KMLParser *kml;
    NSArray *savedOverlays;
    NSArray *savedPoints;
    
    IBOutlet UIView *popOutView;
    BOOL optionsOpen;
    BOOL moving;
    
    IBOutlet UIBarButtonItem *optionsButton;
    IBOutlet UISegmentedControl *pointType;
    IBOutlet UISegmentedControl *mapType;
}

-(void)passName:(NSString *)inputName;
- (IBAction)openOptions:(id)sender;
- (IBAction)closeOptions:(id)sender;

- (IBAction)mapChanged:(id)sender;
- (IBAction)pointChanged:(id)sender;

@end
