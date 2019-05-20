//
//  Search.m
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 11/4/12.
//  Copyright (c) 2012 Mel Roderick. All rights reserved.
//

#import "Search.h"

#import "LocationSelector.h"
#import "OrderSelector.h"

@interface Search ()

@end

@implementation Search

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
	
    countryCode = @"";
    [searchLocationLabel setText:@""];
    [scientificNameTextField setText:@""];
    [commonNameTextField setText:@""];
    [familyNameTextField setText:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scientificNameChanged:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)commonNameChanged:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)familyNameChanged:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)searchChooseLocationButtonPressed:(id)sender {
    ///[self performSegueWithIdentifier:@"searchToMap" sender:self];
}

-(IBAction)orderChanged:(id)sender
{
    /////
}

- (IBAction)searchClearLocationButtonPressed:(id)sender {
    countryCode = @"";
    [searchLocationLabel setText:@""];
}

- (IBAction)clearPageButtonPressed:(id)sender {
    countryCode = @"";
    [searchLocationLabel setText:@""];
    [scientificNameTextField setText:@""];
    [commonNameTextField setText:@""];
    [familyNameTextField setText:@""];
}

- (IBAction)searchButtonPressed:(id)sender {
    if([scientificNameTextField.text isEqualToString:@""] && [commonNameTextField.text isEqualToString:@""] && [familyNameTextField.text isEqualToString:@""] && [countryCode isEqualToString:@""])
    {
        /*
        alert = [[UIAlertView alloc] initWithTitle:@"No Information Error" message:@"You must fill in at least one of the search catagories to continue" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        [alert show];*/
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Information Error" message:@"You must fill in at least one of the search catagories to continue" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:nil]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        [self performSegueWithIdentifier:@"searchToTable" sender:self];
    }
}

-(void)sendLocation:(CLLocationCoordinate2D)loc
{
    locationFinder *locFin = [[locationFinder alloc] init];
    [locFin setDelegate:self];
    [locFin findLocationGivenPoint:loc];
}

-(void)locationFoundCounty:(NSString *)countryname andCode:(NSString *)countrycode withState:(NSString *)statecode withRegion:(NSString *)locregion
{
    if(countryname != NULL)
    {
        searchLocationLabel.text = countryname;
    }
    if(countryCode != NULL)
    {
        countryCode = countrycode;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; // stop showing networkActivityIndicator
    
    if(countryname == NULL)
    {
        /*
        alert = [[UIAlertView alloc] initWithTitle:@"Continent Error" message:@"Selected location was not on a continent" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try Another", nil];
        [alert show];*/
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Continent Error" message:@"Selected location was not on a continent" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:nil]];
        // put in action?
        [alertController addAction:[UIAlertAction actionWithTitle:@"Try Another" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"searchToMap"])
    {
        [(LocationSelector *)[segue destinationViewController] passSender:self];
    }
    else
    {
        [(OrderSelector *)[segue destinationViewController] passName:scientificNameTextField.text withCommonName:commonNameTextField.text withFamilyName:familyNameTextField.text andCountryCode:countryCode];
    }
}

@end
