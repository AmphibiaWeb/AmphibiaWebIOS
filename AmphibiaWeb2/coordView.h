//
//  coordView.h
//  AmphibiaWeb
//
//  Created by Mel Roderick on 8/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//  This class works with the MKMapView to tell the AppDelegate at which location it was tapped

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@protocol coordViewDelegate <NSObject>
@required
-(void)coordViewTouchedAtPoint:(CGPoint)point; // tells delegate the lat long of tapped location
@end

@interface coordView : UIView
{
    id <coordViewDelegate> delegate;
}
@property ( nonatomic) id <coordViewDelegate> delegate;

@end
