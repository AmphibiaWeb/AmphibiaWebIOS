//
//  CollectionViewController.m
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 6/11/13.
//  Copyright (c) 2013 Mel Roderick. All rights reserved.
//

#import "CollectionViewController.h"

#import "SpeciesAccount.h"
#import "SecondPictureVC.h"
#import "AmphibianCollectionCell.h"
#import "HeaderCell.h"
#import "GenusArray.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)passGenera:(NSMutableArray *)genera andTitle:(NSString *)text andSize:(float)inSize andLoc:(NSString *)location
{
    title = text;
    
    data = genera;
    
    size = inSize;
    
    loc = location;
    
    genus = YES;
}

-(void)passSpecies:(NSMutableArray *)species andTitle:(NSString *)text andSize:(float)inSize
{
    title = text;
    
    data = species;
    
    size = inSize;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [data count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    //
    AmphibianCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"AmCell" forIndexPath:indexPath];
    
    NSData *imageData;
    
    if(genus)
    {
        cell.title.text = [[data objectAtIndex:indexPath.row] getGenusName];
        
        imageData = (NSData *)[images objectForKey:[[(NSArray *)[data objectAtIndex:indexPath.row] objectAtIndex:0] getName]];
    }
    else
    {
        cell.title.text = [[data objectAtIndex:indexPath.row] getName];
        
        imageData = (NSData *)[images objectForKey:[[data objectAtIndex:indexPath.row] getName]];
    }
    
    if(imageData == NULL)
    {
        if(genus)
        {
            [cell.image findImage:[(NSArray *)[data objectAtIndex:indexPath.row] objectAtIndex:0]];
        }
        else
        {
            [cell.image findImage:[data objectAtIndex:indexPath.row]];
        }
        
        [cell setDelegate:self];
        
        [cell.image setDelegate:cell];
    }
    else
    {
        [cell.image setImageFromData:imageData];
    }
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(size, size*4/5);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    ///if([kind isEqualToString:@"UICollectionElementKindSectionHeader"])
    
    HeaderCell *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    [header.title setText:title];
    
    return header;
}

-(void)imageLoaded:(NSData *)imageData andID:(NSString *)identification
{
   [images setValue:imageData forKey:identification];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"nextScroll"])
    {
        int selectedIndex = (int)[[[self.collectionView indexPathsForSelectedItems] objectAtIndex:0] row];
        
        [(SecondPictureVC *)[segue destinationViewController] passData:[data objectAtIndex:selectedIndex]];
        
        if(loc == NULL)
        {
            [[segue destinationViewController] passTitle:[NSString stringWithFormat:@"%@ matching search criteria (%lu)", [[data objectAtIndex:selectedIndex] getGenusName], (unsigned long)[(NSArray *)[data objectAtIndex:selectedIndex] count]]];
        }
        else
        {
            [[segue destinationViewController] passTitle:[NSString stringWithFormat:@"%@ in %@ (%lu)", [[data objectAtIndex:selectedIndex] getGenusName], loc, (unsigned long)[(NSArray *)[data objectAtIndex:selectedIndex] count]]];
        }
    }
    else if([[segue identifier] isEqualToString:@"speciesPage"])
    {
        NSIndexPath *index = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        
        [(SpeciesAccount *)[segue destinationViewController] passAmphibian:[data objectAtIndex:index.row] andImage:[[(AmphibianCollectionCell *)[self.collectionView cellForItemAtIndexPath:index] image] image]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    images = [[NSMutableDictionary alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.collectionView setContentInset:UIEdgeInsetsMake(64, 0.0, 44, 0.0)];
    self.collectionView.contentOffset = CGPointMake(0.0, -64);
    [self.collectionView setScrollIndicatorInsets:UIEdgeInsetsMake(64, 0.0, 44, 0.0)];
}

-(void)updateForSize:(float)inSize
{
    size = inSize;
    
    [self.collectionView performBatchUpdates:nil completion:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
