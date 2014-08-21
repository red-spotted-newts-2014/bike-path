//
//  AppDelegate.m
//  bikepath
//
//  Created by Vivek George, Molly Huerster, Farheen Malik and Armen Vartan on 8/14/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import "ErrorMessage.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation AppDelegate

@synthesize stationJSON;

#pragma mark - loadAndSaveCitiBikeData

- (NSArray*)loadCitiBikeData {
    NSURL *url = [NSURL URLWithString:@"http://www.citibikenyc.com/stations/json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url
                                                           cachePolicy: NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval: 120.0];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response
                                      error:&error];

         if (data.length > 0 && error == nil)
         {
             NSDictionary *citiBikeJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             NSArray* stations = [citiBikeJSON objectForKey:@"stationBeanList"];
             
             if (!stations) {
                 [ErrorMessage renderErrorMessage:@"No stations available." cancelButtonTitle:@"OK" error:nil];
             }
             
             stationJSON = stations;
             
         } else if (error) {
             [ErrorMessage renderErrorMessage:@"Connection error. Please try again later." cancelButtonTitle:@"OK" error:error];
         } else if (data.length < 1) {
             [ErrorMessage renderErrorMessage:@"No items were retrieved. Please try again later." cancelButtonTitle:@"OK" error:nil];
         } else {
             [ErrorMessage renderErrorMessage:@"An unidentified error occurred. Please try again later." cancelButtonTitle:@"OK" error:nil];
         };
    return stationJSON;
}

#pragma mark - UIFormatting

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    CLLocationManager *manager = [[CLLocationManager alloc] init];
    // background color of navigation bar
    UIColor * color = [UIColor colorWithRed:50/255.0f green:115/255.0f blue:233/255.0f alpha:1.0f];
    [[UINavigationBar appearance] setBarTintColor:color];
    // color of back button
    UIColor * color2 = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];;
    [[UINavigationBar appearance] setTintColor: color2];
    
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
        [UIColor grayColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    //set back indicator image
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back.png"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back.png"]];
    
    // font style of the title
     NSShadow *shadow = [[NSShadow alloc] init];
     [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
     [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f],NSForegroundColorAttributeName,
     shadow, NSShadowAttributeName,
     [UIFont fontWithName:@"STHeitiTC-Medium" size:18.0], NSFontAttributeName, nil]];
    
    [GMSServices provideAPIKey:@"AIzaSyDqQ7Ds6pvIZucpKNe0OiEfCCyepC0SHnw"];
    return YES;
    
}


#pragma mark - closeApp

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

@end
