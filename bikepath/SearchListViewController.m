//
//  SearchListViewController.m
//  bikepath
//
//  Created by Farheen Malik on 8/16/14.
//  Copyright (c) 2014 Bike Path. All rights reserved.
//

#import "SearchListViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>
#import "SearchItem.h"
#import "SearchItemTableCell.h"
#import "FTGooglePlacesAPI.h"
#import "ResultsMapViewController.h"

@interface SearchListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *searchResults;

@end

@implementation SearchListViewController

- (IBAction)unwindToSearchPage:(UIStoryboardSegue *)segue {
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchResults = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    //    [self keyboardWillShow];
}
-(void) searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    searchBar.text=@"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

-(void) searchBar: (UISearchBar *) searchBar textDidChange:(NSString *) searchText
{
}

-(void) searchBarSearchButtonClicked: (UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
    self.searchLocation = [[SearchItem alloc] init];
    self.searchLocation.searchQuery = self.searchField.text;
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = self.searchLocation.searchQuery;
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response.mapItems.count == 0)
            NSLog(@"no items");
        else
            for (MKMapItem *item in response.mapItems)
            {
                SearchItem *query   = [[SearchItem alloc] init];
                query.searchQuery   = item.name;
                query.lati          = item.placemark.location.coordinate.latitude;
                query.longi         = item.placemark.location.coordinate.longitude;
                query.position      = CLLocationCoordinate2DMake(item.placemark.location.coordinate.latitude, item.placemark.location.coordinate.longitude);
                query.address       = item.placemark.thoroughfare;
                
                [self.searchResults addObject:query];
            }
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView reloadData];

    }];
}

#pragma Table View Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchResultTableCell";
    SearchItemTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SearchItemTableCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    }
    SearchItem *item = (SearchItem*)[self.searchResults objectAtIndex:indexPath.row];
    cell.nameLabel.text = item.searchQuery;
    cell.addressLabel.text = item.address;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showResults"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        ResultsMapViewController *destViewController = segue.destinationViewController;
        SearchItem *item = (SearchItem*)[self.searchResults objectAtIndex:indexPath.row];
        NSLog(@"%@", item);
        destViewController.item = item;

    }
}

@end



