//
//  PictureViewController.h
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 11/4/12.
//  Copyright (c) 2012 Mel Roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CollectionViewController.h"

@interface PictureViewController : UIViewController
{
    NSMutableArray *genera;
    
    CollectionViewController *collection;
    
    IBOutlet UISegmentedControl *selector;
    
    NSString *selectedGenus;
    
    NSString *loc;
    
    NSString *title;
}

- (IBAction)selectorChanged:(id)sender;
-(void)passData:(NSArray *)data andLocation:(NSString *)location;
-(void)passTitle:(NSString *)string;

@end
