//
//  Singleton.h
//  LocateMe
//
//  Created by Andres on 15/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ServerController;

@interface Singleton : NSObject {
	NSString* userLocation;
	NSNumber* regionID;
    ServerController *serverController;
	
	NSMutableArray *forumArray;
}

+ (id)sharedInstance;

@property (nonatomic, retain) NSString* userLocation;
@property (nonatomic, retain) NSNumber* regionID;
@property (nonatomic, retain) NSMutableArray* forumArray;
@property (nonatomic, retain) ServerController* serverController;


@end