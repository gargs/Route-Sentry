//
//  MapViewController.m
//  Locations
//
//  Created by Saurabh Garg on 9/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "LocationPlacemark.h"


@implementation MapViewController

@synthesize mapView;
@synthesize location;
@synthesize locationDateTime;
@synthesize mapTypeSelector;

#pragma mark -
#pragma mark UIViewController Methods

- (void)viewWillAppear:(BOOL)animated {	
	[self.navigationController setNavigationBarHidden:NO animated: animated];

	MKCoordinateRegion region;
	MKCoordinateSpan span;
	
	span.latitudeDelta = 0.02;
	span.longitudeDelta = 0.02;
	
	region.span = span;
	region.center = [location coordinate];
	
	[mapView setRegion:region animated:FALSE];
	[mapView regionThatFits:region];
	
	locationPlacemark = [[LocationPlacemark alloc] initWithCoordinate:[location coordinate]];
	[locationPlacemark setSubtitle:locationDateTime];
	[mapView addAnnotation:locationPlacemark];
	[locationPlacemark release];
	
	//Insert button to center map
	UIBarButtonItem *centerButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"map-marker.png"] 
																	 style:UIBarButtonItemStylePlain
																	target:self 
																	action:@selector(centerMap)];
	self.navigationItem.rightBarButtonItem = centerButton;
	[centerButton release];
	centerButton.enabled = YES;
	
	[super viewWillAppear:animated];
}

/*
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
	MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
	annView.animatesDrop=FALSE;
	return annView;
}
*/

- (void)viewDidAppear:(BOOL)animated {
	[mapView selectAnnotation:locationPlacemark animated:NO];
	[super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	self.navigationItem.rightBarButtonItem = nil;
	[super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[mapView removeAnnotation:locationPlacemark];
	[super viewWillDisappear:animated];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	mapView.showsUserLocation = FALSE;
	mapView.mapType = MKMapTypeStandard;
	mapView.delegate = self;
}
-(void)viewDidUnload {
	self.mapView = nil;
	[super viewDidUnload];
}

- (void)dealloc {
	[mapView release];
	[location release];
	[locationDateTime release];
	[mapTypeSelector release];
	[super dealloc];
}

#pragma mark -
#pragma mark MapView Methods

 
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mView {
	[mapView selectAnnotation:locationPlacemark animated:NO];
}

- (IBAction)changeMapType: (id)sender {
	if (mapTypeSelector.selectedSegmentIndex == 0)
		mapView.mapType = MKMapTypeStandard;
	else if (mapTypeSelector.selectedSegmentIndex == 1)
		mapView.mapType = MKMapTypeSatellite;
	else 
		mapView.mapType = MKMapTypeHybrid;
}

- (void)centerMap {
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	
	span.latitudeDelta = 0.02;
	span.longitudeDelta = 0.02;
	
	region.span = span;
	region.center = [location coordinate];
	
	[mapView setRegion:region animated:YES];
	[mapView regionThatFits:region];
}

@end
