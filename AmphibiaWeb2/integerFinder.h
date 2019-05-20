//
//  integerFinder.h
//  AmphibiaWeb
//
//  Created by Mel Roderick on 6/20/12.
//  Copyright (c) 2012 Melrose Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol integerFinderDelegate <NSObject>
@required
-(void)integerFound:(NSString *)integer;
@end

@interface integerFinder : NSObject <NSURLConnectionDataDelegate>
{
    id <integerFinderDelegate> delegate;
    
    NSMutableData *integerData;
    
    @public
    UIViewController *view;
    
    // UIAlertView *alert; // alert displayed when error occurs
}
@property ( nonatomic) id <integerFinderDelegate> delegate;
-(void)getInteger:(NSURL *)url;

@end
