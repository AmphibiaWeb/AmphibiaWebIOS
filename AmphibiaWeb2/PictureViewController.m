//
//  PictureViewController.m
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 11/4/12.
//  Copyright (c) 2012 Mel Roderick. All rights reserved.
//

#import "PictureViewController.h"

#import "GenusArray.h"
#import "SecondPictureVC.h"
#import "AmphibianCollectionCell.h"

@interface PictureViewController ()

@end

@implementation PictureViewController

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
    [collection updateForSize:(unsigned int)[self sizeForIndex:(unsigned int)selector.selectedSegmentIndex]];
}

-(void)passData:(NSArray *)data andLocation:(NSString *)location
{
    loc = location;
    
    genera = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < [data count]; i++) {
        NSArray *names = [[[data objectAtIndex:i] getName] componentsSeparatedByString:@" "];
        
        int slot = -1;
        
        for(int n = (unsigned int)[genera count] - 1 ; n >= 0 ; n--)
        {
            if([[[genera objectAtIndex:n] getGenusName] isEqualToString:[names objectAtIndex:0]])
            {
                slot = n;
                
                [[genera objectAtIndex:n] addObject:[data objectAtIndex:i]];
                
                break;
            }
        }
        
        if(slot == -1)
        {
            GenusArray *genus = [[GenusArray alloc] initWithGenus:[names objectAtIndex:0]];
            [genus addObject:[data objectAtIndex:i]];
            [genera addObject:genus];
        }
    }
    
    genera = [self quickSort:genera];
}

-(void)passTitle:(NSString *)string
{
    title = string;
}

-(NSMutableArray *)quickSort:(NSMutableArray *)array
{
    if([array count] <= 1)
    {
        return array;
    }
    else {
        int slot = (unsigned int)[array count]/2;
        
        id pivot = [array objectAtIndex:slot];
        [array removeObjectAtIndex:slot];
        
        NSMutableArray *less = [[NSMutableArray alloc] init];
        NSMutableArray *greater = [[NSMutableArray alloc] init];
        
        for(int i = (unsigned int)[array count] - 1 ; i >= 0 ; i--)
        {
            if([[[array objectAtIndex:i] getGenusName] compare:[pivot getGenusName]] == NSOrderedDescending)
            {
                [greater addObject:[array objectAtIndex:i]];
                [array removeObjectAtIndex:i];
            }
            else
            {
                [less addObject:[array objectAtIndex:i]];
                [array removeObjectAtIndex:i];
            }
        }
        
        array = [self quickSort:less];
        [array addObject:pivot];
        [array  addObjectsFromArray:[self quickSort:greater]];
        
        return [NSMutableArray arrayWithArray:array];
    }
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
        [collection passGenera:genera andTitle:title andSize:[self sizeForIndex:(unsigned int)selector.selectedSegmentIndex] andLoc:loc];
        
        genera = NULL;
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
