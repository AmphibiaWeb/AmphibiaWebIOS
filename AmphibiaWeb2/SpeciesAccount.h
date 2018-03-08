//
//  SpeciesAccount.h
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 11/3/12.
//  Copyright (c) 2012 Mel Roderick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "Amphibian.h"
#import "DescriptionFinder.h"
#import "AmphibianImage.h"

@interface SpeciesAccount : UIViewController <descriptionFinderDelegate>
{
    Amphibian *amphibian;
    UIImage *image;
    
    IBOutlet UIActivityIndicatorView *imageActivity;
    IBOutlet AmphibianImage *imageView;
    IBOutlet UILabel *commonNameLabel;
    IBOutlet UIActivityIndicatorView *soundActivity;
    IBOutlet UIButton *soundButton;
    IBOutlet UITextView *description;
    IBOutlet UIActivityIndicatorView *descriptionActivity;
    
    AVAudioPlayer *amphibianSound; // species sound
    NSMutableData *soundData; // retrieves data from the web for the sounds
    NSURLConnection *soundURLConnection;
    BOOL recievingSound;
}

-(void)passAmphibian:(Amphibian *)amp andImage:(UIImage *)im;

- (IBAction)soundPressed:(id)sender;

@end
