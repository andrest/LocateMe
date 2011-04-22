//
//  WebServerController.m
//  LocateMe
//
//  Created by Andres on 11/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define WEBSERVER @"http://www.tuul.tl/"

#import "WebServerController.h"


@implementation WebServerController

-(void)createRequest
{
	// Pass on the area code to the delegate so an appropriate chatroom can be joined
	[[self delegate] userLocation:postcode];

	// Create the request.
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@iphone.php", WEBSERVER]];
	// Create the request.
	NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:url
														cachePolicy:NSURLRequestUseProtocolCachePolicy
													timeoutInterval:10.0];
	NSString *message = [NSString stringWithFormat:@"name=%@", postcode];
	NSData *messageData = [message dataUsingEncoding:NSASCIIStringEncoding];

	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody:messageData];
}

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
	
	NSString *someString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	someString = [someString stringByAppendingFormat:@"\n"];
	
	[[self delegate] messageFromServer:someString];
    [receivedData appendData:data];	
}


@end
