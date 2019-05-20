//
//  ImageFinder.h
//  AmphibiaWeb
//
//  Created by Mel Roderick on 6/19/12.
//  Copyright (c) 2012 Melrose Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol imageFinderDelegate <NSObject>
@required
-(void)imageFound:(NSData *)imageAsData;
@end

@interface ImageFinder : NSObject<NSURLConnectionDataDelegate>
{
    id <imageFinderDelegate> delegate;
    
    NSMutableData *imageData;
    NSURLConnection *imageURLConnection;
    
    UIAlertController *alert; // alert displayed when error occurs
}
@property UIViewController *master;
@property ( nonatomic) id <imageFinderDelegate> delegate;
-(void)getImage:(NSURL *)url;
-(void)cancelConnection;
@end
