//
//  IRCController.m
//  LocateMe
//
//  Created by Andres on 11/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#define IRCSERVER @"zone.ircworld.org"
#define IRCPORT 6667
#define USERNAME @"omegazBot"


#import "IRCController.h"
@implementation IRCController

-(id)init
{
	if (self = [super init])
	{
		sharedVariables = [Singleton sharedInstance];
		//userChannel = sharedVariables.userLocation;
		firstLoc = YES;
		
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(locationUpdate:)
		 name:@"newLocation"          
		 object:nil];
		
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(sendMessageNotification:)
		 name:@"sendMessage"          
		 object:nil];
		
		readStream = NULL;
		writeStream = NULL;

		// Create a socket to the IRC server and also create a read- and writeStream
		CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (CFStringRef)IRCSERVER, IRCPORT, &readStream, &writeStream);

		// If the connection is successful and the streams are opened then proceed to set them up
		if (readStream && writeStream) 
		{
			CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
			CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
			
			inputStream = (NSInputStream *)readStream;
			[inputStream retain];
			[inputStream setDelegate:self];
			[inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
			[inputStream open];
			
			outputStream = (NSOutputStream *)writeStream;
			[outputStream retain];
			[outputStream setDelegate:self];
			[outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
			[outputStream open];
		}

		// Send the required user details to the server
		NSString *connectionMessage = [NSString stringWithFormat:@"NICK %@\r\nUSER omegazBot Eesti ROKIB :Jossif Stalin\r\n", USERNAME];
		[self sendMessage:connectionMessage];
		//[self sendMessage:[NSString stringWithFormat:@"JOIN #%@\r\n", userLocation] stream:outputStream];
	}
	return self;
}

-(void)locationUpdate:(NSNotification*)notification
{
	if ([userChannel isEqualToString:[notification object]])
		return;
	
	if (firstLoc == NO)
	{
		[self sendMessage:[NSString stringWithFormat:@"PART #%@\r\n", userChannel]];
		[[NSNotificationCenter defaultCenter]
		 postNotificationName:@"displayMessage" 
		 object:[IRCMessage messageWithNick:@"SERVER" 
									message:@"Your location has changed, you will be switched to another channel shortly"]];
		[userChannel release];
	}
	else
	{
		firstLoc = NO;	 
	}
	
	userChannel = [notification object];
	[userChannel retain];
	[self sendMessage:[NSString stringWithFormat:@"JOIN #%@\r\n", userChannel]];
	
}

// A delegate function (of ChatViewController) which gets called when the user presses the OK button in the chatView
-(void)sendMessageNotification:(NSNotification*)notification;
{	
	// If the first character is a '/' then do not add the PRIVMSG prefix and send it as it is to the server
	// This allows a poweruser to execute all the available IRC commands which are unnecessary for the
	// application as such
	NSString* message = [[notification object] body];
	NSString* newMessage;
	
	unichar firstChar = [message characterAtIndex:0];
	if (firstChar == '/') 
	{
		NSRange realRange;
		realRange.location = 1;
		realRange.length = [message length] -1;
		message = [message substringWithRange:realRange];
		newMessage = [NSString stringWithFormat:@"%@\r\n", message];
	}
	else
	{
		/*
		IRCMessage* myMessage = [IRCMessage messageWithNick:USERNAME message:message];
		[[NSNotificationCenter defaultCenter]
		 postNotificationName:@"displayMessage" object:myMessage];
		*/
		
		newMessage = [NSString stringWithFormat:@"PRIVMSG #%@ :%@\r\n",userChannel , message];		
	}
	
	[self sendMessage:newMessage];
}

// This function, first, creates a buffer containing the message being sent (in a binary form) and
// writes this buffer to the outputStream
-(void)sendMessage:(NSString*)message
{	
	NSData* messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
	int dataLength = [messageData length];	
	
	uint8_t buffer[dataLength];
	[messageData getBytes:buffer length:dataLength];
	[outputStream write:buffer maxLength:dataLength];
}

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
								[self sendMessage:@"PONG zone.ircworld.org\r\n"];
							
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
								
								IRCMessage* myMessage = [IRCMessage messageWithNick:messageSender message:messageBody];
								
								// The message is output in the textView
								//chatViewTextView.text = [chatViewTextView.text stringByAppendingString: [NSString stringWithFormat:@"\n<%@> %@", messageSender, messageBody]];
								
								[[NSNotificationCenter defaultCenter]
								 postNotificationName:@"displayMessage" object:myMessage];
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



@end
