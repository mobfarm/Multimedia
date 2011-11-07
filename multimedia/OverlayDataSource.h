//
//  OverlayDataSource.h
//  Overlay
//
//  Created by Matteo Gavagnin on 11/1/11.
//  Copyright (c) 2011 MobFarm s.a.s. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <FastPdfKit/FastPdfKit.h>

@protocol OverlayDataSourceDelegate <NSObject>
@optional
- (void)setGesturesDisabled:(BOOL)disabled;
@end

@interface OverlayDataSource : NSObject <FPKOverlayViewDataSource, MKMapViewDelegate>{
    BOOL isUp;
    NSMutableArray *overlays;
    NSMutableDictionary *overlaysFrames;
    MFDocumentViewController <OverlayDataSourceDelegate> * documentViewController;
}
@property(nonatomic, retain) NSMutableArray *overlays;
@property(nonatomic, retain) NSMutableDictionary *overlaysFrames;
@property(nonatomic, assign) MFDocumentViewController <OverlayDataSourceDelegate> * documentViewController;

- (UIView *)showAnnotationForOverlay:(BOOL)load withRect:(CGRect)rect andUri:(NSString *)uri onPage:(NSUInteger)page;
@end


