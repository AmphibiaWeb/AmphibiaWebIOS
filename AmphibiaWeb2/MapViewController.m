//
//  MapViewController.m
//  AmphibiaWeb2
//
//  Created by Mel Roderick on 11/4/12.
//  Copyright (c) 2012 Mel Roderick. All rights reserved.
//

#import "MapViewController.h"

#import "ZipKit.h"

@interface MapViewController ()

@end

@implementation MapViewController

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
    
    [self.navigationItem setTitle:name];
    
    map = [[REVClusterMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44)];
    [map setShowsUserLocation:YES];
    
    
    if([map respondsToSelector:@selector(setRotateEnabled:)])
    {
        [map setRotateEnabled:NO];
    }
    
#warning TODO Pitch?
    
    [self.view addSubview:map];
    [self.view sendSubviewToBack:map];
    [map setDelegate:self];
    
    [self setMap];
    [pointType setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"pointType"]];
    [mapType setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"mapType"]];
    
    int type = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"pointType"];
    
    kmlFin = [[kmlFinder alloc] init];
    [kmlFin setDelegate:self];
    pntFin = [[pointFinder alloc] init];
    [pntFin setDelegate:self];
    
    if(type != 2)
    {
        [kmlFin findKml:name];
    }
    if(type != 0)
    {
        //start finding speciment points
        [pntFin findPoints:name];
    }
    
    [activity startAnimating];
}

- (void)viewDidAppear:(BOOL)animated
{
    [popOutView setFrame:CGRectMake(0, self.view.frame.size.height, popOutView.frame.size.width, popOutView.frame.size.height)];
    
    [optionsButton setEnabled:YES];
}

-(void)setMap
{
    int type = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"mapType"];
    if(type == 0)
    {
        [map setMapType:MKMapTypeStandard];
    }
    else if(type == 1)
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

-(void)passName:(NSString *)inputName
{
    name = inputName;
}

- (IBAction)openOptions:(id)sender {
    if(!moving && !optionsOpen)
    {
        [popOutView setHidden:NO];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [popOutView setFrame:CGRectMake(0, self.view.frame.size.height - popOutView.frame.size.height, popOutView.frame.size.width, popOutView.frame.size.height)];
        [UIView commitAnimations];
        
        optionsOpen = YES;
        moving = YES;
    }
}

- (IBAction)closeOptions:(id)sender {
    if(!moving && optionsOpen)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [popOutView setFrame:CGRectMake(0, self.view.frame.size.height, popOutView.frame.size.width, popOutView.frame.size.height)];
        [UIView commitAnimations];
        
        moving = YES;
        optionsOpen = NO;
    }
}

- (IBAction)mapChanged:(id)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:mapType.selectedSegmentIndex forKey:@"mapType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self setMap];
}

- (IBAction)pointChanged:(id)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:pointType.selectedSegmentIndex forKey:@"pointType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if(pointType.selectedSegmentIndex == 0)
    {
        NSMutableArray *points = [[NSMutableArray alloc] initWithArray:[map annotations]];
        for(int i = (int)[points count] - 1 ; i >= 0 ; i--)
        {
            if([[points objectAtIndex:i] isKindOfClass:[MKUserLocation class]])
            {
                [points removeObjectAtIndex:i];
                break;
            }
        }
        [map removeAnnotationsAndCopies:points];
    }
    else if (pointType.selectedSegmentIndex == 2)
    {
        [map removeOverlays:map.overlays];
    }
    
    
    if(pointType.selectedSegmentIndex != 2 && [map.overlays count] < 1)
    {
        if(savedOverlays != NULL)
        {
            [map addOverlays:savedOverlays];
        }
        else
        {
            [kmlFin findKml:name];
            
            [activity startAnimating];
        }
    }
    
    if(pointType.selectedSegmentIndex != 0 && [map.annotations count] < 2)
    {
        if(savedPoints != NULL)
        {
            [map addAnnotations:savedPoints];
        }
        else
        {
            [pntFin findPoints:name];
            
            [activity startAnimating];
        }
    }
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    moving = NO;
    if(!optionsOpen)
    {
        [popOutView setHidden:YES];
    }
}

-(void)pointsFound:(NSArray *)foundpoints
{
    savedPoints = foundpoints;
    
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"pointType"] != 1 || ![kmlFin isLoading])
    {
        [activity stopAnimating];
        
        [self updateMap];
    }
}

-(void)kmlFound:(NSMutableData *)kmlData
{
    /*NSString *archivePath = [[NSBundle mainBundle] pathForResource:@"Acris_crepitans" ofType:@"kmz"];
     ZKDataArchive *archive = [ZKDataArchive archiveWithArchivePath:archivePath];
     [archive inflateAll];*/
    
    /*ZKDataArchive *archive = [ZKDataArchive archiveWithArchiveData:kmlData];
    
    [archive inflateAll];
    
    NSDictionary *fileDict = [archive.inflatedFiles objectAtIndex:0];
    
    NSData *fileData = [[NSData alloc] initWithData:[fileDict objectForKey:ZKFileDataKey]];*/
    
    // Locate the path to the route.kml file in the application's bundle
    // and parse it with the KMLParser.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Ascaphus_truei" ofType:@"kml"];
    NSURL *url = [NSURL fileURLWithPath:path];
    kml = [[KMLParser alloc] initWithURL:url];
    [kml parseKML];
    
    // Add all of the MKOverlay objects parsed from the KML file to the map.
    NSArray *overlays = [kml overlays];
    [map addOverlays:overlays];
    
    // Add all of the MKAnnotation objects parsed from the KML file to the map.
    NSArray *annotations = [kml points];
    [map addAnnotations:annotations];
    
    // Walk the list of overlays and annotations and create a MKMapRect that
    // bounds all of them and store it into flyTo.
    MKMapRect flyTo = MKMapRectNull;
    for (id <MKOverlay> overlay in overlays) {
        if (MKMapRectIsNull(flyTo)) {
            flyTo = [overlay boundingMapRect];
        } else {
            flyTo = MKMapRectUnion(flyTo, [overlay boundingMapRect]);
        }
    }
    
    for (id <MKAnnotation> annotation in annotations) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(flyTo)) {
            flyTo = pointRect;
        } else {
            flyTo = MKMapRectUnion(flyTo, pointRect);
        }
    }
    
    // Position the map so that all overlays and annotations are visible on screen.
    map.visibleMapRect = flyTo;
    
    // Add all of the MKAnnotation objects parsed from the KML file to the map.
    /*NSArray *annotations = [kml points];
     [map addAnnotations:annotations];*////
    
    /*savedOverlays = [kml overlays];
    
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"pointType"] != 1 || ![pntFin isLoading])
    {
        [activity stopAnimating];
        
        [self updateMap];
    }*/////
}

-(void)updateMap
{
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"pointType"] != 0)
    {
        //when a point is found from AWeb, add it to the map
        [map addAnnotations:savedPoints];
    }
    else if([[NSUserDefaults standardUserDefaults] integerForKey:@"pointType"] != 2)
    {
        // Add all of the MKOverlay objects parsed from the KML file to the map.
        NSArray *overlays = savedOverlays;
        [map addOverlays:overlays];
    }
    
    // Walk the list of overlays and annotations and create a MKMapRect that
    // bounds all of them and store it into flyTo.
    MKMapRect flyTo = MKMapRectNull;
    for (id <MKOverlay> overlay in map.overlays) {
        if (MKMapRectIsNull(flyTo)) {
            flyTo = [overlay boundingMapRect];
        } else {
            flyTo = MKMapRectUnion(flyTo, [overlay boundingMapRect]);
        }
    }
    
    for (id <MKAnnotation> annotation in map.annotations) {
        if([annotation class] != [MKUserLocation class])
        {
            MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
            MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
            if (MKMapRectIsNull(flyTo)) {
                flyTo = pointRect;
            } else {
                flyTo = MKMapRectUnion(flyTo, pointRect);
            }
        }
    }
    
    float margin = flyTo.size.width/5;
    
    flyTo.origin.x -= margin;
    flyTo.origin.y -= margin;
    flyTo.size.width += margin*2;
    flyTo.size.height += margin*2;
    
    // Position the map so that all overlays and annotations are visible on screen.
    map.visibleMapRect = flyTo;
}
/*
-(MKOverlayView *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKOverlayView *mkover = [kml viewForOverlay:overlay];
    [mkover setAlpha:1];
    [mkover setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [mkover setNeedsDisplay];
    return mkover;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKOverlayView *mkover = [kml viewForOverlay:overlay];
    [mkover setAlpha:1];
    [mkover setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [mkover setNeedsDisplay];
    return mkover;
    
    ///return [kml viewForOverlay:overlay];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    return [kml viewForAnnotation:annotation];
}*/

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKOverlayView *view = [kml viewForOverlay:overlay];
    [(MKPolygonView *)view setFillColor:[UIColor redColor]];
    return view;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    return [kml viewForAnnotation:annotation];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
