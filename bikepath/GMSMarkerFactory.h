//
//  GMSMarkerFactory.h
//  bikepath
//
//  Created by Armen Vartan on 8/18/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface GMSMarkerFactory : NSObject

+ (GMSMarker*)createGMSMarker:(CLLocationCoordinate2D*) locationCoordinates
                      mapView:(GMSMapView*) map
                        title:(NSString*) title
                        color:(UIImage*) color;

+ (GMSMarker*)createGMSMarkerForStation:(CLLocationCoordinate2D*) locationCoordinates
                                mapView:(GMSMapView*) map
                                  title:(NSString*) title
                       availableSnippet:(NSString*) availableSnippet
                     unavailableSnippet:(NSString*) unavailableSnippet
                          numberOfBikes:(NSNumber*) numberOfBikes;

@end
