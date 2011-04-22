//
//  IRCMessage.h
//  LocateMe
//
//  Created by Andres on 12/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IRCMessage : NSObject {
	NSString* body;
	NSString* nick;
	NSDate*   date;
}
+(IRCMessage*)messageWithNick:(NSString*)name message:(NSString*)msg;

@property (nonatomic, retain) NSString* body;
@property (nonatomic, retain) NSString* nick;
@end
