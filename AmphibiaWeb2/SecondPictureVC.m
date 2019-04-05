//
//  PictureViewController.m
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 11/4/12.
//  Copyright (c) 2012 Mel Roderick. All rights reserved.
//

#import "SecondPictureVC.h"

#import "SecondPictureVC.h"
#import "AmphibianCollectionCell.h"

@interface SecondPictureVC ()

@end

@implementation SecondPictureVC

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
    
    ////[self. initializeWithSender:self];
    ////[scrollView importGenera:genera andSize:slider.value];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectorChanged:(id)sender {
    [collection updateForSize:(int)[self sizeForIndex:(int)selector.selectedSegmentIndex]];
}

-(void)passData:(GenusArray *)data
{
    species = data;
}

-(void)passTitle:(NSString *)string
{
    title = string;
}

-(void)genusButtonPressed:(NSString *)genus
{
    selectedGenus = genus;
    
    [self performSegueWithIdentifier:@"nextScroll" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"embedSegue"])
    {
        collection = (CollectionViewController *)[segue destinationViewController];
        [collection passSpecies:[species amphibians] andTitle:title andSize:[self sizeForIndex:(unsigned int)selector.selectedSegmentIndex]];
        
        species = NULL;
    }
    else
    {
        /*for(int i = [genera count] - 1 ; i >= 0 ; i--)
        {
            if([[[genera objectAtIndex:i] getGenusName] isEqualToString:selectedGenus])
            {
                [[segue destinationViewController] passData:[genera objectAtIndex:i]];
                
                [[segue destinationViewController] passTitle:[NSString stringWithFormat:@"%@ matching search criteria (%d)", selectedGenus, [[genera objectAtIndex:i] count]]];
                
                break;
            }
        }*/
    }
}

-(int)sizeForIndex:(int)index
{
    int size = 100;
    
    if(index == 1)
    {
        size = 155;
    }
    else if(index == 0)
    {
        size = 300;
    }
    
    return size;
}

@end
