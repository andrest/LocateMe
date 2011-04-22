//
//  LocationController.h
//  LocateMe
//
//  Created by Andres on 11/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


// Here we set up a delegation protocol
@class LocationController;
@protocol LocationControllerDelegate <NSObject>

-(void)messageFromServer:(NSString*)message;
-(void)userLocation:(NSString*)location;

@end

// Delegate has been set up, after this business as usual
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AddressBookUI/AddressBookUI.h>

#import "IRCController.h"
#import "ServerController.h"

@class Singleton;

@interface LocationController : NSObject <MKReverseGeocoderDelegate, CLLocationManagerDelegate>  
{
	NSString* newLoc;
	Singleton* sharedVariables;
	
	CLLocationManager *locationManager;
	MKReverseGeocoder *myReverseGeocoder;
	NSDate *lastUpdated;
	NSMutableString *myLocation;
	
	//NSURLConnection *theConnection;
	//NSMutableData *receivedData;
	
	// Delegate ID
	id <LocationControllerDelegate> delegate;
}

- (void)startLocating;

@property (nonatomic, retain) MKReverseGeocoder *reverseGeocoder;
// Delegate ID also needs accessor methods
@property (nonatomic, assign) id <LocationControllerDelegate> delegate;

@end