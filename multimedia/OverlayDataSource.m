//
//  OverlayDataSource.m
//  Overlay
//
//  Created by Matteo Gavagnin on 11/1/11.
//  Copyright (c) 2011 MobFarm s.a.s. All rights reserved.
//

#import "OverlayDataSource.h"
#import <QuartzCore/QuartzCore.h>
#import <FastPdfKit/FPKURIAnnotation.h>
#import "MFMapAnnotation.h"
#import "YouTubeView.h"

@implementation OverlayDataSource
@synthesize overlays, overlaysFrames, documentViewController;

- (UIView *)showAnnotationForOverlay:(BOOL)load withRect:(CGRect)rect andUri:(NSString *)uri onPage:(NSUInteger)page{
    NSArray *arrayParameter = nil;
	NSString *uriType = nil;
    NSString *uriResource = nil;
    NSArray *arrayAfterResource = nil;
    NSArray *arrayArguments = nil;
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    UIView *retVal = nil;
    
    arrayParameter = [uri componentsSeparatedByString:@"://"];
	if([arrayParameter count] > 0){
        
        uriType = [NSString stringWithFormat:@"%@", [arrayParameter objectAtIndex:0]];
        // NSLog(@"%@", uriType);
        
        if([arrayParameter count] > 1){
            uriResource = [NSString stringWithFormat:@"%@", [arrayParameter objectAtIndex:1]];
            NSLog(@"Uri Resource: %@", uriResource);
            
            arrayAfterResource = [uriResource componentsSeparatedByString:@"?"];
            if([arrayAfterResource count] > 0)
                [parameters setObject:[arrayAfterResource objectAtIndex:0] forKey:@"resource"];
            if([arrayAfterResource count] == 2){
                arrayArguments = [[arrayAfterResource objectAtIndex:1] componentsSeparatedByString:@"&"];
                for (NSString *param in arrayArguments) {
                    NSArray *keyAndObject = [param componentsSeparatedByString:@"="];
                    if ([keyAndObject count] == 2) {
                        [parameters setObject:[[keyAndObject objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[keyAndObject objectAtIndex:0]];
                        // NSLog(@"%@ = %@", [keyAndObject objectAtIndex:0], [parameters objectForKey:[keyAndObject objectAtIndex:0]]);
                    }
                }    
            }
        } 
   
            
        // GOTO PAGE
        if ([uriType isEqualToString:@"goto"]) {     //      goto://?page=5&zoom=2.0&x=40.0&y=40.0&w=100.0&h=100.0
            if (!load) {                
                CGRect zoomRect = CGRectMake([[parameters objectForKey:@"x"] floatValue], [[parameters objectForKey:@"y"] floatValue], [[parameters objectForKey:@"w"] floatValue], [[parameters objectForKey:@"h"] floatValue]);
                [documentViewController setPage:[[parameters objectForKey:@"page"] intValue] withZoomOfLevel:[[parameters objectForKey:@"zoom"] floatValue] onRect:zoomRect];
            } else {
                UIView* view = [[UIView alloc] initWithFrame:[documentViewController convertRect:rect toViewFromPage:page]]; 
                UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reload.png"]];
                // Center the placeholder image;                    
                [image setFrame:CGRectMake(view.frame.size.width/2.0-image.frame.size.width/2.0, view.frame.size.height/2.0-image.frame.size.height/2.0, image.frame.size.width, image.frame.size.height)];
                [view addSubview:image];
                [view setAutoresizesSubviews:YES];
                [image release];
                retVal = view;
            }      
        }            
        // MAP
        else if ([uriType isEqualToString:@"map"]){   //        map://hybrid[hybrid,satellite,standard]?lat=37.0&lon=-122.0&latd=0.11&lond=0.10&pinlat=37.0&pinlon=-122.0&pintitle=Titolo&pinsub=Sottotolo&pincolor=[red,green,purple]&user=YES
                        
            //  map://hybrid?lat=37.0&lon=-122.0&latd=0.11&lond=0.10&pinlat=37.0&pinlon=-122.0&pintitle=Titolo&pinsub=Sottotolo&pincolor=purple&user=YES
            MKMapView *map = [[MKMapView alloc] initWithFrame:[documentViewController convertRect:rect toOverlayFromPage:page]];
            [map setDelegate:self];
            MKCoordinateRegion newRegion;
            newRegion.center.latitude = [[parameters objectForKey:@"lat"] doubleValue];
            newRegion.center.longitude = [[parameters objectForKey:@"lon"] doubleValue];
            newRegion.span.latitudeDelta = [[parameters objectForKey:@"latd"] floatValue];
            newRegion.span.longitudeDelta = [[parameters objectForKey:@"lond"] floatValue];
            
            [map setRegion:newRegion animated:YES];
            MKMapType type = MKMapTypeStandard;
            if ([[parameters objectForKey:@"resource"] isEqualToString:@"hybrid"])
                type = MKMapTypeHybrid;
            else if ([[parameters objectForKey:@"resource"] isEqualToString:@"satellite"])
                type = MKMapTypeSatellite;
            else if ([[parameters objectForKey:@"resource"] isEqualToString:@"standard"])
                type = MKMapTypeStandard;
            
            if([[parameters objectForKey:@"user"] boolValue])
                [map setShowsUserLocation:YES];
            
            
            if([parameters objectForKey:@"pinlat"]){
                MFMapAnnotation *annotation = [[MFMapAnnotation alloc] init];
                annotation.latitude = [NSNumber numberWithDouble:[[parameters objectForKey:@"pinlat"] doubleValue]];
                annotation.longitude = [NSNumber numberWithDouble: [[parameters objectForKey:@"pinlon"] doubleValue]];            
                
                annotation.callout = NO;
                
                if([parameters objectForKey:@"pintitle"]){
                    annotation.title = [parameters objectForKey:@"pintitle"];
                    annotation.subtitle = [parameters objectForKey:@"pinsub"];
                    annotation.callout = YES;
                }
                
                MKPinAnnotationColor color = MKPinAnnotationColorRed;
                if ([[parameters objectForKey:@"pincolor"] isEqualToString:@"red"])
                    color = MKPinAnnotationColorRed;
                else if ([[parameters objectForKey:@"pincolor"] isEqualToString:@"green"])
                    color = MKPinAnnotationColorGreen;
                else if ([[parameters objectForKey:@"pincolor"] isEqualToString:@"purple"])
                    color = MKPinAnnotationColorPurple;
                
                [annotation setColor:color];                
                [map addAnnotation:annotation];
                [annotation release];            
            }
            
            [map setMapType:type];
            retVal = map;
        }
        
        // YouTube Video    
        // utube://gczw0WRmHQU    
         else if ([uriType isEqualToString:@"utube"]){            
            if (load){
                YouTubeView *youTubeView = [[YouTubeView alloc] 
                                            initWithStringAsURL:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", uriResource]
                                            frame:[documentViewController convertRect:rect toViewFromPage:page]];
                retVal = youTubeView;
            }
        }
    }
    
    return retVal;
}

#pragma -
#pragma FPKOverlayViewDataSource

- (void)documentViewController:(MFDocumentViewController *)dvc willFocusOnPage:(NSUInteger)page{
    NSLog(@"Will focus on page: %i", page);
}

- (NSArray *)documentViewController:(MFDocumentViewController *)dvc overlayViewsForPage:(NSUInteger)page{
    NSLog(@"Overlay Views for Page: %i", page);
    
    [overlays removeAllObjects];
    if ([overlaysFrames objectForKey:[NSString stringWithFormat:@"%i", page]]) {
        [[overlaysFrames objectForKey:[NSString stringWithFormat:@"%i", page]] removeAllObjects];
    } else {
        [overlaysFrames setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%i", page]];
    }
    
    NSArray *annotations = [[documentViewController document] uriAnnotationsForPageNumber:page];
    
    for (FPKURIAnnotation *ann in annotations) {
        UIView *view = [self showAnnotationForOverlay:YES withRect:[ann rect] andUri:[ann uri] onPage:page];
        
        if(view != nil){
            [view setFrame:[documentViewController convertRect:view.frame fromOverlayToPage:page]];
            [overlays addObject:view];
            [[overlaysFrames objectForKey:[NSString stringWithFormat:@"%i", page]] addObject:[NSValue valueWithCGRect:view.frame]];
        }
        
        [view release];
    }
    
    return [NSArray arrayWithArray:overlays];
}

- (CGRect)documentViewController:(MFDocumentViewController *)dvc rectForOverlayView:(UIView *)view onPage:(NSUInteger)page{
    if([overlays indexOfObject:view] == NSNotFound)
        NSLog(@"NOT FOUND");
    
    CGRect rect;
    if([[overlaysFrames objectForKey:[NSString stringWithFormat:@"%i", (int)page]] count] >= [overlays indexOfObject:view]){
        [[[overlaysFrames objectForKey:[NSString stringWithFormat:@"%i", page]] objectAtIndex:[overlays indexOfObject:view]] getValue:&rect];
    }

    return rect;
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // handle our two custom annotations
    //
    if ([annotation isKindOfClass:[MFMapAnnotation class]]) // for Golden Gate Bridge
    {
        // try to dequeue an existing pin view first
        static NSString* MapAnnotationIdentifier = @"mapAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [theMapView dequeueReusableAnnotationViewWithIdentifier:MapAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:MapAnnotationIdentifier] autorelease];
            customPinView.pinColor = [(MFMapAnnotation *)annotation color];
            
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = [(MFMapAnnotation *)annotation callout];
            
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    
    return nil;
}

- (void)dealloc {
    [overlays release];
    [overlaysFrames release];    
    
	[super dealloc];
}

@end
