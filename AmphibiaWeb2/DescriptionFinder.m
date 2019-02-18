//
//  DescriptionFinder.m
//  AmphibiaWeb
//
//  Created by Mel Roderick on 8/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DescriptionFinder.h"

@implementation DescriptionFinder

@synthesize delegate = delegate;

-(void)findDescription:(NSString *)species;
{
    NSArray *twoNames = [species componentsSeparatedByString:@" "]; // split the species name to genus and species
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://amphibiaweb.org/cgi/amphib_ws?where-genus=%@&where-species=%@&src=eol",[twoNames objectAtIndex:0],[twoNames objectAtIndex:1]]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    descriptionURLConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (descriptionURLConnection) {
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
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Trouble connecting to internet" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"description"])
    {
        isURL = YES; // next string is url
    }
    else if([elementName isEqualToString:@"common_name"])
    {
        isCommonName = YES; // next string is common name
    }
}

-(void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    if(isURL)
    {
        NSMutableString *data = [[NSMutableString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding]; // save description
        while ([data rangeOfString:@"<"].length != 0 && [data rangeOfString:@">"].length != 0)
        {
            [data deleteCharactersInRange:NSMakeRange([data rangeOfString:@"<"].location, ([data rangeOfString:@">"].location - [data rangeOfString:@"<"].location) + 1)];
        }
        while ([[data substringToIndex:0] isEqualToString:@" "])
        {
            [data deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        [delegate descriptionFound:data]; // send description to delegate
        isURL = NO;
        [parser abortParsing];
    }
    else if(isCommonName)
    {
        NSString *data = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding]; // save common name
        NSArray *commonnames = [data componentsSeparatedByString:@","]; // split up the common names
        [delegate commonNameFound:[commonnames objectAtIndex:0]]; // send 1st common name to delegate
        isCommonName = NO;
    }
}

-(void)cancelConnection
{
    [descriptionURLConnection cancel];
}


@end
