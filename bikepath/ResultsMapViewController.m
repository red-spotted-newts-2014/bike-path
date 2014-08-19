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
#import "MDDirectionService.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "StationFinder.h"
#import "GMSMarkerFactory.h"

@interface ResultsMapViewController () {
    GMSMapView *mapView_;
    NSMutableArray *waypoints_;
    NSMutableArray *waypointStrings_;
    CLLocationManager *locationManager;
}
@end

@implementation ResultsMapViewController


- (IBAction)unwindToSearchPage:(UIStoryboardSegue *)segue{

}

- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
}

//FUNCTION BELOW INCLUDES CITIBIKE CALL - NEEDS TO BE DECOUPLED!
-(void)buttonPressed {
    NSLog(@"Button Pressed!");
    NSURL *testURL = [NSURL URLWithString:@"comgooglemaps-x-callback://"];
    if ([[UIApplication sharedApplication] canOpenURL:testURL]) {
        
        NSString *callBackUrl = @"comgooglemaps-x-callback://";
        CLLocationDegrees endLati = self.item.lati;
        CLLocationDegrees endLongi = self.item.longi;
        NSString *directionsMode = @"&directionsmode=bicycling&zoom=17";
        NSString *appConnection = @"&x-success=sourceapp://?resume=true&x-source=bike-path.bikepath";
        NSString *directions = [[NSString alloc] initWithFormat: @"%@?daddr=%f,%f%@%@", callBackUrl, endLati, endLongi, directionsMode, appConnection];
        NSLog(@"%@", directions);
        
        NSString *directionsRequest = directions;
        NSURL *directionsURL = [NSURL URLWithString:directionsRequest];
        [[UIApplication sharedApplication] openURL:directionsURL];
    } else {
        NSLog(@"Can't use comgooglemaps-x-callback:// on this device.");
    }
}

- (void) initMap{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:40.706638
                                                            longitude:-74.009070
                                                                 zoom:13];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    //create the button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    //set the position of the button
    button.frame = CGRectMake(175, 400, 100, 30);
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 1.0;
    button.layer.cornerRadius = 10;
//    button.backgroundColor = [UIColor whiteColor];
    [button setBackgroundImage:[UIImage imageNamed:@"bike_icon"] forState:UIControlStateNormal];
    
    //set the button's title
    [button setTitle:@"Live Nav" forState:UIControlStateNormal];
    
    //listen for clicks
    [button addTarget:self action:@selector(buttonPressed)
     forControlEvents:UIControlEventTouchUpInside];
    
    mapView_.delegate = self;
    self.view = mapView_;
    [mapView_ addSubview:button];
    return;
}

- (void)getUserLocation{
    locationManager = [[CLLocationManager alloc] init];
}

- (void)updateUserLocation{
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
}

- (void)viewDidLoad{
    // do the default view behavior
    [super viewDidLoad];
    
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel loadCitiBikeData];

    [self initMap];
    [self getUserLocation];
    [self updateUserLocation];

    // init a waypoints instance var, it's an array of markers not locations
    waypoints_ = [[NSMutableArray alloc]init];

    // place a marker on the map at the current location of the phone
//    NSDictionary *closestStation = [StationFinder findClosestStation:stations location:currentLocation];
    CLLocationCoordinate2D startPosition = locationManager.location.coordinate;
    GMSMarker *startPoint = [GMSMarkerFactory createGMSMarker:startPosition
                                                      mapView:mapView_
                                                        title:@"Start"
                                                        color:[GMSMarker markerImageWithColor:[UIColor redColor]]];
    [waypoints_ addObject: startPoint];

    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:startPosition.latitude
                                                             longitude:startPosition.longitude];


    CLLocationCoordinate2D createEndLocation = CLLocationCoordinate2DMake(self.item.lati, self.item.longi);
    GMSMarker *endPoint = [GMSMarkerFactory createGMSMarker:createEndLocation
                                                    mapView:mapView_
                                                      title:self.item.address //the address being given is not the full address
                                                      color:[GMSMarker markerImageWithColor:[UIColor redColor]]];
    [waypoints_ addObject:endPoint];

    
    
    NSArray *stations = appDel.stationJSON;
             NSLog(@"%@",stations);

             NSDictionary *closestStation = [StationFinder findClosestStation:stations location:currentLocation];
             CLLocationCoordinate2D closestStationLocation = CLLocationCoordinate2DMake(
                 [[closestStation objectForKey:@"latitude"] doubleValue],
                 [[closestStation objectForKey:@"longitude"] doubleValue]);

             NSNumber *numberOfBikes = @([[closestStation objectForKey:@"availableBikes"] intValue]);

             GMSMarker *startStation  = [GMSMarkerFactory createGMSMarkerForStation:closestStationLocation
                                                                  mapView:mapView_
                                                                    title:[closestStation objectForKey:@"stationName"]
                                                         availableSnippet:@"Bicycles available"
                                                       unavailableSnippet:@"No bicycles available at this location."
                                                            numberOfBikes:numberOfBikes];
             [waypoints_ addObject:startStation];

             CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:createEndLocation.latitude
                                                                  longitude:createEndLocation.longitude];

             NSDictionary *closestEndStation = [StationFinder findClosestStation:stations location:endLocation];
             CLLocationCoordinate2D closestEndStationLocation =
             CLLocationCoordinate2DMake([[closestEndStation objectForKey:@"latitude"] doubleValue],
                                        [[closestEndStation objectForKey:@"longitude"] doubleValue]);

             NSNumber *availableDocks = @([[closestStation objectForKey:@"availableDocks"] intValue]);

             GMSMarker *endStation  = [GMSMarkerFactory createGMSMarkerForStation:closestEndStationLocation
                                                                mapView:mapView_
                                                                  title:[closestEndStation objectForKey:@"stationName"]
                                                       availableSnippet:@"Docks available"
                                                     unavailableSnippet:@"No docks available at this location."
                                                          numberOfBikes:availableDocks];
             [waypoints_ addObject:endStation];

             // make google waypoint search struct ... do this somewhere else
             NSMutableArray *markerStrings = [[NSMutableArray alloc] init];
             for(GMSMarker *waypoint in waypoints_){
                 [markerStrings addObject:[[NSString alloc] initWithFormat:@"%f,%f", waypoint.position.latitude, waypoint.position.longitude]];
             }

             NSArray *keys = [NSArray arrayWithObjects: @"waypoints", nil];
             NSArray *parameters = [NSArray arrayWithObjects: markerStrings, nil];
             NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                               forKeys:keys];

             // finally, find the waypoints and set the delegate to this view, the direction
             // lines will be drawn when the request completes
             MDDirectionService *mds=[[MDDirectionService alloc] init];
             SEL selector = @selector(addDirections:);
             [mds setDirectionsQuery:query
                        withSelector:selector
                        withDelegate:self];
         }

- (void)addDirections:(NSDictionary *)json {

    NSDictionary *routes = [json objectForKey:@"routes"][0];

    NSDictionary *route = [routes objectForKey:@"overview_polyline"];
    NSString *overview_route = [route objectForKey:@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.map = mapView_;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
