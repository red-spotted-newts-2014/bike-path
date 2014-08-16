//
//  LaunchScreenViewController.m
//  bikepath
//
//  Created by Apprentice on 8/16/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import "LaunchScreenViewController.h"
#import <CoreLocation/CoreLocation.h>

@implementation LaunchScreenViewController

- (void)startStandardUpdates
{
    CLLocationManager *locationManager;
    
    // Create the location manager if this object does not
    // already have one.
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 500; // meters
    
    [locationManager startUpdatingLocation];
}

@end
