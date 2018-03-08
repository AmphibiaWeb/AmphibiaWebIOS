//
//  Search.h
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 11/4/12.
//  Copyright (c) 2012 Mel Roderick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "locationFinder.h"

@interface Search : UIViewController <locationFinderDelegate, UITextFieldDelegate>
{
    IBOutlet UITextField *scientificNameTextField;
    IBOutlet UITextField *commonNameTextField;
    IBOutlet UITextField *familyNameTextField;
    IBOutlet UILabel *searchLocationLabel;
    NSString *countryCode;
    
    UIAlertView *alert;
}

- (IBAction)scientificNameChanged:(id)sender;
- (IBAction)commonNameChanged:(id)sender;
- (IBAction)familyNameChanged:(id)sender;
- (IBAction)searchChooseLocationButtonPressed:(id)sender;
- (IBAction)searchClearLocationButtonPressed:(id)sender;
- (IBAction)clearPageButtonPressed:(id)sender;
- (IBAction)searchButtonPressed:(id)sender;

-(void)sendLocation:(CLLocationCoordinate2D)loc;

@end