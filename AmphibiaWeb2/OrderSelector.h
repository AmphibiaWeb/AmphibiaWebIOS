//
//  OrderSelector.h
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 11/3/12.
//  Copyright (c) 2012 Mel Roderick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "locationFinder.h"
#import "AmphibiaFinder.h"

@interface OrderSelector : UIViewController <locationFinderDelegate, AmphibiaFinderDelegate, UIAlertViewDelegate>
{
    NSArray *anuraData; // stores amphibiaData for order anura
    NSArray *caudataData; // stores amphibiaData for order caudata
    NSArray *gymnophionaData; // stores amphibiaData for order gymnophionaData
    
    // UIAlertView *alert; // when an error occures, this view pops up
    
    locationFinder *locfin;
    
    NSIndexPath *index;
    
    IBOutlet UITableView *table;
    
    IBOutlet UIActivityIndicatorView *activity;
    
    CLLocationCoordinate2D loc;
    
    NSString *yourArea;
    
    BOOL usingPassedLoc;
    BOOL usingSearch;
    
    NSString *name;
    NSString *common;
    NSString *family;
    NSString *cCode;
}

-(void)passLocation:(CLLocationCoordinate2D)location;
-(void)passName:(NSString *)nameString withCommonName:(NSString *)commonName withFamilyName:(NSString *)familyName andCountryCode:(NSString *)countryCode;

@end
