//
//  discriptionFinder.h
//  AmphibiaWeb
//
//  Created by Mel Roderick on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//  This class finds the description and common name of each species

#import <Foundation/Foundation.h>

@protocol descriptionFinderDelegate <NSObject>
@required
-(void)descriptionFound:(NSString *)desc; // sends description to delegate
-(void)commonNameFound:(NSString *)commonNameString; // sends commonname to delegate
@end

@interface DescriptionFinder : NSObject<NSXMLParserDelegate, NSURLConnectionDataDelegate> {
    id <descriptionFinderDelegate> delegate;
    BOOL isURL;
    BOOL isCommonName;
    NSMutableData *dataXml;
    NSURLConnection *descriptionURLConnection;
    
    UIAlertView *alert; // alert displayed when error occurs
}
@property ( nonatomic) id <descriptionFinderDelegate> delegate;
-(void)findDescription:(NSString *)species; // start finding description
-(void)cancelConnection;
@end
