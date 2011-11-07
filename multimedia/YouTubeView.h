//
//  YouTubeView.h
//  Overlay
//
//  Created by Matteo Gavagnin on 11/3/11.
//  Copyright (c) 2011 MobFarm s.a.s. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YouTubeView : UIWebView
- (YouTubeView *)initWithStringAsURL:(NSString *)urlString frame:(CGRect)frame;
@end
