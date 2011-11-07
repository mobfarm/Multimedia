//
//  MFViewController.m
//  multimedia
//
//  Created by Matteo Gavagnin on 10/5/11.
//  Copyright (c) 2011 MobFarm s.a.s. All rights reserved.
//

#import "MFViewController.h"
#import <FastPdfKit/FastPdfKit.h>
#import "OverlayDataSource.h"
#import "ReaderViewControllerSubclass.h"

@implementation MFViewController

-(IBAction)actionOpenPlainDocument:(id)sender{
    /** Set document name */
    NSString *documentName = @"Manual";
        
    /** Get document from the App Bundle */
    NSURL *documentUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:documentName ofType:@"pdf"]];
    
    /** Instancing the documentManager */
	MFDocumentManager *documentManager = [[MFDocumentManager alloc]initWithFileUrl:documentUrl];
    
	/** Instancing the readerViewController */
    ReaderViewControllerSubclass *pdfViewController = [[ReaderViewControllerSubclass alloc]initWithDocumentManager:documentManager];
    
    /** Get Documents directory */
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    /** Set multimedia path */
    NSString *multimediaPath = [paths objectAtIndex:0];
    
    /** Or grab the document directly from the mainBundle (application archive) */
    // NSString *multimediaPath = [[NSBundle mainBundle] resourcePath];
    
    /** Set resources folder on the manager */
    documentManager.resourceFolder = multimediaPath;
    
    /** Set document id for thumbnail generation */
    pdfViewController.documentId = documentName;
    
    
    /** Instantiate the overlay data source */
    OverlayDataSource *_overlayDataSource = [[[OverlayDataSource alloc] init] autorelease];
    
    /** Init the arrays for annotations */
    [_overlayDataSource setOverlays:[[NSMutableArray alloc] init]];
    [_overlayDataSource setOverlaysFrames:[[NSMutableDictionary alloc] init]];
    
    /** Add the overlay data source to the ReaderViewController */
    [pdfViewController addOverlayViewDataSource:_overlayDataSource];    
    [pdfViewController setOverlayViewDS:_overlayDataSource];
    
    /** Pass the pdfViewController to the overlayDataSource */
    [_overlayDataSource setDocumentViewController:(MFDocumentViewController <OverlayDataSourceDelegate> *)pdfViewController];
    
    /** To show the map we need to add an annotation like 
        map://hybrid?lat=37.0&lon=-122.0&latd=0.11&lond=0.10
     */
    
    /** To support youtube videos is enough an annotation like 
        utube://HG92NUXKzZ0
        
        A YouTube annotation will work only on device (not simulator)
     */
    
    /**
        These annotations are on page 2 of Manual.pdf
     */
    
	/** Present the pdf on screen in a modal view */
    [self presentModalViewController:pdfViewController animated:YES]; 
    
    /** Release the pdf controller and the document manager */
    [documentManager release];
    [pdfViewController release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
