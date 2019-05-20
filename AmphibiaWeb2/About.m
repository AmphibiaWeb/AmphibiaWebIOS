//
//  About.m
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 11/5/12.
//  Copyright (c) 2012 Mel Roderick. All rights reserved.
//

#import "About.h"

#import "WebViewController.h"

@interface About ()

@end

@implementation About

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
    
    integerFinder *intFin = [[integerFinder alloc] init];
    intFin->view= self;
    [intFin setDelegate:self];
    [intFin getInteger:[NSURL URLWithString:@"https://amphibiaweb.org/lists/counts/anura_total"]];
    
    count = 0;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toIUCN"])
    {
        [(WebViewController *)[segue destinationViewController] passUrl:[NSURL URLWithString:@"http://www.iucnredlist.org/initiatives/amphibians"]];
    }
    else
    {
        [(WebViewController *)[segue destinationViewController] passUrl:[NSURL URLWithString:@"https://amphibiaweb.org/about/index.html"]];
    }
}

-(void)integerFound:(NSString *)integer
{
    if(count == 0)
    {
        [anuraLabel setText:[NSString stringWithFormat:@"Total Described Anura: %@", integer]];
        [anuraLabel setHidden:NO];
        
        integerFinder *intFin = [[integerFinder alloc] init];
        intFin->view = self;
        [intFin setDelegate:self];
        [intFin getInteger:[NSURL URLWithString:@"https://amphibiaweb.org/lists/counts/caudata_total"]];
    }
    else if(count == 1)
    {
        [caudataLabel setText:[NSString stringWithFormat:@"Total Described Caudata: %@", integer]];
        [caudataLabel setHidden:NO];
        
        integerFinder *intFin = [[integerFinder alloc] init];
        intFin->view = self;
        [intFin setDelegate:self];
        [intFin getInteger:[NSURL URLWithString:@"https://amphibiaweb.org/lists/counts/gymnophiona_total"]];
    }
    else
    {
        [gymnophionaLabel setText:[NSString stringWithFormat:@"Total Described Gymnophiona: %@", integer]];
        [gymnophionaLabel setHidden:NO];
    }
    
    count++;
}

/*
- (void)viewDidUnload {
    anuraLabel = nil;
    caudataLabel = nil;
    gymnophionaLabel = nil;
    [super viewDidUnload];
}
*/

@end
