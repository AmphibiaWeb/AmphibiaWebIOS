//
//  AmphibiaFinder.m
//  AmphibiaWeb
//
//  Created by Mel Roderick on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AmphibiaFinder.h"
#import "Amphibian.h"

@implementation AmphibiaFinder

@synthesize delegate = delegate;

-(void)findAmphibia:(NSString *)countrycode withState:(NSString *)statecode
{
    ordr = NULL;
    species = NULL;
    picture = NULL;
    sound = NULL;
    anura = [[NSMutableArray alloc] init];
    caudata = [[NSMutableArray alloc] init];
    gymnophiona = [[NSMutableArray alloc] init];
    
    // start parsing
    if([countrycode isEqualToString:@"US"])
    {
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://amphibiaweb.org/cgi/amphib_ws_locality?where-isocc=us&rel-isocc=like&where-state_code=%@&rel-state_code=like", statecode]];
    }
    else if([countrycode isEqualToString:@"CA"])
    {
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://amphibiaweb.org/cgi/amphib_ws_locality?where-isocc=ca&rel-isocc=like&where-region=%@&rel-region=like", statecode]];
    }
    else
    {
        url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://amphibiaweb.org/cgi/amphib_ws_locality?where-isocc=%@&rel-isocc=like", countrycode]];
    }
    
    NSLog(@"%@", [url absoluteString]);
    
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    // switching to URLSession
    self.session = [NSURLSession sharedSession];
    dataXml = [NSMutableData data];
    NSURLSessionTask *task = [self.session dataTaskWithRequest:theRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (error){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Connection Error" message:@"Trouble connecting to internet" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
            [self->view presentViewController:alertController animated:YES completion:nil];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        else{
            // dataXml = [NSMutableData data];
            [self->dataXml appendData:data];
            self->myparser = [[NSXMLParser alloc] initWithData:self->dataXml];
            [self->myparser setDelegate:self];
            [self->myparser parse];
            // NSLog(@"done parsing");
        }
    }];
    [task resume];
    /*
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    self.finderTask = [self.session dataTaskWithRequest:theRequest];
    [self.finderTask resume];
    if (dataXml){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
     */
    
    /* pointsURLConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if (pointsURLConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        dataXml = [NSMutableData data];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    } else {
        // Inform the user that the connection failed.
    }
     */
}

/*
-(void)URLSession:(NSURLSession *)session dataTask:(nonnull NSURLSessionDataTask *)dataTask didReceiveData:(nonnull NSData *)data{
    NSLog(@"got the data");
    dataXml = [NSMutableData data];

}

-(void)URLSession:(NSURLSession *)session dataTask:(nonnull NSURLSessionDataTask *)dataTask willCacheResponse:(nonnull NSCachedURLResponse *)proposedResponse completionHandler:(nonnull void (^)(NSCachedURLResponse * _Nullable))completionHandler{
    
}

-(void)URLSession:(NSURLSession *)session task:(nonnull NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Connection Error" message:@"Trouble connecting to internet" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
    [self->view presentViewController:alertController animated:YES completion:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [dataXml appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    myparser = [[NSXMLParser alloc] initWithData:dataXml];
    [myparser setDelegate:self];
    [myparser parse];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
 
    alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Trouble connecting to internet" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Connection Error" message:@"Trouble connecting to internet" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
    [self->view presentViewController:alertController animated:YES completion:nil];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
*/

-(void)findAmphibiaWithscientificName:(NSString *)scientificName withcommonName:(NSString *)commonName withfamilyName:(NSString *)familyName withorderName:(NSString *)orderName countryCode:(NSString *)countryCode
{
    ordr = NULL;
    species = NULL;
    picture = NULL;
    sound = NULL;
    anura = [[NSMutableArray alloc] init];
    caudata = [[NSMutableArray alloc] init];
    gymnophiona = [[NSMutableArray alloc] init];
    
    if(countryCode == NULL)
    {
        countryCode = @"";
    }
    
    // save url
    
    NSCharacterSet *set = [NSCharacterSet URLHostAllowedCharacterSet];
    url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://amphibiaweb.org/cgi/amphib_ws_locality?where-isocc=%@&rel-isocc=like&where-scientific_name=%@&where-family=%@&where-ordr=%@&where-common_name=%@",[countryCode stringByAddingPercentEncodingWithAllowedCharacters:set],[scientificName stringByAddingPercentEncodingWithAllowedCharacters:set],[familyName stringByAddingPercentEncodingWithAllowedCharacters:set],[orderName stringByAddingPercentEncodingWithAllowedCharacters:set],[commonName stringByAddingPercentEncodingWithAllowedCharacters:set]]];
    
    NSLog(@"%@", [NSString stringWithFormat:@"https://amphibiaweb.org/cgi/amphib_ws_locality?where-isocc=%@&rel-isocc=like&where-scientific_name=%@&where-family=%@&where-ordr=%@&where-common_name=%@",[countryCode stringByAddingPercentEncodingWithAllowedCharacters:set],[scientificName stringByAddingPercentEncodingWithAllowedCharacters:set],[familyName stringByAddingPercentEncodingWithAllowedCharacters:set],[orderName stringByAddingPercentEncodingWithAllowedCharacters:set],[commonName stringByAddingPercentEncodingWithAllowedCharacters:set]]);
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    dataXml = [NSMutableData data];
    
    self.session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [self.session dataTaskWithRequest:theRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (error){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Connection Error" message:@"Trouble connecting to internet" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
            [self->view presentViewController:alertController animated:YES completion:nil];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        else{
            [self->dataXml appendData:data];
            self->myparser = [[NSXMLParser alloc] initWithData: self->dataXml];
            [self->myparser setDelegate:self];
            [self->myparser parse];
        }
    }];
    [task resume];
    /*
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    self.finderTask = [self.session dataTaskWithRequest:theRequest];
    [self.finderTask resume];
    */
    /*
    pointsURLConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (pointsURLConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        dataXml = [NSMutableData data];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    } else {
        // Inform the user that the connection failed.
    }
     */
    
    ///[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(startFindingLocation) userInfo:nil repeats:NO]; // timer used for in order to not block thread and use curl up animation
}

/*-(void)startFindingLocation
{
    // start parsing
    ///NSData *dataXml = [[NSData alloc] initWithContentsOfURL:url];
    myparser = [[NSXMLParser alloc] initWithData:dataXml];
    [myparser setDelegate:self];
    [myparser parse];
}*/

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"amphibian"]) // save amphibian infromation apter every amphibian element
    {
        Amphibian *amph = [[Amphibian alloc] initWithName:species withPicture:picture withSound:sound];
        if([ordr isEqualToString:@"Anura"])
        {
            [anura addObject:amph];
        }
        else if([ordr isEqualToString:@"Caudata"])
        {
            [caudata addObject:amph];
        }
        else
        {
            [gymnophiona addObject:amph];
        }
        species = NULL;
        ordr = NULL;
        if(picture != NULL)
        {
            picture = NULL;
        }
        if(sound != NULL)
        {
            sound = NULL;
        }
    }
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    /* alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Trouble connecting to internet" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show]; */
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Connection Error" message:@"Trouble connecting to internet" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
    [self->view presentViewController:alertController animated:YES completion:nil];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"scientificname"])
    {
        isSpecies = YES; // next string is species
    }
    else if([elementName isEqualToString:@"order"])
    {
        isOrder = YES; // next string is order
    }
    else if([elementName isEqualToString:@"image"])
    {
        isImage = YES; // next string is image code
    }
    else if([elementName isEqualToString:@"sound"])
    {
        isSound = YES; // next string is soundURL
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //save selected strings
    if(isSpecies)
    {
        species = [[NSString alloc] initWithString:string];
        isSpecies = NO;
    }
    else if(isOrder)
    {
        ordr = [[NSString alloc] initWithString:string];
        isOrder = NO;
    }
    else if(isImage)
    {
        if(picture == NULL)
        {
            picture = [[NSString alloc] initWithString:string];
        }
        isImage = NO;
    }
    else if(isSound)
    {
        if([string rangeOfString:@".rm"].length == 0 && sound == NULL) // make sure it is not an .rm file
        {
            sound = [[NSString alloc] initWithString:string];
        }
        isSound = NO;
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    //send information to delegate
    [delegate anuraFound:anura withCaudata:caudata withGymnophiona:gymnophiona];
}

@end
