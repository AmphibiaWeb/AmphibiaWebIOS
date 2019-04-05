//
//  About.h
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 11/5/12.
//  Copyright (c) 2012 Mel Roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "integerFinder.h"

@interface About : UIViewController <integerFinderDelegate>
{
    IBOutlet UILabel *anuraLabel;
    IBOutlet UILabel *caudataLabel;
    IBOutlet UILabel *gymnophionaLabel;
    
    IBOutlet UILabel *totalLabel;
    
    int count;
}

@end
