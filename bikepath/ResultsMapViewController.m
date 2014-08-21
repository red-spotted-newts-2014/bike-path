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
#import "ErrorMessage.h"

@interface ResultsMapViewController () {
    GMSMapView *mapView_;
    NSMutableArray *waypoints_;
    NSMutableArray *waypointStrings_;
    CLLocationManager *locationManager;
}
@end

@implementation ResultsMapViewController

- (IBAction)unwindToSearchPage:(UIStoryboardSegue *)segue {}

- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
}

-(void)buttonPressed {
    NSURL *testURL = [NSURL URLWithString:@"comgooglemaps-x-callback://"];
    if ([[UIApplication sharedApplication] canOpenURL:testURL]) {
        AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSArray *stations = appDel.stationJSON;
        CLLocationCoordinate2D createEndLocation = CLLocationCoordinate2DMake(self.item.lati, self.item.longi);
        CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:createEndLocation.latitude
                                                             longitude:createEndLocation.longitude];
    
        NSDictionary *endStationforNav = [StationFinder findClosestStation:stations location:endLocation];

        NSString *callBackUrl = @"comgooglemaps-x-callback://";
        CLLocationDegrees endLati = [[endStationforNav objectForKey:@"latitude"] doubleValue];
        CLLocationDegrees endLongi = [[endStationforNav objectForKey:@"longitude"] doubleValue];
        NSString *directionsMode = @"&directionsmode=bicycling&zoom=17";
        NSString *appConnection = @"&x-success=sourceapp://?resume=true&x-source=bike-path.bikepath";
        NSString *directions = [[NSString alloc] initWithFormat: @"%@?daddr=%f,%f%@%@", callBackUrl, endLati, endLongi, directionsMode, appConnection];

        NSString *directionsRequest = directions;
        NSURL *directionsURL = [NSURL URLWithString:directionsRequest];
        [[UIApplication sharedApplication] openURL:directionsURL];
    } else {
        NSLog(@"Can't use comgooglemaps-x-callback:// on this device.");
    }
}

- (void) initMap:(CLLocationCoordinate2D)userLocation {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:userLocation.latitude
                                                            longitude:userLocation.longitude
                                                                 zoom:13];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(250, 500, 64, 64);
    [button setImage:[UIImage imageNamed:@"navButton"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(buttonPressed)
     forControlEvents:UIControlEventTouchUpInside];
    
    mapView_.delegate = self;
    self.view = mapView_;
    [mapView_ addSubview:button];
    return;
}

- (void)currentUserLocation {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage* logoImage = [UIImage imageNamed:@"inappicon"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel loadCitiBikeData];

    [self currentUserLocation];
    CLLocationCoordinate2D startPosition = locationManager.location.coordinate;
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:startPosition.latitude
                                                             longitude:startPosition.longitude];
    [self initMap:startPosition];

    waypoints_ = [[NSMutableArray alloc]init];

    GMSMarker *startPoint = [GMSMarkerFactory createGMSMarker:startPosition
                                                      mapView:mapView_
                                                        title:@"Start"
                                                        color:[UIImage imageNamed:@"startStation"]];
    [waypoints_ addObject:startPoint];

    CLLocationCoordinate2D createEndLocation = CLLocationCoordinate2DMake(self.item.lati, self.item.longi);
    
    NSString *destinationName;
    
    if ([[self.item.searchQuery componentsSeparatedByString:@","] objectAtIndex:0]) {
        destinationName = [[self.item.searchQuery componentsSeparatedByString:@","] objectAtIndex:0];
    } else {
        destinationName = self.item.searchQuery;
    };

    GMSMarker *endPoint = [GMSMarkerFactory createGMSMarker:createEndLocation
                                                    mapView:mapView_
                                                      title:destinationName
                                                      color:[UIImage imageNamed:@"endStation"]];
    [waypoints_ addObject:endPoint];

    NSArray *stations = appDel.stationJSON;

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

             NSMutableArray *markerStrings = [[NSMutableArray alloc] init];
             for(GMSMarker *waypoint in waypoints_){
                 [markerStrings addObject:[[NSString alloc] initWithFormat:@"%f,%f", waypoint.position.latitude, waypoint.position.longitude]];
             }

             NSArray *keys = [NSArray arrayWithObjects: @"waypoints", nil];
             NSArray *parameters = [NSArray arrayWithObjects: markerStrings, nil];
             NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                               forKeys:keys];

             MDDirectionService *mds=[[MDDirectionService alloc] init];
             SEL selector = @selector(addDirections:);
             [mds setDirectionsQuery:query
                        withSelector:selector
                        withDelegate:self];
         }

- (void)addDirections:(NSDictionary *)json {
    NSDictionary *routes;
    if ([json objectForKey:@"routes"][0]) {
        routes = [json objectForKey:@"routes"][0];
    } else {
        [ErrorMessage renderErrorMessage:@"No routes found. Please reword your query with a full street address." cancelButtonTitle:@"OK" error:nil];
    }
    

    NSDictionary *route = [routes objectForKey:@"overview_polyline"];
    NSString *overview_route = [route objectForKey:@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeWidth = 3.f;
    polyline.map = mapView_;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
