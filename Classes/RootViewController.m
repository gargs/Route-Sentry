//
//  RootViewController.m
//  Locations
//
//  Created by Saurabh Garg on 9/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "LocationsAppDelegate.h"
#import "Event.h"
#import "MapViewController.h"

@implementation RootViewController

@synthesize eventsArray;
@synthesize managedObjectContext;
@synthesize locationManager;
@synthesize addButton;
//@synthesize geoCoder;
@synthesize zip;
@synthesize city;
@synthesize state;

@synthesize alertString;
@synthesize latitudeString;
@synthesize longitudeString;


#pragma mark -
#pragma mark Location Manager Methods

-(CLLocationManager *)locationManager {
	if (locationManager != nil) {
		return locationManager;
	}
	
	locationManager = [[CLLocationManager alloc] init];
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	locationManager.delegate=self;
	
	return locationManager;
}

- (void)locationManager: (CLLocationManager *)manager 
	didUpdateToLocation: (CLLocation *)newLocation
		   fromLocation: (CLLocation *)oldLocation {
	
	[locationManager stopUpdatingLocation];
	lmLocation = [newLocation copy];
	
	geoCoder = [[MKReverseGeocoder alloc]initWithCoordinate:[newLocation coordinate]];
	geoCoder.delegate = self;
	[geoCoder start];
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError: (NSError *)error {
	//Add code to let the user know that the location manager failedvia an alert
	UIAlertView *locationFailAlert = [[UIAlertView alloc] initWithTitle:@"GPS Error" 
																message:@"Failed to obtain precise location" 
															   delegate:self 
													  cancelButtonTitle:@"OK" 
													  otherButtonTitles:nil];
	[locationFailAlert show];
	[locationFailAlert release];
	
	
	addButton.enabled = NO;
}

#pragma mark -
#pragma mark Custom Methods

-(void)addEvent {	
	CLLocation *location = [locationManager location];
	if (!location) 
		return;
	
	// Create and configure a new instance of the Event entity
	Event *event = (Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:managedObjectContext];
	
	CLLocationCoordinate2D coordinate = [location coordinate];
	
	[event setLatitude:[NSNumber numberWithDouble:coordinate.latitude]];
	[event setLongitude:[NSNumber numberWithDouble:coordinate.longitude]];
	[event setCreationDate:[NSDate date]];
	[event setZipCode:zip];
	[event setCityName:city];
	[event setStateName:state];
	
	NSError *error;
	if (![managedObjectContext save:&error]) {
		// Handle the error
	}
	
	[eventsArray insertObject:event atIndex:0];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0	inSection:0];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)reverseGeocoderFailed {
	[addButton release];
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
	[activityIndicator startAnimating];
	addButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	[activityIndicator release];
	self.navigationItem.rightBarButtonItem = addButton;
	
	[geoCoder release];
	geoCoder = [[MKReverseGeocoder alloc]initWithCoordinate:[lmLocation coordinate]];
	geoCoder.delegate = self;
	[geoCoder start];
}

#pragma mark -
#pragma mark UITableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [eventsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    // A date formatter for the time stamp
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
	
    // A number formatter for the latitude and longitude
    static NSNumberFormatter *numberFormatter = nil;
    if (numberFormatter == nil) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [numberFormatter setMaximumFractionDigits:3];
    }
	
    static NSString *CellIdentifier = @"Location Cell";
	
    // Dequeue or create a new cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
    Event *event = (Event *)[eventsArray objectAtIndex:indexPath.row];
	
    cell.textLabel.text = [dateFormatter stringFromDate:[event creationDate]];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"City: %@, %@ Zip: %@",[event cityName], [event stateName], [event zipCode]];
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
	// A number formatter for the latitude and longitude
    static NSNumberFormatter *numberFormatter = nil;
    if (numberFormatter == nil) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [numberFormatter setMaximumFractionDigits:3];
    }
	
	Event *event = (Event *) [eventsArray objectAtIndex:indexPath.row];
	currentSelected = indexPath.row;
	
	NSString *lat = [numberFormatter stringFromNumber:[event latitude]];
	self.latitudeString = [NSString stringWithString:lat];
	
	NSString *longt = [numberFormatter stringFromNumber:[event longitude]];
	self.longitudeString = [NSString stringWithString:longt];
	
	NSString *tempString = (NSString *)[NSString stringWithFormat:@"The latitude was %@. The longitude was %@", latitudeString, longitudeString];
	self.alertString = tempString;	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Coordinates" 
													message:tempString
												   delegate:self 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:@"Email",@"Tweet", nil];
	[alert show];
	[alert release];
}

- (void) tableView: (UITableView* )tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *)indexPath {

	// A date formatter for the time stamp
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
	
	if (mapController == nil)
		mapController = [[MapViewController alloc] initWithNibName:@"MapView" bundle:nil];
	
	Event *event = (Event *) [eventsArray objectAtIndex:indexPath.row];
	
	mapController.title = @"Map View";
	CLLocationDegrees latitude = [[event latitude] doubleValue];
	CLLocationDegrees longitude = [[event longitude] doubleValue];
	CLLocation *locationExisting = [[CLLocation alloc]initWithLatitude: latitude longitude: longitude];
	mapController.location = locationExisting;
	mapController.locationDateTime = [dateFormatter stringFromDate:[event creationDate]];
	
	[self.navigationController pushViewController:mapController animated:YES];
	[locationExisting release];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *) indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		//Delete the managed object at the given index path
		NSManagedObject *eventToDelete = [eventsArray objectAtIndex:indexPath.row];
		[managedObjectContext deleteObject:eventToDelete];
		
		//Update the array and table view
		[eventsArray removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		
		//Commit the change
		NSError *error;
		if (![managedObjectContext save:&error]) {
			//Handle the error
		}
	}
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

#pragma mark -
#pragma mark MKReverseGeocoderDelegate Methods

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	zip = placemark.postalCode;
	city = placemark.locality;
	state = placemark.administrativeArea;
	[city retain];
	[zip retain];
	[state retain];
	//NSLog(@"Reverse geocoder completed. Postal code is %@", zipCode);
	[addButton release];
	addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
															  target:self
															  action:@selector(addEvent)];
	self.navigationItem.rightBarButtonItem = addButton;
	addButton.enabled = YES;
	[lmLocation release];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	UIAlertView *geocoderError = [[UIAlertView alloc] initWithTitle:@"Geocoder Error" 
															message:@"Geocoder failed to obtain location information" 
														   delegate:self 
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
	[geocoderError show];
	[geocoderError release];
	
	[addButton release];
	
	//CLLocation newLocation = [[CLLocation alloc] initWithLatitude:[ longitude:longitude];
	addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
															  target:self 
															  action:@selector(reverseGeocoderFailed)];
	self.navigationItem.rightBarButtonItem = addButton;
	addButton.enabled = YES;
}

 
#pragma mark -
#pragma mark Controller Methods

- (void)viewDidLoad {
	[super viewDidLoad];
	
	//Store the time at launch
	launchTime = [NSDate date];	
	
	//Set the title
	self.title = @"Route Sentry";
	
	//Set the buttons
	self.navigationItem.leftBarButtonItem=self.editButtonItem;
	
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
	[activityIndicator startAnimating];
	addButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	[activityIndicator release];
	self.navigationItem.rightBarButtonItem = addButton;
	
	// Start the location manager
	[[self locationManager] startUpdatingLocation];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
	//Sort them chronologically
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	NSError *error;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		//Handle the error
	}
	
	[self setEventsArray:mutableFetchResults];
	[mutableFetchResults release];
	[request release];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.eventsArray = nil;
	self.locationManager = nil;
	self.addButton = nil;
	mapController = nil;
	mapController = nil;
	latitudeString = nil;
	longitudeString = nil;
	alertString = nil;
	geoCoder = nil;
	lmLocation = nil;
	launchTime = nil;
}


- (void)dealloc {
	[managedObjectContext release];
	[eventsArray release];
	[locationManager release];
	[addButton release];
	[geoCoder release];
	[zip release];
	[city release];
	[state release];
	[mapController release];
	[lmLocation release];
	[launchTime release];
	[super dealloc];
}

#pragma mark -
#pragma mark UIAlertView delegate Actions

/*
- (void)alertView: (UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	[self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:currentSelected inSection:0] animated:YES];
	[alertString release];
}
 */

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex: (NSInteger)buttonIndex {
	[self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:currentSelected inSection:0] animated:YES];
	if (buttonIndex == 1) {
		if ([MFMailComposeViewController canSendMail]) {
			MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
			mailController.mailComposeDelegate = self;
			
			//Generate Google Maps URI
			NSString *latlong = [NSString stringWithFormat:@"%@,%@", latitudeString, longitudeString];
			NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps?q=iPhone+location@%@", [latlong stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			
			[mailController setSubject:@"Check out this location!"];
			NSString *messageBody = [NSString stringWithFormat:@"%@\n\n%@",alertString, url];
			[mailController setMessageBody:messageBody isHTML:NO];
			
			//Now display a modal view
			[self presentModalViewController:mailController animated:YES];
			[mailController release];
		}
	}
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
}
		

@end
