//
//  AmphibianImage.h
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 6/11/13.
//  Copyright (c) 2013 Mel Roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Amphibian.h"

@protocol AmphibianImageDelegate <NSObject>
@required
-(void)imageLoaded:(NSData *)imageData andID:(NSString *)identification;
@end

@interface AmphibianImage : UIView<NSURLConnectionDataDelegate>
{
    NSMutableData *imageData;
    NSURLSession *session;
    
    UIActivityIndicatorView *activity;
    UIImageView *image;
    
    NSString *identifier;
    
    id <AmphibianImageDelegate> delegate;
    
    BOOL animate;
}

@property UIViewController * master; 
@property (nonatomic) id <AmphibianImageDelegate> delegate;

-(void)findImage:(Amphibian *)amphibian;
-(void)setImageFromData:(NSData *)data;
-(void)setImage:(UIImage *)im;
-(void)updateSubviews;

-(UIImage *)image;

-(void)clear;

@end
