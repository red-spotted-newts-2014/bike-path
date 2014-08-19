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
+ (GMSMarker*)createGMSMarker:(CLLocationCoordinate2D*) locationCoordinates
                      mapView:(GMSMapView*) map
                        title:(NSString*) title
                        color:(UIColor*) color{
    GMSMarker *marker = [GMSMarker markerWithPosition:*locationCoordinates];
    marker.title = title;
    marker.map = map;
    marker.icon = color;
    return marker;
}

+ (GMSMarker*)createGMSMarkerForStation:(CLLocationCoordinate2D*) locationCoordinates
                      mapView:(GMSMapView*) map
                        title:(NSString*) title
             availableSnippet:(NSString*) availableSnippet
           unavailableSnippet:(NSString*) unavailableSnippet
                numberOfBikes:(NSNumber*) numberOfBikes{
    
    GMSMarker *marker = [GMSMarker markerWithPosition:*locationCoordinates];
    marker.title = title;
    marker.map = map;
    
    if ([numberOfBikes integerValue] > 3) {
        marker.icon    = [GMSMarker markerImageWithColor:[UIColor greenColor]];
        marker.snippet = [NSString stringWithFormat:@"%@: %@", availableSnippet, numberOfBikes];
    } else if (numberOfBikes > 0) {
        marker.icon    = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
        marker.snippet = [NSString stringWithFormat:@"%@: %@", availableSnippet, numberOfBikes];
    } else {
        marker.icon    = [GMSMarker markerImageWithColor:[UIColor redColor]];
        marker.snippet = [NSString stringWithFormat:@"%@", unavailableSnippet];
    };
    return marker;
}
@end
