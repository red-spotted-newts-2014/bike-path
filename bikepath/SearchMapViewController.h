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

@class SPGooglePlacesAutocompleteQuery;

@interface SearchMapViewController : UIViewController <GMSMapViewDelegate>//, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate> {
{NSArray *searchResultPlaces;
    SPGooglePlacesAutocompleteQuery *searchQuery;
    BOOL shouldBeginEditing;
}

@property (strong, nonatomic) IBOutlet GMSMapView *mapView;

@end
