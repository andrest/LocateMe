//
//  IRCMessage.m
//  LocateMe
//
//  Created by Andres on 12/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IRCMessage.h"


@implementation IRCMessage
@synthesize nick, body;

+(IRCMessage*)messageWithNick:(NSString*)name message:(NSString*)msg;
{
	IRCMessage* newMessage = [[[IRCMessage alloc] init] autorelease];
	newMessage.nick = name;
	newMessage.body = msg;
	
	return newMessage;
}

@end
