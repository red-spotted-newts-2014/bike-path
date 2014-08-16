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
- (IBAction)unwindToSearchPage:(UIStoryboardSegue *)segue {
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    
    request.naturalLanguageQuery = @"Starbucks, New York, NY";
//    request.naturalLanguageQuery = @"48 Wall Street New York NY";
    
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
   
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response.mapItems.count == 0)
            NSLog(@"no items");
        else
            for (MKMapItem *item in response.mapItems)
            {
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.position = CLLocationCoordinate2DMake(item.placemark.location.coordinate.latitude, item.placemark.location.coordinate.longitude);
                marker.title = item.name;
                marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
                marker.map = self.mapView;
                
//                NSLog(@"latitude = %f", item.placemark.location.coordinate.latitude);
//                NSLog(@"longitude = %f", item.placemark.location.coordinate.longitude);
            }
    }];
    
//    [mapView_ setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
//    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=CSV", "FETCH TEXT FROM SEARCH BAR" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
    
//    self.title = @"Searching";
//    UISearchBar *nameSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
//    nameSearchBar = self;
//    nameSearchBar.placeholder = @"Enter Search Item";
//    nameSearchBar.tintColor = [UIColor blackColor];
//    [nameSearchBar sizeToFit];
//    [self.view addSubview:nameSearchBar];
//
//    self.searchField.delegate = self;
}


@end


