//
//  ReaderViewControllerSubclass.h
//  multimedia
//
//  Created by Matteo Gavagnin on 11/7/11.
//  Copyright (c) 2011 MobFarm S.r.l. All rights reserved.
//

#import <FastPdfKit/FastPdfKit.h>
#import "OverlayDataSource.h"

@interface ReaderViewControllerSubclass : ReaderViewController{
    OverlayDataSource *overlayViewDS;
}
@property(nonatomic, assign) OverlayDataSource *overlayViewDS;
@end
