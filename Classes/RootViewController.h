//
//  RootViewController.h
//  Locations
//
//  Created by Saurabh Garg on 9/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKReverseGeocoder.h>
#import <MessageUI/MessageUI.h>

@class MapViewController;

#define kGPSTime 6.0

@interface RootViewController : UITableViewController <CLLocationManagerDelegate, MKReverseGeocoderDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate, UINavigationControllerDelegate>{
	NSMutableArray *eventsArray;
	NSManagedObjectContext *managedObjectContext;
	
	CLLocationManager *locationManager;
	CLLocation *lmLocation;
	UIBarButtonItem *addButton;
	MKReverseGeocoder *geoCoder;
	NSString *zip;
	NSString *city;
	NSString *state;
	NSUInteger currentSelected;
	NSString *alertString;
	NSDate *launchTime;
	
	NSString *latitudeString;
	NSString *longitudeString;
	MapViewController *mapController;
}

@property (nonatomic, retain) NSMutableArray *eventsArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) UIBarButtonItem *addButton;
//@property (nonatomic, retain) MKReverseGeocoder *geoCoder;
@property (nonatomic, retain) NSString *zip;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *alertString;
@property (nonatomic, retain) NSString *latitudeString;
@property (nonatomic, retain) NSString *longitudeString;

-(void)addEvent;

@end
