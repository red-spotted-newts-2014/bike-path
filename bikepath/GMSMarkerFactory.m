//
//  GMSMarkerFactory.m
//  bikepath
//
//  Created by Armen Vartan on 8/18/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import "GMSMarkerFactory.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation GMSMarkerFactory
+ (GMSMarker*)createGMSMarker:(CLLocationCoordinate2D) locationCoordinates
                      mapView:(GMSMapView*) map
                        title:(NSString*) title
                        color:(UIImage*) color{
    GMSMarker *marker = [GMSMarker markerWithPosition:locationCoordinates];
    marker.title      = title;
    marker.map        = map;
    marker.icon       = color;
    return marker;
}

+ (GMSMarker*)createGMSMarkerForStation:(CLLocationCoordinate2D) locationCoordinates
                                mapView:(GMSMapView*) map
                                  title:(NSString*) title
                       availableSnippet:(NSString*) availableSnippet
                     unavailableSnippet:(NSString*) unavailableSnippet
                          numberOfBikes:(NSNumber*) numberOfBikes{
    
    GMSMarker *marker = [GMSMarker markerWithPosition:locationCoordinates];
    marker.title      = title;
    marker.map        = map;
    
    if ([numberOfBikes integerValue] > 3) {
        marker.icon    = [UIImage imageNamed:@"bicycleGreen"];
        marker.snippet = [NSString stringWithFormat:@"%@: %@", availableSnippet, numberOfBikes];
    } else if ([numberOfBikes integerValue] > 0) {
        marker.icon    = [UIImage imageNamed:@"bicycleYellow"];
        marker.snippet = [NSString stringWithFormat:@"%@: %@", availableSnippet, numberOfBikes];
    } else {
        marker.icon    = [UIImage imageNamed:@"bicycleRed"];
        marker.snippet = [NSString stringWithFormat:@"%@", unavailableSnippet];
    };
    return marker;
}
@end
