//
//  AmphibiaFinder.h
//  AmphibiaWeb
//
//  Created by Mel Roderick on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//  This class finds amphibians in an area

#import <Foundation/Foundation.h>

@protocol AmphibiaFinderDelegate <NSObject>
@required
-(void)anuraFound:(NSArray *)anura withCaudata:(NSArray *)caudata withGymnophiona:(NSArray *)gymnophiona;
@end

@interface AmphibiaFinder : NSObject<NSXMLParserDelegate, NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate> {
    id <AmphibiaFinderDelegate> delegate;
    
    //stores information to be passed to the delegate
    NSMutableArray *anura;
    NSMutableArray *caudata;
    NSMutableArray *gymnophiona;
    
    //parser variables
    BOOL isSpecies;
    BOOL isOrder;
    BOOL isSound;
    BOOL isImage;
    
    // only for amphibianfinders
    @public 
    UIViewController * view;
    
    NSString *ordr; // amphibian order
    NSString *species; // species name
    NSString *picture; // 4x4 picture code for calphotos
    NSString *sound; // soundURL in string format
    
    NSXMLParser *myparser; // xml parser
    
    // UIAlertView *alert; // alert displayed when error occurs
    
    NSURL *url;
    NSMutableData *dataXml;
    NSURLConnection *pointsURLConnection;
    
}

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *finderTask;

@property ( nonatomic) id <AmphibiaFinderDelegate> delegate;
-(void)findAmphibia:(NSString *)countrycode withState:(NSString *)statecode; // delegate calls this to start finding amphibia in country and state (if country is US)
-(void)findAmphibiaWithscientificName:(NSString *)scientificName withcommonName:(NSString *)commonName withfamilyName:(NSString *)familyName withorderName:(NSString *)orderName countryCode:(NSString *)countryCode;
@end
