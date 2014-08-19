//
//  SearchMapViewController.m
//  bikepath
//
//  Created by Farheen Malik on 8/14/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import "SearchMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>
#import "SearchItem.h"

@interface SearchMapViewController ()

@end

@implementation SearchMapViewController {

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    GMSCameraPosition *dbc = [GMSCameraPosition cameraWithLatitude:40.706638
                                                         longitude:-74.009070
                                                              zoom:16];
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
             for(id st in stations) {
                 NSDictionary *station = (NSDictionary *)st;
                 NSString *lati             = [station objectForKey:@"latitude"];
                 NSString *longi            = [station objectForKey:@"longitude"];
                 NSString *title            = [station objectForKey:@"stationName"];
                 NSString *availableBikes   = [[station objectForKey:@"availableBikes"] stringValue];
                 
                 GMSMarker *citiMarker = [[GMSMarker alloc] init];
                 
                 citiMarker.position = CLLocationCoordinate2DMake([lati doubleValue], [longi doubleValue]);
                 citiMarker.title    = title;
                 citiMarker.map      = self.mapView;
                 
                 NSNumber *num = @([[station objectForKey:@"availableBikes"] intValue]);
                 
                 CLLocation *location = [[CLLocation alloc] initWithLatitude:[lati doubleValue] longitude:[longi doubleValue]];
                 NSMutableArray *locations = [[NSMutableArray alloc] init];
                 [locations addObject:location];
                 
                 if ([num intValue] > 0) {
                     citiMarker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
                     citiMarker.snippet  = [NSString stringWithFormat:@"Bicyles avaiable: %@", availableBikes];
                 } else {
                     citiMarker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
                     citiMarker.snippet = @"No bicyles availabe at this location.";
                 };
                 citiMarker.map = self.mapView;
             }
         }
     }];
    
    
}


@end


