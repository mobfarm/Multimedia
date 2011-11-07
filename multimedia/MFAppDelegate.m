//
//  MFAppDelegate.m
//  multimedia
//
//  Created by Matteo Gavagnin on 10/5/11.
//  Copyright (c) 2011  MobFarm s.a.s. All rights reserved.
//

#import "MFAppDelegate.h"

#import "MFViewController.h"

@implementation MFAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    /** 
        Copying the multimedia document to the Documents Folder
        You should do this when downloading the archive or just the first time you launch the app
        You need to iterate through the documents or copy a folder
    */
    NSString *fileName = [NSString stringWithFormat:@"%@.html", @"index"];
    NSString *srcPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *destPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSError *err;
    [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:destPath error:&err];
    // You should check for errors copyng the file
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[MFViewController alloc] initWithNibName:@"MFViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
