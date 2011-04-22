//
//  IRCController.h
//  LocateMe
//
//  Created by Andres on 11/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRCMessage.h"
#import "ChatViewController.h"
#import "Singleton.h"

@interface IRCController : NSObject <NSStreamDelegate> {
	NSString* userChannel;
	NSOutputStream *outputStream;
	NSInputStream  *inputStream;
	
	CFReadStreamRef readStream;
	CFWriteStreamRef writeStream;	
	
	BOOL firstLoc;
	Singleton *sharedVariables;
	
}
-(void)sendMessage:(NSString*)message;
-(void)locationUpdate:(NSNotification*)notification;
-(void)sendMessageNotification:(NSNotification*)notification;


@end
