//
//  WebViewController.m
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 11/4/12.
//  Copyright (c) 2012 Mel Roderick. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)passUrl:(NSURL *)url
{
    baseURL = url;
}

- (IBAction)backPressed:(id)sender {
    [web goBack];
}

- (IBAction)forwardPressed:(id)sender {
    [web goForward];
}

- (void)viewDidAppear:(BOOL)animated
{
    [web loadRequest:[NSURLRequest requestWithURL:baseURL]];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if([web canGoBack])
    {
        [back setEnabled:YES];
    }
    else
    {
        [back setEnabled:NO];
    }
    
    if([web canGoForward])
    {
        [forward setEnabled:YES];
    }
    else
    {
        [forward setEnabled:NO];
    }
}

@end
