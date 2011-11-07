//
//  MFMapAnnotation.m
//  Overlay
//
//  Created by Matteo Gavagnin on 10/8/11.
//  Copyright (c) 2011  MobFarm s.a.s. All rights reserved.
//

#import "MFMapAnnotation.h"

@implementation MFMapAnnotation

@synthesize image;
@synthesize latitude;
@synthesize longitude;
@synthesize title;
@synthesize subtitle;
@synthesize callout;
@synthesize color;

- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [self.latitude doubleValue];
    theCoordinate.longitude = [self.longitude doubleValue];
    return theCoordinate; 
}

- (void)dealloc
{
    [image release];
    [super dealloc];
}

@end
