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
#import "AFNetworking.h"

@interface SearchMapViewController ()

@end

@implementation SearchMapViewController {

}

- (IBAction)unwindToSearchPage:(UIStoryboardSegue *)segue {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"222 Fulton Street New York NY";
    
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response.mapItems.count == 0)
            NSLog(@"No Matches");
        else
            for (MKMapItem *item in response.mapItems)
            {
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = CLLocationCoordinate2DMake(item.placemark.location.coordinate.latitude, item.placemark.location.coordinate.longitude);
                marker.title = item.name;
                marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
                marker.map = _mapView;
                NSLog(@"latitude = %f", item.placemark.location.coordinate.latitude);
                NSLog(@"longitude = %f", item.placemark.location.coordinate.longitude);
            }
    }];
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.706638
//                                                            longitude:-74.009070
//                                                                 zoom:14];
    
//    [mapView_ setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
//    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=CSV", "FETCH TEXT FROM SEARCH BAR" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
//
    self.mapView.mapType = kGMSTypeNormal;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.settings.zoomGestures = YES;
    self.mapView.delegate = self;
//
//    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
