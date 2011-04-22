//
//  LocateMeAppDelegate.h
//  LocateMe
//
//  Created by Andres on 12/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "LocationController.h"
#import "ChatViewController.h"
#import "PostViewController.h"
#import "IRCController.h"

@class Singleton;
@class ChatViewController;
@class ServerController;

@interface LocateMeAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;

	LocationController *myLocationController;
	ChatViewController *myChatViewController;
	PostViewController *myPostViewController;
	IRCController      *myIRCController;
	ServerController   *myServerController;
	int i;
	
	NSOutputStream *outputStream;
	NSInputStream  *inputStream;
	
	NSArray *chatViewArray;
	UITextView *chatViewTextView;
	
	CFReadStreamRef readStream;
	CFWriteStreamRef writeStream;

	IBOutlet UITabBarController*  myTabBarController;
	IBOutlet UITextField *chatInputBox;
	
	Singleton* sharedVariables;
	
	//NSString* userLocation;
}

@property (nonatomic, retain) IBOutlet UIButton *myButton;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@end

