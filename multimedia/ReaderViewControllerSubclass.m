//
//  ReaderViewControllerSubclass.m
//  multimedia
//
//  Created by Matteo Gavagnin on 11/7/11.
//  Copyright (c) 2011 MobFarm S.r.l. All rights reserved.
//

#import "ReaderViewControllerSubclass.h"

@implementation ReaderViewControllerSubclass
@synthesize overlayViewDS;

- (void)documentViewController:(MFDocumentViewController *)dvc didReceiveTapOnAnnotationRect:(CGRect)rect withUri:(NSString *)uri onPage:(NSUInteger)page{
    [overlayViewDS showAnnotationForOverlay:NO withRect:rect andUri:uri onPage:page];
}

@end
