//
//  LocateMeAppDelegate.m
//  LocateMe
//
//  Created by Andres on 12/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#define IRCSERVER @"zone.ircworld.org"
#define IRCPORT 6667
#define USERNAME @"omegazBot"

#import "LocateMeAppDelegate.h"


@implementation LocateMeAppDelegate

@synthesize window, myButton;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Add the TabBarController view to the main view
	[window addSubview:myTabBarController.view];
	
	// Start the GPS module and start locating the user
	myLocationController = [[LocationController alloc] init];
	[myLocationController startLocating];
	
	//myIRCController = [[IRCController alloc] init];

	myServerController = [[ServerController alloc] init];
	//NSLog(@"THE LOCATION ID: %i", [myServerController regionIDwithLocation:@"OX"]);
    
    sharedVariables.serverController = myServerController;
    sharedVariables.regionID = [[NSNumber alloc] init];
    
	[myServerController sendRequest: [myServerController requestWithString:@"getThreadsForRegionID=1"]];
    
	Singleton* sharedVariables = [Singleton sharedInstance];
    sharedVariables.serverController = myServerController;
	//[sharedVariables setUserLocation:@"BANANA"];
	
	//[myLocationController setDelegate:myIRCController];
	
	// Set the delegate of myLocationController to be self
	//[myLocationController setDelegate:self];
	
	//userLocation = [[NSString alloc] init];
	
	//myChatViewController.headingLabel.text = @"SPARTA AS WELL";
	//myChatViewController = [myTabBarController.viewControllers objectAtIndex:0];
	
	//ChatViewController *theChatViewController = [[ChatViewController alloc] init];
	//myChatViewController.delegate = self;

	//chatViewArray = myChatViewController.view.subviews;
	//chatViewTextView = [chatViewArray objectAtIndex:0];
	
    [window makeKeyAndVisible];
	
    return YES;
}
/*
-(void)userLocation:(NSString *)location
{
	//<- PROBLEM: If reverseGeocoder fails then there will be no location and no channel will be joined, the user will have to be notified 
	
	NSString *message = [NSString stringWithFormat:@"JOIN #%@\r\n", location];
	
	sendMessage(message, outputStream);
	userLocation = location;
	[userLocation retain];
 
}
*/
/*
// A delegate function (of ChatViewController) which gets called when the user presses the OK button in the chatView
-(IBAction)chatButtonPressed:(NSString*)message;
{	
	// If the first character is a '/' then do not add the PRIVMSG prefix and send it as it is to the server
	// This allows a poweruser to execute all the available IRC commands which are unnecessary for the
	// application as such
	unichar firstChar = [message characterAtIndex:0];
	if (firstChar == '/') 
	{
		NSRange realRange;
		realRange.location = 1;
		realRange.length = [message length] -1;
		message = [message substringWithRange:realRange];
		message = [NSString stringWithFormat:@"%@\r\n", message];
	}
	else
	{
		chatViewTextView.text = [chatViewTextView.text stringByAppendingFormat:@"\n<Me> %@", message];
		message = [NSString stringWithFormat:@"PRIVMSG #%@ :%@\r\n", userLocation, message];
	}
	
	sendMessage(message, outputStream);
}

// This function, first, creates a buffer containing the message being sent (in a binary form) and
// writes this buffer to the outputStream
void sendMessage(NSString *message, NSOutputStream* outputStream)
{	
	NSData* messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
	int dataLength = [messageData length];	
	
	uint8_t buffer[dataLength];
	[messageData getBytes:buffer length:dataLength];
	[outputStream write:buffer maxLength:dataLength];
}
*/
// This function is a delegate function (of locationController) which gets called when the when the
// LocationController has received data from the webserver after inputting the user location into
// the database

/*
// A delegate function for both inputStream and outputStream, is called any time the runloop finds
// that the streams have been changed
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
	NSString *io;
		
	if (theStream == inputStream) io = @"INPUT >>";
	else io = @"OUTPUT <<";
	
	NSString *event;
	switch (streamEvent)
	{
		case NSStreamEventNone:
			event = @"NSStreamEventNone";
			NSLog(@"Can not connect to the host!");
			break;
		case NSStreamEventOpenCompleted:
			event = @"NSStreamEventOpenCompleted";
			break;
			
		// Means that there is something waiting to be read in the stream
		case NSStreamEventHasBytesAvailable:
			event = @"NSStreamEventHasBytesAvailable";

			if (theStream == inputStream)
			{
				uint8_t buffer[1024];
				int len;
				while ([inputStream hasBytesAvailable])
				{
					len = [inputStream read:buffer maxLength:sizeof(buffer)];
					if (len > 0)
					{
						NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSUTF8StringEncoding];
						if (nil != output)
						{
							// If a PING command is issued by the server the client needs to return a PONG command to the server
							// as soon as possible, otherwise the client will be disconnected
							NSRange serverPingRange = [output rangeOfString:@"PING :zone.ircworld.org"];
							if (serverPingRange.location != NSNotFound)
								sendMessage(@"PONG zone.ircworld.org\r\n", outputStream);
							
							// If a message is sent to the channel the user is in
							NSRange messageRange = [output rangeOfString:@"PRIVMSG #"];
							if (messageRange.location != NSNotFound) 
							{
								// In this section the message body and username are extracted from rest of the output
								// and written to the ChatViewTextView
								
								NSRange messageStartRange;
								messageStartRange.location = messageRange.location + messageRange.length;
								messageStartRange.length = [output length] - messageStartRange.location;
								
								messageStartRange = [output rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet] options:NSCaseInsensitiveSearch range:messageStartRange];
								// The Message syntax is: 'PRIVMSG #channel :this is the message'
								messageStartRange.location += 1;
								
								NSRange messageEndRange;
								messageEndRange.location = messageStartRange.location;
								messageEndRange.length = [output length] - messageEndRange.location;
								messageEndRange = [output rangeOfString:@"\r\n" options: NSCaseInsensitiveSearch range:messageEndRange];
								
								NSRange messageBodyRange;
								messageBodyRange.location = messageStartRange.location + 1;
								messageBodyRange.length = messageEndRange.location - messageStartRange.location - 1;
								
								NSString *messageBody = [output substringWithRange:messageBodyRange];
								
								NSRange nickEndRange;
								nickEndRange.location = 1;
								nickEndRange.length = messageRange.location;
								nickEndRange = [output rangeOfString:@"!" options: NSCaseInsensitiveSearch range: nickEndRange];
								
								NSRange nickRange;
								nickRange.location = 1;
								nickRange.length = nickEndRange.location - 1;
								
								NSString *messageSender = [output substringWithRange:nickRange];
								
								// The message is output in the textView
								chatViewTextView.text = [chatViewTextView.text stringByAppendingString: [NSString stringWithFormat:@"\n<%@> %@", messageSender, messageBody]];
							}
							// This function writes out all the incoming messages, including those that are deliberately ignored
							// in the case of my application, such as PING requests, NOTICE request etc..
							NSLog(@"\n[START]\n%@\n[END]", output);
							[output release];
						}
					}
				}
			}
			break;
			
		case NSStreamEventHasSpaceAvailable:
			event = @"NSStreamEventHasSpaceAvailable";
			break;
			
		case NSStreamEventErrorOccurred:
			event = @"NSStreamEventErrorOccurred";
			NSLog(@"Can not connect to the host!");
			break;
			
		case NSStreamEventEndEncountered:
			event = @"NSStreamEventEndEncountered";
			[theStream close];
			[theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
			[theStream release];
			theStream = nil;
			break;
			
		default:
			event = @"** Unknown";
	}
	
	NSLog(@"%@ : %@", io, event);
}
*/

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[myTabBarController release];
    [window release];
    [super dealloc];
}

@end