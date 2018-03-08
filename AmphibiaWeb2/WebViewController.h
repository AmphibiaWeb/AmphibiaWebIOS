//
//  WebViewController.h
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 11/4/12.
//  Copyright (c) 2012 Mel Roderick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *web;
    
    NSURL *baseURL;
    
    IBOutlet UIBarButtonItem *back;
    IBOutlet UIBarButtonItem *forward;
}

-(void)passUrl:(NSURL *)url;

- (IBAction)backPressed:(id)sender;
- (IBAction)forwardPressed:(id)sender;

@end
