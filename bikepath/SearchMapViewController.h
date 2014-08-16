//
//  SearchMapViewController.h
//  bikepath
//
//  Created by Farheen Malik on 8/14/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//
// test stuff
#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "SearchItem.h"

@interface SearchMapViewController : UIViewController <GMSMapViewDelegate>

@property (strong, nonatomic) IBOutlet GMSMapView *mapView;

@end
