//
//  MFAppDelegate.h
//  multimedia
//
//  Created by Matteo Gavagnin on 10/5/11.
//  Copyright (c) 2011  MobFarm s.a.s. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MFViewController;

@interface MFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MFViewController *viewController;

@end
