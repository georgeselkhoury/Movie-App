//
//  MapViewController.h
//  Movie App
//
//  Created by Georges El Khoury on 9/23/15.
//  Copyright © 2015 Attendible. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface MapViewController : UIViewController <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
