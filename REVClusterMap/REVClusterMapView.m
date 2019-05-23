
//
//  
//    ___  _____   ______  __ _   _________ 
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_| 
//
//  Created by Bart Claessens. bart (at) revolver . be
//

#import "REVClusterMapView.h"
#import "REVClusterManager.h"
#import "REVClusterAnnotationView.h"

@interface REVClusterMapView (Private)
- (BOOL) mapViewDidZoom;
@end

@implementation REVClusterMapView

@synthesize minimumClusterLevel;
@synthesize blocks;
@synthesize delegate;


- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        annotationsCopy = nil;
        
        self.minimumClusterLevel = 100000;
        self.blocks = 4;
        
        super.delegate = self;
        
        zoomLevel = self.visibleMapRect.size.width * self.visibleMapRect.size.height;
    }
    return self;
}

/*
-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if( [delegate respondsToSelector:@selector(mapView:viewForOverlay:)] )
    {
        return [delegate mapView:mapView viewForOverlay:overlay];
    }
    return nil;
}
*/

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    
    if( [delegate respondsToSelector:@selector(mapView:rendererForOverlay:)] )
    {
        return [delegate mapView:mapView rendererForOverlay:overlay];
    }
    return nil;
}


    
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    /*
    if( [delegate respondsToSelector:@selector(mapView:viewForAnnotation:)] )
    {
        return [delegate mapView:mapView viewForAnnotation:annotation];
    } 
    return nil;
     */
    if([annotation class] != REVClusterPin.class) {
		//userLocation = annotation;
		return nil;
	}
    
    REVClusterPin *pin = (REVClusterPin *)annotation;
    
    MKAnnotationView *annView;
    
    if( [pin nodeCount] > 0 ){
        annView = (REVClusterAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"cluster"];
        
        if( !annView )
        {
            //annView = (REVClusterAnnotationView*)[[[REVClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"cluster"] autorelease];
            annView = (REVClusterAnnotationView*)[[REVClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"cluster"];
        }
        
        annView.image = [UIImage imageNamed:@"cluster.png"];
        [(REVClusterAnnotationView*)annView setClusterText:[NSString stringWithFormat:@"%lu",(unsigned long)[pin nodeCount]]];
        [annView setFrame:CGRectMake(annView.frame.origin.x, annView.frame.origin.y, 36, 36)];
        annView.canShowCallout = YES;
    } else {
        annView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
        
        if( !annView )
        {
            //annView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"] autorelease];
            annView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
        }
        
        annView.image = [UIImage imageNamed:@"greenPin.png"];
        [annView setFrame:CGRectMake(annView.frame.origin.x, annView.frame.origin.y, 54, 60)];
        annView.canShowCallout = YES;   
    }
    return annView;
}


- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    if( [delegate respondsToSelector:@selector(mapView:regionWillChangeAnimated:)] )
    {
        [delegate mapView:mapView regionWillChangeAnimated:animated];
    } 
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    if( [delegate respondsToSelector:@selector(mapViewWillStartLoadingMap:)] )
    {
        [delegate mapViewWillStartLoadingMap:mapView];
    }
}
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    if( [delegate respondsToSelector:@selector(mapViewDidFinishLoadingMap:)] )
    {
        [delegate mapViewDidFinishLoadingMap:mapView];
    }
}
- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    if( [delegate respondsToSelector:@selector(mapViewDidFailLoadingMap:withError:)] )
    {
        [delegate mapViewDidFailLoadingMap:mapView withError:error];
    }
}
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    if( [delegate respondsToSelector:@selector(mapView:didAddAnnotationViews:)] )
    {
        [delegate mapView:mapView didAddAnnotationViews:views];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if( [delegate respondsToSelector:@selector(mapView:annotationView:calloutAccessoryControlTapped:)] )
    {
        [delegate mapView:mapView annotationView:view calloutAccessoryControlTapped:control];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if( [delegate respondsToSelector:@selector(mapView:didSelectAnnotationView:)] )
    {
        [delegate mapView:mapView didSelectAnnotationView:view];
    }
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if( [delegate respondsToSelector:@selector(mapView:didDeselectAnnotationView:)] )
    {
        [delegate mapView:mapView didDeselectAnnotationView:view];
    }
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
    if( [delegate respondsToSelector:@selector(mapViewWillStartLocatingUser:)] )
    {
        [delegate mapViewWillStartLocatingUser:mapView];
    }
}
- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
    if( [delegate respondsToSelector:@selector(mapViewDidStopLocatingUser:)] )
    {
        [delegate mapViewDidStopLocatingUser:mapView];
    }
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if( [delegate respondsToSelector:@selector(mapView:didUpdateUserLocation:)] )
    {
        [delegate mapView:mapView didUpdateUserLocation:userLocation];
    }
}
- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    if( [delegate respondsToSelector:@selector(mapView:didFailToLocateUserWithError:)] )
    {
        [delegate mapView:mapView didFailToLocateUserWithError:error];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState 
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if( [delegate respondsToSelector:@selector(mapView:annotationView:didChangeDragState:fromOldState:)] )
    {
        [delegate mapView:mapView annotationView:view didChangeDragState:newState fromOldState:oldState];
    }
}

// Called after the provided overlay views have been added and positioned in the map.
/*
- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews
{
    if( [delegate respondsToSelector:@selector(mapView:didAddOverlayViews:)] )
    {
        [delegate mapView:mapView didAddOverlayViews:overlayViews];
    }
}
*/

- (void)mapView:(MKMapView *)mapView didAddOverlayRenderers:(nonnull NSArray<MKOverlayRenderer *> *)renderers{
    if( [delegate respondsToSelector:@selector(mapView:didAddOverlayRenderers:)] )
    {
        [delegate mapView:mapView didAddOverlayRenderers:renderers];
    }
}


- (void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
    if( [self mapViewDidZoom] )
    {
        NSMutableArray *points = [[NSMutableArray alloc] initWithArray:[self annotations]];
        for(int i = (unsigned int)[points count] - 1 ; i >= 0 ; i--)
        {
            if([[points objectAtIndex:i] isKindOfClass:[MKUserLocation class]])////
            {
                [points removeObjectAtIndex:i];
            }
        }
        [self removeAnnotations:points];
        /*
        [super removeAnnotations:self.annotations];
        self.showsUserLocation = self.showsUserLocation;
         */
    }
    
    NSArray *add = [REVClusterManager clusterAnnotationsForMapView:self forAnnotations:annotationsCopy blocks:self.blocks minClusterLevel:self.minimumClusterLevel];
    //NSLog(@"count:: %i",[add count]);
    [super addAnnotations:add];
    
    if( [delegate respondsToSelector:@selector(mapView:regionDidChangeAnimated:)] )
    {
        [delegate mapView:mapView regionDidChangeAnimated:animated];
    }
}

- (BOOL) mapViewDidZoom
{
    
    if( zoomLevel == self.visibleMapRect.size.width * self.visibleMapRect.size.height )
    {
        zoomLevel = self.visibleMapRect.size.width * self.visibleMapRect.size.height;
        return NO;
    }
    zoomLevel = self.visibleMapRect.size.width * self.visibleMapRect.size.height;
    return YES;
}

- (void) addAnnotations:(NSArray *)annotations
{
    annotationsCopy = [annotations copy];
    
    NSArray *add = [REVClusterManager clusterAnnotationsForMapView:self forAnnotations:annotations blocks:self.blocks minClusterLevel:self.minimumClusterLevel];
    
    [super addAnnotations:add];
}


- (void) setMaximumClusterLevel:(NSUInteger)value
{
    if ( value > 419430 )
        minimumClusterLevel = 419430;
    else
        minimumClusterLevel = round(value);
}

- (void) setBlocks:(NSUInteger)value
{
    if( value > 1024 )
        blocks = 1024;
    else if ( value < 2 )
        blocks = 2;
    else 
        blocks = round(value);
    
}

-(void)removeAnnotationsAndCopies:(NSArray *)annotations
{
    [super removeAnnotations:annotations];
    annotationsCopy = [self annotations];
}

@end
