//
//  ResultsMapViewController.m
//  bikepath
//
//  Created by Farheen Malik on 8/14/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import "ResultsMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>

@implementation ResultsMapViewController


- (IBAction)unwindToSearchPage:(UIStoryboardSegue *)segue{
    
}
- (void)viewDidLoad
{
//
//    locationManager = [[CLLocationManager alloc] init];
//    locationManager.delegate = self;
//    locationManager.distanceFilter = kCLDistanceFilterNone;
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    [locationManager startUpdatingLocation];

    GMSCameraPosition *dbc = [GMSCameraPosition cameraWithLatitude:40.706638
                                                         longitude:-74.009070
                                                              zoom:14];
    
    self.mapView.mapType = kGMSTypeNormal;
    [self.mapView setCamera:dbc];
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.settings.zoomGestures = YES;
    self.mapView.delegate = self;
    
    NSURL *url = [NSURL URLWithString:@"http://www.citibikenyc.com/stations/json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:NULL];
             NSArray* stations = [greeting objectForKey:@"stationBeanList"];
             CLLocationDistance smallestDistance = DBL_MAX;
             CLLocation *closestLocation;
             for(id st in stations) {
                 NSDictionary *station = (NSDictionary *)st;
                 NSString *lati = [station objectForKey:@"latitude"];
                 NSString *longi = [station objectForKey:@"longitude"];
                 NSString *title = [station objectForKey:@"stationName"];
                 NSString *availableBikes   = [[station objectForKey:@"availableBikes"] stringValue];
                 NSNumber *num = @([[station objectForKey:@"availableBikes"] intValue]);
                 
                 GMSMarker *citiMarker = [[GMSMarker alloc] init];
                 
                 citiMarker.position = closestLocation.coordinate;
                 citiMarker.title = title;
                 //             citiMarker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
                 
                 if ([num intValue] > 0) {
                     citiMarker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
                     citiMarker.snippet  = availableBikes;
                 } else {
                     citiMarker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
                     citiMarker.snippet = @"No bikes availabe at this location.";
                 };
                 citiMarker.map = self.mapView;

                 CLLocation *bikeStop = [[CLLocation alloc] initWithLatitude:[lati doubleValue] longitude:[longi doubleValue]];
                 NSMutableArray *locations = [[NSMutableArray alloc] init];
                 [locations addObject:bikeStop];

                 CLLocation *currentLocation = self.mapView.myLocation;
                 
                    for (CLLocation *location in locations) {
                        CLLocationDistance distance = [currentLocation distanceFromLocation:location];
    
                        if (distance < smallestDistance) {
                            smallestDistance = distance;
                            closestLocation = location;
                           
                        }
                    }
             }
             
             NSLog(@"%f", smallestDistance);
             
             
             
        }
     }];
}

@end
