//
//  MFViewController.m
//  multimedia
//
//  Created by Matteo Gavagnin on 10/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MFViewController.h"
#import <FastPdfKit/FastPdfKit.h>

@implementation MFViewController

-(IBAction)actionOpenPlainDocument:(id)sender{
    /** Set document name */
    NSString *documentName = @"Manual";
        
    /** Get document from the App Bundle */
    NSURL *documentUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:documentName ofType:@"pdf"]];
    
    /** Instancing the documentManager */
	MFDocumentManager *documentManager = [[MFDocumentManager alloc]initWithFileUrl:documentUrl];
    
	/** Instancing the readerViewController */
    ReaderViewController *pdfViewController = [[ReaderViewController alloc]initWithDocumentManager:documentManager];
    
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
    
	/** Present the pdf on screen in a modal view */
    [self presentModalViewController:pdfViewController animated:YES]; 
    
    /** Release the pdf controller*/
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
