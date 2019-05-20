//
//  OrderSelector.m
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 11/3/12.
//  Copyright (c) 2012 Mel Roderick. All rights reserved.
//

#import "OrderSelector.h"

#import "Amphibian.h"
#import "AmphibianCell.h"
#import "Table.h"
#import "PictureViewController.h"

@interface OrderSelector ()

@end

@implementation OrderSelector

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
    
    
    if(usingSearch)
    {
        AmphibiaFinder *ampfin = [[AmphibiaFinder alloc] init];
        
        ampfin->view = self;
        
        [ampfin setDelegate:self];
        
        [ampfin findAmphibiaWithscientificName:name withcommonName:common withfamilyName:family withorderName:@"" countryCode:cCode];
    }
    else
    {
        locfin = [[locationFinder alloc] init];
        
        [locfin setDelegate:self];
        
        locfin.master = self;
        
        if(usingPassedLoc)
        {
            //start finding location user loc
            [locfin findLocationGivenPoint:loc];
        }
        else
        {
            //start finding your location
            [locfin findLocation];
        }
    }
    
     [activity startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int num = 0;
    if([anuraData count] > 0)
    {
        num++;
    }
    if([caudataData count] > 0)
    {
        num++;
    }
    if([gymnophionaData count] > 0)
    {
        num++;
    }
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:28]];
    }
    
    if(indexPath.row == 0 && [anuraData count] > 0)
    {
        if([[NSUserDefaults standardUserDefaults] integerForKey:@"titleSelector"] == 0)
        {
            [cell.textLabel setText:@"Anura"];
        }
        else {
            [cell.textLabel setText:@"Frogs/Toads"];
        }
    }
    else if((indexPath.row == 0  || indexPath.row == 1) && [caudataData count] > 0)
    {
        if([[NSUserDefaults standardUserDefaults] integerForKey:@"titleSelector"] == 0)
        {
            [cell.textLabel setText:@"Caudata"];
        }
        else {
            [cell.textLabel setText:@"Salamanders"];
        }
    }
    else
    {
        if([[NSUserDefaults standardUserDefaults] integerForKey:@"titleSelector"] == 0)
        {
            [cell.textLabel setText:@"Gymnophiona"];
        }
        else {
            [cell.textLabel setText:@"Caecilians"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    index = indexPath;
    
    [table deselectRowAtIndexPath:index animated:YES];
    
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"browseSelector"] == 0)
    {
        [self performSegueWithIdentifier:@"toTable" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"toScroll" sender:self];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return 85;
    }
    else
    {
        return 45;
    }
}

-(void)locationFoundCounty:(NSString *)countryname andCode:(NSString *)countrycode withState:(NSString *)statecode withRegion:(NSString *)locregion
{
    AmphibiaFinder *ampfin = [[AmphibiaFinder alloc] init];
    [ampfin setDelegate:self];
    [ampfin findAmphibia:countrycode withState:statecode];
    
    //sets yourArea string
    if(locregion == NULL)
    {
        yourArea = countryname;
    }
    else
    {
        yourArea = locregion;
    }
}

-(void)anuraFound:(NSArray *)anura withCaudata:(NSArray *)caudata withGymnophiona:(NSArray *)gymnophiona
{
    //amphibia were found, now show the table
    
    anuraData = [[NSArray alloc] initWithArray:anura];
    caudataData = [[NSArray alloc] initWithArray:caudata];
    gymnophionaData = [[NSArray alloc] initWithArray:gymnophiona];
    ///[table scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    //setting mainthread
    dispatch_async(dispatch_get_main_queue(), ^{[self->table reloadData];});
    dispatch_async(dispatch_get_main_queue(), ^{[self->activity stopAnimating];});
    // [activity stopAnimating];
    
    if([anuraData count] == 0 && [caudataData count] == 0 && [gymnophiona count] == 0) // checks if any amphibia were found; if not, show error message
    {
        NSString *message;
        NSString *button;
        if(usingPassedLoc)
        {
            message = @"There are no amphibians at this location";
            button = @"Back to Map";
        }
        else if(usingSearch)
        {
            message = @"There are no amphibians matching search criteria";
            button = @"Back to Search";
        }
        else
        {
            message = @"There are no amphibians at your location";
            button = @"Back to Menu";
        }
        
        /*
        alert = [[UIAlertView alloc] initWithTitle:@"No Amphibians Error" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:button, nil];
        [alert setDelegate:self];
        [alert show];*/
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Amphibians Error" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;});
 // stop showing networkActivityIndicator
    
    dispatch_async(dispatch_get_main_queue(), ^{[self->activity stopAnimating];});
}

/*
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [[self navigationController] popViewControllerAnimated:YES];
    }
}
 */

-(void)passLocation:(CLLocationCoordinate2D)location
{
    loc = location;
    
    usingPassedLoc = YES;
}

-(void)passName:(NSString *)nameString withCommonName:(NSString *)commonName withFamilyName:(NSString *)familyName andCountryCode:(NSString *)countryCode
{
    name = nameString;
    common = commonName;
    family = familyName;
    cCode = countryCode;
    
    usingSearch = YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *tempName;
    
    if(index.row == 0 && [anuraData count] > 0)
    {
        if([[NSUserDefaults standardUserDefaults] integerForKey:@"titleSelector"] == 0)
        {
            tempName = @"Anura";
        }
        else {
            tempName = @"Frogs and Toads";
        }
        
        if([[NSUserDefaults standardUserDefaults] integerForKey:@"browseSelector"] == 0)
        {
            [[segue destinationViewController] passData:anuraData];
        }
        else
        {
            [[segue destinationViewController] passData:anuraData andLocation:yourArea];
        }
        
        if(usingSearch)
        {
            [[segue destinationViewController] passTitle:[NSString stringWithFormat:@"%@ with search criteria (%lu)", tempName,(unsigned long)[anuraData count]]];
        }
        else
        {
            [[segue destinationViewController] passTitle:[NSString stringWithFormat:@"%@ in %@ (%lu)", tempName, yourArea, (unsigned long)[anuraData count]]];
        }
    }
    else if((index.row == 0  || index.row == 1) && [caudataData count] > 0)
    {
        if([[NSUserDefaults standardUserDefaults] integerForKey:@"titleSelector"] == 0)
        {
            tempName = @"Caudata";
        }
        else {
            tempName = @"Salamanders";
        }
        
        if([[NSUserDefaults standardUserDefaults] integerForKey:@"browseSelector"] == 0)
        {
            [[segue destinationViewController] passData:caudataData];
        }
        else
        {
            [[segue destinationViewController] passData:caudataData andLocation:yourArea];
        }
        
        if(usingSearch)
        {
            [[segue destinationViewController] passTitle:[NSString stringWithFormat:@"%@ with search criteria (%lu)", tempName,(unsigned long)[caudataData count]]];
        }
        else
        {
            [[segue destinationViewController] passTitle:[NSString stringWithFormat:@"%@ in %@ (%lu)", tempName, yourArea, (unsigned long)[caudataData count]]];
        }
    }
    else
    {
        if([[NSUserDefaults standardUserDefaults] integerForKey:@"titleSelector"] == 0)
        {
            tempName = @"Gymnophiona";
        }
        else {
            tempName = @"Caecilians";
        }
        
        if([[NSUserDefaults standardUserDefaults] integerForKey:@"browseSelector"] == 0)
        {
            [[segue destinationViewController] passData:gymnophionaData];
        }
        else
        {
            [[segue destinationViewController] passData:gymnophionaData andLocation:yourArea];
        }
        
        if(usingSearch)
        {
            [[segue destinationViewController] passTitle:[NSString stringWithFormat:@"%@ with search criteria (%lu)", tempName,(unsigned long)[gymnophionaData count]]];
        }
        else
        {
            [[segue destinationViewController] passTitle:[NSString stringWithFormat:@"%@ in %@ (%lu)", tempName, yourArea, (unsigned long)[gymnophionaData count]]];
        }
    }
}

@end
