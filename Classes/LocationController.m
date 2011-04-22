//
//  LocationController.m
//  LocateMe
//
//  Created by Andres on 11/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#define WEBSERVER @"http://www.tuul.tl/"

#import "LocationController.h"

@implementation LocationController
@synthesize reverseGeocoder, delegate;

-(void)startLocating
{
	sharedVariables = [Singleton sharedInstance];
	
	// When was location last updated
	lastUpdated = nil;
	
	// Allocate and initialize the location manager
    locationManager = [[CLLocationManager alloc] init];
	
	// Set locationManager delegate the file itself
    [locationManager setDelegate:self];
	
    // We want all results from the location manager
    [locationManager setDistanceFilter:100];
    
    // And we want it to take as much time/power to get us those results
    [locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
    
	// Tell our manager to start looking for its location immediately
    [locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{	
	NSLog(@"[LOCATIONMANAGER]: Time since last update: %f, last update: %@", [lastUpdated timeIntervalSinceNow], lastUpdated);
	if ([lastUpdated timeIntervalSinceNow] >= -60 && lastUpdated != nil)
		return;
	
	[lastUpdated release];
	lastUpdated = [NSDate date];
	[lastUpdated retain];
	
	myReverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate: [newLocation coordinate]];
	[myReverseGeocoder setDelegate:self];
	[myReverseGeocoder start];
}

-(void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
	//NSDictionary *addressDict = [placemark addressDictionary];
	//NSString* address = ABCreateStringWithAddressDictionary(addressDict, YES);
	
	NSString *postcode = [[placemark postalCode] substringToIndex:2];
	
	NSCharacterSet *integers = [NSCharacterSet decimalDigitCharacterSet];
	
    // !!!!!
    // !!!!!!! CHANGE BACK!!!!!
    // !!!!!!!!
	//postcode = [postcode stringByTrimmingCharactersInSet: integers];
	postcode = @"OX";
	// If the location that corresponds to the new set of co-oridnates is the same
	// then return the function
	if ([sharedVariables.userLocation isEqualToString:postcode])
		return;
	
	sharedVariables.userLocation = postcode;
	
	// Pass on the area code to the delegate so an appropriate chatroom can be joined
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:@"newLocation" object:postcode];
	
	[geocoder release];
	
	/*
	
	// Create the request.
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@iphone.php", WEBSERVER]];
	// Create the request.
	NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:url
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:10.0];
	NSString *message = [NSString stringWithFormat:@"name=%@", postcode];
	NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
	
	[theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:messageData];
	
	// Create the connection with the request
	// and start loading the data
	NSURLConnection *myConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (myConnection) 
	{
		// Create the NSMutableData to hold the received data.
		// receivedData is an instance variable declared elsewhere.
		receivedData = [[NSMutableData data] retain];
	} 
	else 
	{
		// Inform the user that the connection failed.
	}
	*/
}

-(void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
	NSLog(@"MKReverseGeocoder has failed. With error:\n%@", [error localizedDescription]);
	lastUpdated = nil;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"locationManager has failed.");
}
/*
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
	
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
	
    // receivedData is an instance variable declared elsewhere.
	NSLog(@"Data received from the DB");
    [receivedData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Release the connection, and the data object
    [connection release];
    // ReceivedData is declared as a method instance elsewhere
    [receivedData release];
	
    // Inform the user
    NSLog(@"Connection failed! Error - %@",
          [error localizedDescription]);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
	
	NSString *someString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	someString = [someString stringByAppendingFormat:@"\n"];
	
	[[self delegate] messageFromServer:someString];
    [receivedData appendData:data];	
}
*/
@end
