//
//  StationFinder.m
//  bikepath
//
//  Created by Vivek M George on 8/18/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import "StationFinder.h"
#import <CoreLocation/CoreLocation.h>

@implementation StationFinder

+ (NSDictionary *) findClosestStation: (NSArray *) stations
                             location: (CLLocation *) currentLocation {
    
    
    CLLocationDistance smallestDistance = DBL_MAX;
    //    CLLocation *closestLocation;
    NSDictionary *closestStation;
    
    //        CLLocation *closestEndLocation;
    //        NSDictionary *closestEndStation;
    
    for(id st in stations) {
        NSDictionary *station      = (NSDictionary *)st;
        NSString *stationLatitude  = [station objectForKey:@"latitude"];
        NSString *stationLongitude = [station objectForKey:@"longitude"];
        
        
        CLLocation *bikeStop = [[CLLocation alloc] initWithLatitude:[stationLatitude doubleValue] longitude:[stationLongitude doubleValue]];
        
        NSMutableArray *locations = [[NSMutableArray alloc] init];
        [locations addObject:bikeStop];
        
        for (CLLocation *location in locations) {
            CLLocationDistance distance = [currentLocation distanceFromLocation:location];
            
            if (distance < smallestDistance) {
                smallestDistance    = distance;
                //                closestLocation     = location;
                closestStation      = station;
            }
        }
        
    }
    
    //        print it
    //    NSLog(@"%@", closestStation);
    
    return closestStation;
}

@end
