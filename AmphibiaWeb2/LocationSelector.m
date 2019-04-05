//
//  LocationSelector.m
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 11/4/12.
//  Copyright (c) 2012 Mel Roderick. All rights reserved.
//

#import "LocationSelector.h"

#import "OrderSelector.h"

@interface LocationSelector ()

@end

@implementation LocationSelector

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
    
    [coordSelector setDelegate:self];
    
    int mapType = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"mapType"];
    if(mapType == 0)
    {
        [map setMapType:MKMapTypeStandard];
    }
    else if(mapType == 1)
    {
        [map setMapType:MKMapTypeHybrid];
    }
    else
    {
        [map setMapType:MKMapTypeSatellite];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectorChanged:(id)sender {
    if(selector.selectedSegmentIndex == 0)
    {
        [coordSelector setHidden:YES];
    }
    else
    {
        [coordSelector setHidden:NO];
    }
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id ) annotation
{
    if(locChosen)
    {
        MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation1"];
        newAnnotation.pinColor = MKPinAnnotationColorPurple;
        newAnnotation.animatesDrop = YES;
        newAnnotation.canShowCallout = NO;
        [newAnnotation setSelected:YES animated:YES];
        return newAnnotation;
    }
    else
    {
        return [mapView viewForAnnotation:annotation];
    }
}

-(void)coordViewTouchedAtPoint:(CGPoint)point
{
    if(!locChosen)
    {
        locChosen = YES;
        
        loc = [map convertPoint:point toCoordinateFromView:coordSelector]; // converting point to lat-long
        
        marker = [[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:NULL];
        
        [map addAnnotation:marker];
        
        [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(segue) userInfo:nil repeats:NO];
    }
}

-(void)segue
{
    if(search != NULL)
    {
        [search sendLocation:loc];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self performSegueWithIdentifier:@"mapToTable" sender:self];
        
        // user has chosen location
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; // show networkActivityIndicator
    }
    
    locChosen = NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [map removeAnnotation:marker];
    
    [selector setSelectedSegmentIndex:0];
    
    [coordSelector setHidden:YES];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // sets defaultregion
    
    if(!mapFoundUser) //makes sure it was not already set
    {
        [map setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(180, 360))]; // sets center of map to userLocation
        ///defaultregion = map.region; // sets defaultregion
        mapFoundUser = YES; // tells the app defaultregion was set
    }
}

-(void)passSender:(Search *)sender
{
    search = sender;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[segue destinationViewController] passLocation:loc];
}

@end
