//
//  CitiBikeController.h
//  bikepath
//
//  Created by Armen Vartan on 8/19/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *kCitiBikeURL = @"http://www.citibikenyc.com/stations/json";

@interface CitiBikeController : NSObject

@property NSArray *bikeStations;
@property NSString *bikePath;
- (void) updateStations;

@end
