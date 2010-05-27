//
//  MapViewController.h
//  Locations
//
//  Created by Saurabh Garg on 9/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class LocationPlacemark;

@interface MapViewController : UIViewController <MKMapViewDelegate>{
	IBOutlet MKMapView *mapView;
	CLLocation *location;
	LocationPlacemark *locationPlacemark;
	NSString *locationDateTime;
	IBOutlet UISegmentedControl *mapTypeSelector;
}

@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, retain) NSString *locationDateTime;
@property (nonatomic, retain) UISegmentedControl *mapTypeSelector;

- (IBAction)changeMapType: (id)sender;

@end
