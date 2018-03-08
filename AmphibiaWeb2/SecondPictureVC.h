//
//  SecondPictureVC.h
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 11/4/12.
//  Copyright (c) 2012 Mel Roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GenusArray.h"
#import "CollectionViewController.h"

@interface SecondPictureVC : UIViewController
{
    GenusArray *species;
    
    CollectionViewController *collection;
    
    IBOutlet UISegmentedControl *selector;
    
    NSString *selectedGenus;
    
    NSString *title;
}

- (IBAction)selectorChanged:(id)sender;
-(void)passData:(GenusArray *)data;
-(void)passTitle:(NSString *)string;

@end
