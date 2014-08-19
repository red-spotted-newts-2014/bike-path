//
//  MDDirectionService.m
//  bikepath
//
//  Created by Armen Vartan on 8/16/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import "MDDirectionService.h"

@implementation MDDirectionService{
    @private
    BOOL _sensor;
    BOOL _alternatives;
    NSURL *_directionsURL;
    NSArray *_waypoints;
}

static NSString *kMDDirectionsURL = @"http://maps.googleapis.com/maps/api/directions/json?mode=bicycling";

- (void)setDirectionsQuery:(NSDictionary *)query withSelector:(SEL)selector withDelegate:(id)delegate{
    NSArray *waypoints = [query objectForKey:@"waypoints"];
    NSString *url = [NSMutableString stringWithFormat:@"%@&origin=%@&destination=%@&sensor=true&waypoints=%@|%@", kMDDirectionsURL, [waypoints objectAtIndex:0], [waypoints objectAtIndex:1], [waypoints objectAtIndex:2], [waypoints objectAtIndex:3]];

    url = [url stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    _directionsURL = [NSURL URLWithString:url];
    [self retrieveDirections:selector withDelegate:delegate];
}
- (void)retrieveDirections:(SEL)selector withDelegate:(id)delegate{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData* data = [NSData dataWithContentsOfURL:_directionsURL];
        [self fetchedData:data withSelector:selector withDelegate:delegate];
    });
}

- (void)fetchedData:(NSData *)data
       withSelector:(SEL)selector
       withDelegate:(id)delegate{

    NSError* error;
    NSDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    [delegate performSelector:selector withObject:json];
}

@end
