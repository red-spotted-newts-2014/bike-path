//
//  ResultsMapViewController.h
//  bikepath
//
//  Created by Farheen Malik on 8/14/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "SearchItem.h"
#import "AppDelegate.h"
AppDelegate *appDel;
@interface ResultsMapViewController : UIViewController <GMSMapViewDelegate>


@property (strong, nonatomic) IBOutlet GMSMapView *mapView;

- (IBAction)unwindToSearchPage:(UIStoryboardSegue *)segue;

@property (nonatomic, strong) SearchItem *item;


@end
