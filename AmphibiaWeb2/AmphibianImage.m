//
//  AmphibianImage.m
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 6/11/13.
//  Copyright (c) 2013 Mel Roderick. All rights reserved.
//

#import "AmphibianImage.h"

@implementation AmphibianImage

@synthesize delegate;

-(void)findImage:(Amphibian *)amphibian
{
    image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:image];
    [image setContentMode:UIViewContentModeScaleAspectFit];
    
    if([amphibian getPictureURL] != NULL)
    {
        identifier = [amphibian getName];
        
        NSArray *fourNames = [[amphibian getPictureURL] componentsSeparatedByString:@" "]; // seperate image code
        
        // updated cal photo urls Chenyu March 8 2019 
        NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://calphotos.berkeley.edu/imgs/128x192/%@_%@/%@/%@.jpeg",[fourNames objectAtIndex:0],[fourNames objectAtIndex:1],[fourNames objectAtIndex:2],[fourNames objectAtIndex:3]]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        imageURLConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        if (imageURLConnection) {
            // Create the NSMutableData to hold the received data.
            // receivedData is an instance variable declared elsewhere.
            imageData = [NSMutableData data];
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        } else {
            printf("no internet");
            // Inform the user that the connection failed.
        }
        
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activity setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
        [activity setColor:[UIColor blackColor]];
        [activity setHidesWhenStopped:YES];
        [self addSubview:activity];
        
        [activity startAnimating];
        
        animate = YES;
    }
    else {
        [image setImage:[UIImage imageNamed:@"noImageAvailable.png"]];
        
        animate = NO;
    }
}

-(void)setImageFromData:(NSData *)data
{
    [self setImage:[UIImage imageWithData:data]];
}

-(void)setImage:(UIImage *)im
{
    image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:image];
    
    [image setImage:im];
    
    [image setContentMode:UIViewContentModeScaleAspectFit];
    
    animate = NO;
}

-(UIImage *)image
{
    return image.image;
}

-(void)updateSubviews
{
    if(animate)
    {
        [UIView animateWithDuration:0.2 animations:^{
            
            if(self->activity != NULL)
            {
                [self->activity setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
            }
            
            [self->image setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            
        } completion:^(BOOL finished) {
            
            //Completion Handler
            
        }];
    }
    else
    {
        if(image.frame.size.width != self.frame.size.width)
        {
            if(activity != NULL)
            {
                [activity setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
            }
            
            [image setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [image setAlpha:0];
            
            [UIView animateWithDuration:0.2 animations:^{
                
                [self->image setAlpha:1];
                
            } completion:^(BOOL finished) {
                
                //Completion Handler
                
            }];
        }
        
        animate = YES;
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [imageData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    ////[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [image setImage:[UIImage imageWithData:imageData]];
    
    [activity stopAnimating];
    
    [delegate imageLoaded:imageData andID:identifier];
    
    [self updateSubviews];
    
    animate = NO;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    ///alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Trouble connecting to internet" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    ///[alert show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)cancelConnection
{
    [imageURLConnection cancel];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self updateSubviews];
}

-(void)clear
{
    [image removeFromSuperview];
    image = NULL;
    
    [activity removeFromSuperview];
    activity = NULL;
}

/*- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
