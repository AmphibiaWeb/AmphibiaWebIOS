//
//  ImageFinder.m
//  AmphibiaWeb
//
//  Created by Mel Roderick on 6/19/12.
//  Copyright (c) 2012 Melrose Entertainment. All rights reserved.
//

#import "ImageFinder.h"

@implementation ImageFinder

@synthesize delegate;

-(void)getImage:(NSURL *)url
{
    // debuggin message for url
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLSession *session = [NSURLSession sharedSession];
    imageData = [NSMutableData data];

    NSURLSessionTask *task = [session dataTaskWithRequest:theRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (error){
            dispatch_async(dispatch_get_main_queue(), ^{

            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Connection Error" message:@"Trouble connecting to internet" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
            [alert addAction:defaultAction];
            [self.master presentViewController:alert animated:YES completion:nil];
            /*
             alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Trouble connecting to internet" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
             [alert show];
             */
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            });
        }
        else{
            [self->imageData appendData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                [self->delegate imageFound:self->imageData];
                
            });
            
        }
    }];
    [task resume];
    
    /*
    imageURLConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (imageURLConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        imageData = [NSMutableData data];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    } else {
        // Inform the user that the connection failed.
    }
     */
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [imageData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [delegate imageFound:imageData];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    alert = [UIAlertController alertControllerWithTitle:@"Connection Error" message:@"Trouble connecting to internet" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * defaultAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
    [alert addAction:defaultAction];
    [self.master presentViewController:alert animated:YES completion:nil];
    /*
    alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Trouble connecting to internet" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show];
     */
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)cancelConnection
{
    [imageURLConnection cancel];
}

@end
