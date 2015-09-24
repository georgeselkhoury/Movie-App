//
//  MapViewController.m
//  Movie App
//
//  Created by Georges El Khoury on 9/23/15.
//  Copyright © 2015 Attendible. All rights reserved.
//

#import "MapViewController.h"


@interface MapViewController ()

@end



@implementation MapViewController {
    NSMutableDictionary *_dictionary;
    UISearchController *_searchController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dictionary = [[NSMutableDictionary alloc]init];
    
    self.title = @"Movies by Locations";
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 37.7833;
    zoomLocation.longitude= -122.4167;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 9000, 9000);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:@"https://movies-by-locations.herokuapp.com/locations?latitude=37.7833&longitude=-122.4167"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        for (NSDictionary* locationJson in jsonData) {
            
            MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = [[locationJson objectForKey:@"latitude"] doubleValue];
            coordinate.longitude = [[locationJson objectForKey:@"longitude"] doubleValue];
            point.coordinate = coordinate;
            point.title = [locationJson objectForKey:@"address"];
            point.subtitle = [locationJson objectForKey:@"fun_facts"];
            
            [_dictionary setObject:point forKey:locationJson];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mapView addAnnotation:point];
            });
        }
        
    }];
    
    [dataTask resume];
    
    
    [_mapView setRegion:viewRegion animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSArray*keys = [_dictionary allKeys];
    
    for (NSDictionary* locationJson in keys) {
        
        NSArray *movies = [locationJson objectForKey:@"movies"];
        
        BOOL isFound = NO;
        
        for (NSDictionary* movieJson in movies) {
            
            if ([[movieJson objectForKey:@"title"] rangeOfString:[searchBar text]].location == NSNotFound) {
                isFound = NO;
            } else {
                isFound = YES;
            }
        }
        
        if (!isFound) {
            [self.mapView removeAnnotation:[_dictionary objectForKey:locationJson]];
        }
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
      [self resetAndAllAnnotations];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        [self resetAndAllAnnotations];
    }
}

-(void)resetAndAllAnnotations {
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:[_dictionary allValues]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)searchButtonPressed:(id)sender {
    
    _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.delegate = self;
    [self presentViewController:_searchController animated:true completion:nil];
}




@end
