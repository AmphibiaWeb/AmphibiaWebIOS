//
//  SpeciesAccount.m
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 11/3/12.
//  Copyright (c) 2012 Mel Roderick. All rights reserved.
//

#import "SpeciesAccount.h"

#import "WebViewController.h"
#import "MapViewController.h"

@interface SpeciesAccount ()

@end

@implementation SpeciesAccount

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
    
    [self.navigationItem setTitle:[amphibian getName]];
    
    DescriptionFinder *descFin = [[DescriptionFinder alloc] init];
    [descFin setDelegate:self];
    [descFin findDescription:[amphibian getName]]; // start finding description
    [descriptionActivity startAnimating];
    
    if([amphibian getSoundURL] != NULL)
    {
        [soundButton setHidden:NO]; // display soundButton if a soundURL excists
    }
    else
    {
        [soundButton setHidden:YES];
    }
    
    if(image == NULL)
    {
        [imageView findImage:amphibian];
    }
    else
    {
        [imageView setImage:image];
        
        image = NULL;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)passAmphibian:(Amphibian *)amp andImage:(UIImage *)im
{
    amphibian = amp;
    
    image = im;
}

- (IBAction)soundPressed:(id)sender {
    // Sound button was pressed
    // load and play
    
    if(amphibianSound != NULL) // checks if selected sound was already loaded
    {
        //if so, stop if playing
        if(amphibianSound.playing)
        {
            [amphibianSound stop];
        }
        
        //or, restart and play if stopped
        else
        {
            amphibianSound.currentTime = 0;
            [amphibianSound play];
        }
    }
    else
    {
        // load sound
        NSURL *tempURL = [amphibian getSoundURL];
        
        NSURLRequest *theRequest = [NSURLRequest requestWithURL:tempURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        soundURLConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        if (soundURLConnection) {
            // Create the NSMutableData to hold the received data.
            // receivedData is an instance variable declared elsewhere.
            soundData = [NSMutableData data];
            
            [soundActivity startAnimating];
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            
            recievingSound = YES;
        } else {
            // Inform the user that the connection failed.
        }
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [soundData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (recievingSound) {
        amphibianSound = [[AVAudioPlayer alloc] initWithData:soundData error:NULL];
        
        [soundActivity stopAnimating];
        
        recievingSound = NO;
        
        //play sound
        [amphibianSound play];
    }
}

-(void)descriptionFound:(NSString *)desc
{
    description.text = desc; // set discription.text
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;  // stop showing networkActivityIndicator
    [descriptionActivity stopAnimating];
}
-(void)commonNameFound:(NSString *)commonNameString
{
    commonNameLabel.text = [NSString stringWithFormat:@"%@",commonNameString]; // set commonNameLabel.text
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toWebSite"])
    {
        NSArray *twoNames = [[amphibian getName] componentsSeparatedByString:@" "];
        
        [(WebViewController *)[segue destinationViewController] passUrl:[NSURL URLWithString:[NSString stringWithFormat:@"http://amphibiaweb.org/cgi-bin/amphib_query?query_src=aw_maps_geo-us&table=amphib&special=one_record&where-genus=%@&where-species=%@",[twoNames objectAtIndex:0],[twoNames objectAtIndex:1]]]];
    }
    else if([segue.identifier isEqualToString:@"toWebImages"])
    {
        NSArray *twoNames = [[amphibian getName] componentsSeparatedByString:@" "];
        
        [(WebViewController *)[segue destinationViewController] passUrl:[NSURL URLWithString:[NSString stringWithFormat:@"http://calphotos.berkeley.edu/cgi/img_query?query_src=aw_maps_geo-&where-taxon=%@+%@&rel-taxon=begins+with&where-lifeform=specimen_tag&rel-lifeform=ne",[twoNames objectAtIndex:0],[twoNames objectAtIndex:1]]]];
    }
    else
    {
        [(MapViewController *)[segue destinationViewController] passName:[amphibian getName]];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    printf("touch");
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    
    if(CGRectContainsPoint(imageView.frame, point))
    {
        [self performSegueWithIdentifier:@"toWebImages" sender:self];
    }
}

@end
