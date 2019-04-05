//
//  ViewController.m
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 11/3/12.
//  Copyright (c) 2012 Mel Roderick. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Insert GIF Logo modified by Chenyu Marh 8 2019
    FLAnimatedImage *logoimage = [FLAnimatedImage animatedImageWithGIFData: [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AWlogoanimated300_loop" ofType:@"gif"]]];
    self.logo.animatedImage = logoimage;
    [self.view addSubview:self.logo];
    
    // end of loading gif
    
    integerFinder *intFin = [[integerFinder alloc] init];
    [intFin setDelegate:self];
    [intFin getInteger:[NSURL URLWithString:@"https://amphibiaweb.org/lists/counts/amphibian_total"]];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0 green:0.5 blue:0 alpha:1]];
    
    Amphibian *test = [[Amphibian alloc] initWithName:@"test" withPicture:NULL withSound:NULL];
    [image findImage:test];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)integerFound:(NSString *)integer
{
    [label setText:[NSString stringWithFormat:@"Total Described Taxa: %@", integer]];
    [label setHidden:NO];
}

@end
