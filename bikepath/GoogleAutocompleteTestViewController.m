//
//  GoogleAutocompleteTestViewController.m
//  bikepath
//
//  Created by Apprentice on 8/17/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import "GoogleAutocompleteTestViewController.h"
#import "SPGooglePlacesAutocomplete.h"
#import <UIKit/UIKit.h>
#import "SearchItem.h"
#import "ResultsMapViewController.h"

@interface GoogleAutocompleteTestViewController ()

@end

@implementation GoogleAutocompleteTestViewController

@synthesize mapView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    NSLog(@"initWithCoder");
    if (self) {
//        NSLog(@"hello");
        searchQuery = [[SPGooglePlacesAutocompleteQuery alloc] initWithApiKey:@"AIzaSyAxaqfMyyc-WSrvsWP_jF2IUaTZVjkMlFo"];
        shouldBeginEditing = YES;
    }
    return self;
}

- (void)viewDidLoad {
//    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController setNavigationBarHidden:TRUE];
    self.searchDisplayController.searchBar.placeholder = @"Search or Address";
    
    GMSCameraPosition *nyc = [GMSCameraPosition cameraWithLatitude:40.706638
                                                         longitude:-74.009070
                                                              zoom:12
                                                           bearing:30
                                                        viewingAngle:45];
    self.mapView.mapType = kGMSTypeNormal;
    [self.mapView setCamera:nyc];
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.settings.zoomGestures = YES;
//    self.mapView.delegate = self;
    
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchResultPlaces count];
}

- (SPGooglePlacesAutocompletePlace *)placeAtIndexPath:(NSIndexPath *)indexPath {
    return searchResultPlaces[indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SPGooglePlacesAutocompleteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"GillSans" size:16.0];
    cell.textLabel.text = [self placeAtIndexPath:indexPath].name;
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)dismissSearchControllerWhileStayingActive {
    // Animate out the table view.
    NSTimeInterval animationDuration = 0.3;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.searchDisplayController.searchResultsTableView.alpha = 0.0;
    [UIView commitAnimations];
    
    [self.searchDisplayController.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchDisplayController.searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SPGooglePlacesAutocompletePlace *place = [self placeAtIndexPath:indexPath];
    [place resolveToPlacemark:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not map selected Place"
            message:error.localizedDescription
            delegate:nil
            cancelButtonTitle:@"OK"
            otherButtonTitles:nil, nil];
            [alert show];
        } else if (placemark) {
            SearchItem *selectedItem   = [[SearchItem alloc] init];
            selectedItem.searchQuery   = place.name;
            selectedItem.lati = placemark.location.coordinate.latitude;
            selectedItem.longi = placemark.location.coordinate.longitude;
            selectedItem.address = placemark.thoroughfare;
            [self performSegueWithIdentifier: @"showResults" sender: selectedItem];
//            [self pushResultsMapViewController: (SearchItem*)selectedItem];
//            [self actionWithSender:(UITableViewCell*)selectedItem];
            [self dismissSearchControllerWhileStayingActive];
            [self.searchDisplayController.searchResultsTableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }];
}

#pragma mark -
#pragma mark UISearchDisplayDelegate

- (void)handleSearchForSearchString:(NSString *)searchString {
    
    NSLog(@"%@", searchQuery);
    searchQuery.input = searchString;
    [searchQuery fetchPlaces:^(NSArray *places, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not fetch Places"
            message:error.localizedDescription
            delegate:nil
            cancelButtonTitle:@"OK"
            otherButtonTitles:nil, nil];
            [alert show];
        } else {
            searchResultPlaces = places;
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self handleSearchForSearchString:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark -
#pragma mark UISearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![searchBar isFirstResponder]) {
        // User tapped the 'clear' button.
        shouldBeginEditing = NO;
        [self.searchDisplayController setActive:NO];
//        [self.mapView removeAnnotation:selectedPlaceAnnotation];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (shouldBeginEditing) {
        // Animate in the table view.
        NSTimeInterval animationDuration = 0.3;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        self.searchDisplayController.searchResultsTableView.alpha = 0.75;
        [UIView commitAnimations];
        
        [self.searchDisplayController.searchBar setShowsCancelButton:YES animated:YES];
    }
    BOOL boolToReturn = shouldBeginEditing;
    shouldBeginEditing = YES;
    return boolToReturn;
}



//-(void)actionWithSender:(UITableViewCell*)sender event:(UIEvent*)event {
//    NSString* parameter;
//    NSLog(@"%@", sender);
////    if (sender.tag == 1)   // button1
////        parameter = @"foo";
////    else                   // button2
////        parameter = @"bar";
//////    ...
//}

//- (IBAction)pushResultsMapViewController: (SearchItem *)sender
//{
//    ResultsMapViewController *resultsMap = [[ResultsMapViewController alloc] initWithProperty:(SearchItem*)sender];
//    NSLog(@"%@", sender);
//    SearchItem *item = sender;
//    ResultsMapViewController *destViewController = segue.destinationViewController;
//    destViewController.item = item;
//    [self presentModalViewController:resultsMap animated:YES];
//}

// segue to results page
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showResults"]) {
        NSLog(@"%@", sender);
        ResultsMapViewController *destViewController = segue.destinationViewController;
        SearchItem *item = sender;
        
        NSLog(@"%@",item.searchQuery);
        destViewController.item = item;
        
    }
}

@end
