//
//  StationFinder.h
//  bikepath
//
//  Created by Vivek M George on 8/18/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface StationFinder : NSObject

+ (NSDictionary *) findClosestStation: (NSArray *) stations
                             location: (CLLocation *) currentLocation;

@end
