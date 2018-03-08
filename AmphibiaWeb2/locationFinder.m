//
//  locationFinder.m
//  AmphibiaWeb
//
//  Created by Mel Roderick on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "locationFinder.h"

@implementation locationFinder

@synthesize delegate = delegate;

- (id)init
{
    self = [super init];
    if (self)
    {
        //declare locmanager
        locmanager = [[CLLocationManager alloc] init]; 
        [locmanager setDelegate:self]; 
        [locmanager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
        alert = NULL;
    }
    return self;
}

-(void)findLocation
{
    inYourArea = YES; // location is using your location
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(startFindingLocation) userInfo:nil repeats:NO]; // timer used for in order to not block thread and use curl up animation
}

-(void)startFindingLocation
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0)
    {
        isLongName = NO;
        isShortName = NO;
        isType = NO;
        searching = NO;
        if(shortName != NULL)
        {
            shortName = NULL;
        }
        if(longName != NULL)
        {
            longName = NULL;
        }
        if(countryCode != NULL)
        {
            countryCode = NULL;
        }
        if(stateCode != NULL)
        {
            stateCode = NULL;
        }
        if(region != NULL)
        {
            region = NULL;
        }
        if(countryName != NULL)
        {
            countryName = NULL;
        }
    }
    
    searching = NO; // make searching is false
    [locmanager startUpdatingLocation]; // start finding user location
}

-(void)findLocationGivenPoint:(CLLocationCoordinate2D)point
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
    {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        
        [geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude] completionHandler:
         ^(NSArray* placemarks, NSError* error){
             if ([placemarks count] > 0)
             {
                 CLPlacemark *p = [placemarks objectAtIndex:0];
                 countryCode = p.ISOcountryCode;
                 ////stateCode = p.administrativeArea;
                 stateCode = [p.administrativeArea stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                 region = p.subAdministrativeArea;
                 countryName = p.country;
                 
                 [self sendToDelegate];
             }
         }];
    }
    else
    {
        location = point;
        
        isLongName = NO;
        isShortName = NO;
        isType = NO;
        searching = NO;
        if(shortName != NULL)
        {
            shortName = NULL;
        }
        if(longName != NULL)
        {
            longName = NULL;
        }
        if(countryCode != NULL)
        {
            countryCode = NULL;
        }
        if(stateCode != NULL)
        {
            stateCode = NULL;
        }
        if(region != NULL)
        {
            region = NULL;
        }
        if(countryName != NULL)
        {
            countryName = NULL;
        }
        
        inYourArea = NO; // location is not using your location
        
        
        NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/xml?latlng=%f,%f&sensor=true",location.latitude,location.longitude]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        NSLog(@"%@",[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/xml?latlng=%f,%f&sensor=true",location.latitude,location.longitude]);
        connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        if (connection) {
            // Create the NSMutableData to hold the received data.
            // receivedData is an instance variable declared elsewhere.
            locationData = [NSMutableData data];
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        } else {
            // Inform the user that the connection failed.
        }
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [locationData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:locationData];
    [parser setDelegate:self];
    [parser parse];
    
    //make sure locmanager doesn't update location again
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if(!searching) // make sure locmanager didn't update twice
    {
        searching = YES;
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
        {
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            
            [geocoder reverseGeocodeLocation:newLocation completionHandler:
             ^(NSArray* placemarks, NSError* error){
                 if ([placemarks count] > 0)
                 {
                     CLPlacemark *p = [placemarks objectAtIndex:0];
                     countryCode = p.ISOcountryCode;
                     ////stateCode = p.administrativeArea;
                     stateCode = [p.administrativeArea stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                     region = p.administrativeArea;
                     countryName = p.country;
                     
                     [self sendToDelegate];
                 }
             }];
        }
        else
        {
            CLLocationCoordinate2D loc = [newLocation coordinate]; // convert CLLocation to CLLocationCoordinate2D
            
            [locmanager stopUpdatingLocation];
            
            NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/xml?latlng=%f,%f&sensor=true",loc.latitude,loc.longitude]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
            if (connection) {
                // Create the NSMutableData to hold the received data.
                // receivedData is an instance variable declared elsewhere.
                locationData = [NSMutableData data];
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            } else {
                // Inform the user that the connection failed.
            }
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //initialize location error
    [locmanager stopUpdatingLocation];
    alert = [[UIAlertView alloc] initWithTitle:@"Location Error" message:@"Trouble finding your location" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try Again", nil];
    [alert show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    //initialise conncection error
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //try again was pressed
    
    if(buttonIndex == 1)
    {
        if(inYourArea)
        {
            //search for your location again
            searching = NO;
            [locmanager stopUpdatingLocation];
            [locmanager startUpdatingLocation];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        }
        else
        {
            //find location information of your location again
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(startFindingLocationGivenPoint) userInfo:nil repeats:NO];
        }
    }
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //parse through each element
    
    if([elementName isEqualToString:@"long_name"])
    {
        // if the element title is long_name tell self
        
        isLongName = YES;
    }
    else if([elementName isEqualToString:@"short_name"])
    {
        // if the element title is short_name tell self
        
        isShortName = YES;
    }
    else if([elementName isEqualToString:@"type"])
    {
        // if the element title is type tell self
        
        isType = YES;
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"address_component"])
    {
        // release all infromation at the end of address_component element
        
        if(longName != NULL)
        {
            longName = NULL;
        }
        if(shortName != NULL)
        {
            shortName = NULL;
        }
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(isLongName)
    {
        //store long_name of each element
        
        longName = [[NSString alloc] initWithString:string];
        isLongName = NO;
    }
    else if(isShortName)
    {
        //store short_name of each element
        
        shortName = [[NSString alloc] initWithString:string];
        isShortName = NO;
    }
    else if(isType)
    {
        if([string isEqualToString:@"country"])
        {
            // if the type is country, store that information seperately
            if(longName != NULL && countryName == NULL)
            {
                countryName = [[NSString alloc] initWithString:longName];
            }
            if(shortName != NULL && countryCode == NULL)
            {
                countryCode = [[NSString alloc] initWithString:shortName];
            }
        }
        else if([string isEqualToString:@"administrative_area_level_1"])
        {
            // if the type is administrative_area_level_1, store that information seperately
            if(longName != NULL && region == NULL)
            {
                region = [[NSString alloc] initWithString:longName];
            }
            if(shortName != NULL && stateCode == NULL)
            {
                stateCode = [[NSString alloc] initWithString:shortName];
            }
        }
        isType = NO;
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    //send delegate infomation
    
    [self sendToDelegate];
    
    parser = NULL;
    //[self release];
}

-(void)sendToDelegate
{
    NSLog(@"%@, %@, %@",countryCode, stateCode,region);
    
    if(countryCode == NULL)
    {
        [delegate locationFoundCounty:countryName andCode:@"" withState:stateCode withRegion:NULL];
    }
    else if([countryCode isEqualToString:@"US"] || [countryCode isEqualToString:@"CA"])
    {
        [delegate locationFoundCounty:countryName andCode:countryCode withState:stateCode withRegion:region];
    }
    else
    {
        [delegate locationFoundCounty:countryName andCode:countryCode withState:stateCode withRegion:NULL];
    }
}

-(void)cancelConnection
{
    [connection cancel];
}

@end