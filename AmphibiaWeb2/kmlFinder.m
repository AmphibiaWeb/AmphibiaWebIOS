//
//  kmlFinder.m
//  AmphibiaWeb
//
//  Created by Mel Roderick on 9/22/12.
//
//

#import "kmlFinder.h"

@implementation kmlFinder

@synthesize delegate = delegate;

-(void)findKml:(NSString *)species
{
    NSArray *twoNames = [species componentsSeparatedByString:@" "];
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://amphibiaweb.org/cgi/amphib_ws_shapefile?format=kmz&genus=%@&species=%@",[twoNames objectAtIndex:0],[twoNames objectAtIndex:1]]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSLog(@"%@",[NSString stringWithFormat:@"https://amphibiaweb.org/cgi/amphib_ws_shapefile?format=kmz&genus=%@&species=%@",[twoNames objectAtIndex:0],[twoNames objectAtIndex:1]]);
    
    loading = YES;
    
    kmlURLConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if (kmlURLConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        datakml = [NSMutableData data];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    } else {
        // Inform the user that the connection failed.
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [datakml appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    loading = NO;
    
    [delegate kmlFound:datakml];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Trouble connecting to internet" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)cancelConnection
{
    [kmlURLConnection cancel];
}

-(BOOL)isLoading
{
    return loading;
}

@end
