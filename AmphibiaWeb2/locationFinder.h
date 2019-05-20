//
//  locationFinder.h
//  AmphibiaWeb
//
//  Created by Mel Roderick on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//  This class finds location information of user location or another location

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol locationFinderDelegate <NSObject>
@required
-(void)locationFoundCounty:(NSString *)countryname andCode:(NSString *)countrycode withState:(NSString *)statecode withRegion:(NSString *)locregion; // sends country and state codes to delegate
@end

@interface locationFinder : NSObject<CLLocationManagerDelegate, NSXMLParserDelegate, NSURLConnectionDataDelegate> {
    CLLocationManager *locmanager; // finds location
    id <locationFinderDelegate> delegate;
    
    CLLocationCoordinate2D location; // given location
    
    UIAlertController *alert; // alert displayed when error occurs
    
    // data used for  parsing Google xml geocoder
    BOOL isLongName;
    BOOL isShortName;
    BOOL isType;
    NSString *shortName;
    NSString *longName;
    
    BOOL searching; // used to make sure your location is not updated while parsing xml
    BOOL inYourArea; // used by alert to choose the correct "try again" method
    
    // saved data to pass to delegate
    NSString *countryCode;
    NSString *stateCode;
    NSString *region;
    NSString *countryName;
    
    NSMutableData *locationData;
    NSURLConnection *connection;
}
@property UIViewController *master; 
@property ( nonatomic) id <locationFinderDelegate> delegate;
-(void)findLocation; // find user location
-(void)findLocationGivenPoint:(CLLocationCoordinate2D)point; // find location information of point
-(void)cancelConnection;

@end
