//
//  Table.h
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 11/3/12.
//  Copyright (c) 2012 Mel Roderick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AmphibianCell.h"

@interface Table : UIViewController
{
    NSArray *amphibianData;
    
    NSIndexPath *index;
    
    IBOutlet UITableView *table;
    
    IBOutlet UIActivityIndicatorView *activity;
    
    NSIndexPath *tempCellIndex;
    int soundPlayingRow; // row which amphibiaSound is stored for
    AVAudioPlayer *amphibianSound; // species sound
    NSMutableData *soundData; // retrieves data from the web for the sounds
    NSURLConnection *soundURLConnection;
    BOOL recievingSound;
    IBOutlet UIActivityIndicatorView *soundActivity;
    
    NSString *title;
}

-(void)passData:(NSArray *)data;
-(void)passTitle:(NSString *)string;
- (void)cellSoundButtonPressed:(id)sender;

@end
