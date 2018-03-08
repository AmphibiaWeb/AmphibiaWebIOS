//
//  kmlFinder.h
//  AmphibiaWeb
//
//  Created by Mel Roderick on 9/22/12.
//
//

#import <Foundation/Foundation.h>

@protocol kmlFinderDelegate <NSObject>
@required
-(void)kmlFound:(NSMutableData *)kmlData;
@end

@interface kmlFinder : NSObject<NSURLConnectionDataDelegate> {
    id <kmlFinderDelegate> delegate;
    
    NSMutableData *datakml;
    NSURLConnection *kmlURLConnection;
    
    BOOL loading;
    
    UIAlertView *alert; // alert displayed when error occurs
}
@property ( nonatomic) id <kmlFinderDelegate> delegate;
-(void)findKml:(NSString *)species; // tells self to start finding points given species
-(void)cancelConnection;

-(BOOL)isLoading;
@end
