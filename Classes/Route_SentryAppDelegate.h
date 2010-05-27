//
//  LocationsAppDelegate.h
//  Locations
//
//  Created by Saurabh Garg on 9/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface Route_SentryAppDelegate : NSObject <UIApplicationDelegate> {
	
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
    UIWindow *window;
	
	UINavigationController *navigationController;
}

- (IBAction)saveAction:sender;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) UINavigationController *navigationController;

@end

