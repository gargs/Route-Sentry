//
//  LocationPlacemark.h
//  Locations
//
//  Created by Saurabh Garg on 9/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface LocationPlacemark : NSObject <MKAnnotation>{
	CLLocationCoordinate2D coordinate;
	NSString *subtitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithCoordinate: (CLLocationCoordinate2D) coordinateNew;

- (NSString *) title;
- (NSString *) subtitle;
- (void)setSubtitle: (NSString *)subtitleNew;

@end
