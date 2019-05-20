//
//  integerFinder.m
//  AmphibiaWeb
//
//  Created by Mel Roderick on 6/20/12.
//  Copyright (c) 2012 Melrose Entertainment. All rights reserved.
//

#import "integerFinder.h"

@implementation integerFinder

@synthesize delegate;

-(void)getInteger:(NSURL *)url
{
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    integerData = [NSMutableData data];
    
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:theRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (error){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Connection Error" message:@"Trouble connecting to internet" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
            [self->view presentViewController:alertController animated:YES completion:nil];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        else{
            [self->integerData appendData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->delegate integerFound:[[NSString alloc] initWithData:self->integerData encoding:NSUTF8StringEncoding]];
            });
        }
    }];
    [task resume];
    
    /*
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        integerData = [NSMutableData data];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
    } else {
        // Inform the user that the connection failed.
    }
     */
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [integerData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [delegate integerFound:[[NSString alloc] initWithData:integerData encoding:NSUTF8StringEncoding]];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    /* alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Trouble connecting to internet" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show]; */
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Connection Error" message:@"Trouble connecting to internet" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
    [self->view presentViewController:alertController animated:YES completion:nil];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
