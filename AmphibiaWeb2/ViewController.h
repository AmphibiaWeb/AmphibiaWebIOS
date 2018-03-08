//
//  ViewController.h
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 11/3/12.
//  Copyright (c) 2012 Mel Roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "integerFinder.h"
#import "AmphibianImage.h"////

@interface ViewController : UIViewController <integerFinderDelegate>
{
    IBOutlet UILabel *label;
    IBOutlet AmphibianImage *image;////
}

@end
