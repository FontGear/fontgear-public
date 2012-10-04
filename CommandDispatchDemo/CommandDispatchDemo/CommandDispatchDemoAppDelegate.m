//
//  CommandDispatchDemoAppDelegate.m
//  CommandDispatchDemo
//
//  Created by Jack Cox on 9/10/11.
//  Copyright 2011 CapTech Ventures, Inc.. All rights reserved.
//

#import "CommandDispatchDemoAppDelegate.h"
#import "BaseCommand.h"

@implementation CommandDispatchDemoAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize opQueue;
@synthesize token;
@synthesize user;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initializeCommandDispatchListeners];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

#pragma mark    CommandDispatch methods

/**
 Setup the App delegate as the exception listener for errors and login notifications
 **/
- (void)initializeCommandDispatchListeners {
    // create the two view controllers that may be needed if a network error occurs.  This could be postponed
    //   to improve startup time.
    //
    networkErrorViewController = [[NetworkErrorViewController alloc] initWithNibName:@"NetworkErrorViewController" 
                                                                              bundle:nil];
    networkErrorViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" 
                                                                bundle:nil];
    loginViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    self.opQueue = [[NSOperationQueue alloc] init];
    //  Start listening for login needed notifications
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(loginNeeded:) 
                                                 name:[BaseCommand getLoginNotificationName] 
                                               object:nil];
    // Start listening for network error notifications
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(networkError:) 
                                                 name:[BaseCommand getNetworkErrorNotificationname] 
                                               object:nil];
    
}
/**
 Find the view controller at the top of the modal stack
 **/
- (UIViewController *) topOfModalStack:(UIViewController *)vc {
    if (vc.modalViewController == nil) {
        return  vc;
    } else {
        return [self topOfModalStack:vc.modalViewController];
    }
}
/**
 Dismiss the view controller at the very top of the stack
 **/
- (void) dismissTopMostModalViewControllerAnimated:(BOOL)flag {
    if (self.window.rootViewController.modalViewController == nil) {
        [self.window.rootViewController dismissModalViewControllerAnimated:YES];
        return;
    }
    UIViewController *top = [self topOfModalStack:self.window.rootViewController];
    [top dismissModalViewControllerAnimated:YES];
    
}

/**
 Handles error notifications generated by commands 
 **/
- (void) networkError:(NSNotification *)notif {
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(networkErrorViewController) {
            [networkErrorViewController addTriggeringCommand:[[notif userInfo] objectForKey:@"self"]];
            if (!networkErrorViewController.displayed) {
                [[self topOfModalStack:self.window.rootViewController] presentModalViewController:networkErrorViewController animated:YES];
            }
            networkErrorViewController.displayed = YES;
        }
    });
    
}
/**
 Handles login needed notifications generated by commands
 **/
- (void) loginNeeded:(NSNotification *)notif {
    dispatch_async(dispatch_get_main_queue(), ^{ // make sure it all occurs on the main thread
        @synchronized(loginViewController) { // make sure only one thread adds a command at a time
            [loginViewController addTriggeringCommand:[[notif userInfo] objectForKey:@"self"]];
            if (!loginViewController.displayed) { // if the view is not displayed then display it.
                [[self topOfModalStack:self.window.rootViewController] presentModalViewController:loginViewController animated:YES];
            }
            loginViewController.displayed = YES;
        }
    });
    
}

#pragma mark -

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [opQueue release];
    [user release];
    [token release];
    [loginViewController release];
    [networkErrorViewController release];
    [super dealloc];
}

@end
