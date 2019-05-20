//
//  pointFinder.h
//  AmphibiaWeb
//
//  Created by Mel Roderick on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//  This class finds the specimen points of each species

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKReverseGeocoder.h>
#import "REVClusterMap.h"

@protocol pointFinderDelegate <NSObject>
@required
-(void)pointsFound:(NSArray *)foundpoints;
@end

@interface pointFinder : NSObject<NSXMLParserDelegate, NSURLConnectionDataDelegate> {
    id <pointFinderDelegate> delegate;
    
    //parser information
    float currentLat;
    float currentLong;
    BOOL islat;
    BOOL islong;
    BOOL isidentifier;
    
    NSMutableArray *points;
    NSMutableData *dataXml;
    NSURLConnection *pointsURLConnection;
    
    BOOL loading;
    
    UIAlertController *alert; // alert displayed when error occurs
}
@property UIViewController * master;

@property ( nonatomic) id <pointFinderDelegate> delegate;
-(void)findPoints:(NSString *)species; // tells self to start finding points given species
-(void)cancelConnection;

-(BOOL)isLoading;
@end
