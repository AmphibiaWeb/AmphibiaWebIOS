//
//  pointFinder.m
//  AmphibiaWeb
//
//  Created by Mel Roderick on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "pointFinder.h"

@implementation pointFinder

@synthesize delegate = delegate;

-(void)findPoints:(NSString *)species
{
    points = [[NSMutableArray alloc] init];
    
    NSArray *twoNames = [species componentsSeparatedByString:@" "]; // split the species name to genus and species
    
    loading = YES;
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://amphibiaweb.org/cgi/amphib_ws_specimens?genus=%@&species=%@",[twoNames objectAtIndex:0],[twoNames objectAtIndex:1]]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    pointsURLConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (pointsURLConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        dataXml = [NSMutableData data];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    } else {
        // Inform the user that the connection failed.
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [dataXml appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataXml];
    [parser setDelegate:self];
    [parser parse];
    
    loading = NO;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Trouble connecting to internet" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    if([elementName isEqualToString:@"decimallatitude"])
    {
        islat = YES; // next string is latitude
    }
    else if([elementName isEqualToString:@"decimallongitude"])
    {
        islong = YES; // next string is longitude
    }
    else if([elementName isEqualToString:@"globaluniqueidentifier"])
    {
        isidentifier = YES; // next string is global unique identifier
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(islat)
    {
        currentLat = [string doubleValue]; // save current latitude
        islat = NO;
    }
    else if(islong)
    {
        currentLong = [string doubleValue]; // save current longitude
        islong = NO;
    }
    else if(isidentifier)
    {
        //make an MKPointAnnotation
        REVClusterPin *annot = [[REVClusterPin alloc] init];
        annot.coordinate = CLLocationCoordinate2DMake(currentLat, currentLong);
        annot.title = string;
        
        [points addObject:annot];
        
        isidentifier = NO;
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    [delegate pointsFound:points]; // send it to delegate
}

-(void)cancelConnection
{
    [pointsURLConnection cancel];
    points = NULL;
}

-(BOOL)isLoading
{
    return loading;
}

@end
