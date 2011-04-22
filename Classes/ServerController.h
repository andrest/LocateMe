//
//  ServerController.h
//  LocateMe
//
//  Created by Andres on 11/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "SBJsonParser.h"
#import "Thread.h"
#import "Reply.h"
#import "Post.h"
#import "Singleton.h"

// This section of the code will hopefully one day take care of all the server-client issues

@interface ServerController : NSObject
{
	NSURLConnection *theConnection;
	NSMutableData *receivedData;
	
	NSMutableArray *forumArray;
	
	Singleton *sharedVariables;
}
-(NSURLRequest*)requestWithString:(NSString*)string;
-(void)sendRequest:(NSURLRequest*)request;
-(void)updateRegionID;

@end
