//
//  Thread.h
//  LocateMe
//
//  Created by Andres on 13/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"

@class Reply;

@interface Thread : Post {
	NSString* name;
	NSMutableArray* replies;   
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSMutableArray* replies;

@end
