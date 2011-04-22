//
//  ServerController.m
//  LocateMe
//
//  Created by Andres on 11/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#define WEBSERVER @"http://www.tuul.tl/"

#import "ServerController.h"


@implementation ServerController

-(id)init
{
	if (self = [super init])
	{
		
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(updateRegionID:)
		 name:@"newLocation"          
		 object:nil];
				
		sharedVariables = [Singleton sharedInstance];
		
		sharedVariables.forumArray = [[NSMutableArray alloc] init];

	}
	return self;
}

-(NSURLRequest*)requestWithString:(NSString*)string
{
	// Create the request.
	NSString *theString = [NSString stringWithFormat:@"%@iphone.php?", WEBSERVER];
	NSURL *url = [NSURL URLWithString: theString];
	// Create the request.
	NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:10.0];

	NSString *message = [NSString stringWithFormat:@"%@", string];
	NSLog(@"The request being sent: %@%@", theString, message);
	NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];

	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody:messageData];
	
	return theRequest;
}

-(void)updateRegionID:(NSNotification*)notification
{
	NSString *regionName = [notification object];
	NSURLRequest *request = [self requestWithString: [NSString stringWithFormat:@"getRegionID=%@", regionName]];
	[self sendRequest: request];
}
/*
-(NSArray*)threadList:(NSArray*)threadArray regionID:(int)ID
{
	
}
*/
-(void)sendRequest:(NSURLRequest*)request
{
	// Create the connection with the request
	// and start loading the data
	NSURLConnection *myConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
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
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
	
	NSString *someString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];	
	NSLog(@"[APACHE]: %@", someString);
	
	// Parse JSON results with TouchJSON. It converts it into a dictionary.
	SBJsonParser* myParser = [[SBJsonParser alloc] init];
	NSArray *resultsArray = [myParser objectWithData:receivedData];
	//NSLog(@"JSON ARRAY: \n%@", [resultsArray objectAtIndex:0]);
	
	NSString *event = [resultsArray objectAtIndex:0];


	if ([event isEqualToString: @"getRegionID"])
	{
		NSString* regionID = [[resultsArray objectAtIndex:1] objectForKey:@"regionID"];
		NSLog(@"The region ID is: %@", regionID);
		[sharedVariables setRegionID:[NSNumber numberWithInt:[regionID intValue]]];
	}
	else if ([event isEqualToString: @"getThreadList"])
	{
		// Gotta gut the chicken before you stuff it
		[forumArray removeAllObjects]; 
		
		for (int i = 1; i <= [resultsArray count]-1; i++) {
			NSDictionary *dict = [resultsArray objectAtIndex:i];

			NSLog(@"\nthreadID: %@ \nthreadName: %@",
				  [dict objectForKey:@"threadID"], [dict objectForKey:@"threadName"]
				  );
			
			Thread *newThread = [[Thread alloc] init];
			newThread.ID = [NSNumber numberWithInt:[[dict objectForKey:@"theadID"] intValue]];
			newThread.name = [dict objectForKey:@"threadName"];
			
			[sharedVariables.forumArray addObject:newThread];
		}
	}
	else if ([event isEqualToString: @"getThread"])
	{
		BOOL exists = NO;
		Thread* newThread = [[Thread alloc] init];
		NSMutableArray* repliesArray = [[NSMutableArray alloc] init];
		
		NSDictionary *dict = [resultsArray objectAtIndex:1];
		NSLog(@"\nthreadID: %@ \nthreadName: %@ \ndate: %@ \nmessageBody: %@",
			  [dict objectForKey:@"threadID"], [dict objectForKey:@"threadName"],
			  [dict objectForKey:@"date"], [dict objectForKey:@"messageBody"]);
		
		newThread.ID = [NSNumber numberWithInt:[[dict objectForKey:@"theadID"] intValue]];
		newThread.name = [dict objectForKey:@"threadName"];
		newThread.date = [dict objectForKey:@"date"];
		newThread.messageBody = [dict objectForKey:@"messageBody"];
		newThread.author = [dict objectForKey:@"author"];
		
		
		NSArray *replies = [dict objectForKey:@"replies"];
		for (int i = 0; i <= [replies count]-1; i++) {
			NSDictionary *replyDict = [replies objectAtIndex:i];
			
			NSLog(@"\n	replyID: %@ \n	author: %@ \n	date: %@ \n	messageBody: %@",
				  [replyDict objectForKey:@"replyID"], [replyDict objectForKey:@"author"],
				  [replyDict objectForKey:@"date"], [replyDict objectForKey:@"messageBody"]);
		
			Reply *newReply = [[Reply alloc] init];
			newReply.ID = [NSNumber numberWithInt:[[replyDict objectForKey:@"replyID"] intValue]];
			newReply.author = [replyDict objectForKey:@"author"];
			newReply.date = [replyDict objectForKey:@"date"]; 
			newReply.messageBody = [replyDict objectForKey:@"messageBody"];
			
			[repliesArray addObject:newReply];
		}
		
		newThread.replies = repliesArray;
		
		if ([forumArray count] >= 1)
		{

			for (int i = 0; i <= [forumArray count]; i++)
			{
				if ([[[forumArray objectAtIndex:i] ID] isEqualToNumber:newThread.ID])
				{
					exists = YES;
					[forumArray insertObject:newThread atIndex:i];
				}
			}
		}
		
		if (exists == NO) {
			[sharedVariables.forumArray addObject:newThread];
		}
		
	}
	else if ([event isEqualToString: @"getThreadsForRegionID"])
	{
        // Gotta gut the chicken before you stuff it
		[sharedVariables.forumArray removeAllObjects]; 
		
		for (int i = 1; i <= [resultsArray count]-1; i++) 
        {
			NSDictionary *dict = [resultsArray objectAtIndex:i];

            BOOL exists = NO;
            Thread* newThread = [[Thread alloc] init];
            NSMutableArray* repliesArray = [[NSMutableArray alloc] init];
            
            NSLog(@"\nthreadID: %@ \nthreadName: %@ \ndate: %@ \nmessageBody: %@",
                  [dict objectForKey:@"threadID"], [dict objectForKey:@"threadName"],
                  [dict objectForKey:@"date"], [dict objectForKey:@"messageBody"]);
            
            newThread.ID = [NSNumber numberWithInt:[[dict objectForKey:@"theadID"] intValue]];
            newThread.name = [dict objectForKey:@"threadName"];
            newThread.date = [dict objectForKey:@"date"];
            newThread.messageBody = [dict objectForKey:@"messageBody"];
            newThread.author = [dict objectForKey:@"author"];
            
            [sharedVariables.forumArray addObject:newThread];
            
            NSArray *replies = [dict objectForKey:@"replies"];
            if ([replies isEqual:[NSNull null]] || [replies count] <= 0)
                continue;
            
            for (int y = 0; y <= [replies count]-1; y++) {
                NSDictionary *replyDict = [replies objectAtIndex:y];
                
                NSLog(@"\n	replyID: %@ \n	author: %@ \n	date: %@ \n	messageBody: %@",
                      [replyDict objectForKey:@"replyID"], [replyDict objectForKey:@"author"],
                      [replyDict objectForKey:@"date"], [replyDict objectForKey:@"messageBody"]);
                
                Reply *newReply = [[Reply alloc] init];
                newReply.ID = [NSNumber numberWithInt:[[replyDict objectForKey:@"replyID"] intValue]];
                newReply.author = [replyDict objectForKey:@"author"];
                newReply.date = [replyDict objectForKey:@"date"]; 
                newReply.messageBody = [replyDict objectForKey:@"messageBody"];
                
                [repliesArray addObject:newReply];
            }
            
            newThread.replies = repliesArray;

            [[sharedVariables.forumArray objectAtIndex:[sharedVariables.forumArray count]-1] setReplies:repliesArray];
            
        }
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"forumArrayUpdate" object:@"getThreadsForRegionID"];
        
        /*
        
		// -1 because the first item is the function name and last is the replies array
		int arrayItems = [resultsArray count] - 1;
		for (int i = 1; i <= arrayItems; i++) {
			NSDictionary* dict = [resultsArray objectAtIndex:i];
			NSLog(@"\nthreadID: %@ \nthreadName: %@ \ndate: %@ \nmessageBody: %@",
				  [dict objectForKey:@"threadID"], [dict objectForKey:@"threadName"],
				  [dict objectForKey:@"date"], [dict objectForKey:@"messageBody"]);
         */
    }
	

    // release the connection, and the data object
    [connection release];
    //[receivedData release];
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
/*
+(NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response error:(NSError **)error
{
	
}
*/
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.

	//[mySocket readDataWithTimeout:-1 tag:0];
    [receivedData appendData:data];	
}

@end
