//
//  YouTubeView.m
//  Overlay
//
//  Created by Matteo Gavagnin on 11/3/11.
//  Copyright (c) 2011 MobFarm s.a.s. All rights reserved.
//

#import "YouTubeView.h"

@implementation YouTubeView

#pragma mark -
#pragma mark Initialization

- (YouTubeView *)initWithStringAsURL:(NSString *)urlString frame:(CGRect)frame;
{
    if (self = [super init]) 
    {
        // Create webview with requested frame size
        self = [(YouTubeView *)[UIWebView alloc] initWithFrame:frame];
        
        // HTML to embed YouTube video
        NSString *youTubeVideoHTML = @"<html><head>\
        <body style=\"margin:0\">\
        <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
        width=\"%0.0f\" height=\"%0.0f\"></embed>\
        </body></html>";
        
        // Populate HTML with the URL and requested frame size
        NSString *html = [NSString stringWithFormat:youTubeVideoHTML, urlString, frame.size.width, frame.size.height];
        
        // Load the html into the webview
        [self loadHTMLString:html baseURL:nil];
    }
    return self;  
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc 
{
    [super dealloc];
}

@end