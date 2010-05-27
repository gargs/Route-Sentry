//
//  Event.h
//  Locations
//
//  Created by Saurabh Garg on 9/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Event :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * zipCode;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * cityName;
@property (nonatomic, retain) NSString * stateName;

@end



