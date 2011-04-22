//
//  Post.h
//  LocateMe
//
//  Created by Andres on 13/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Post : NSObject {
	NSString* messageBody;
	NSString* author;
	NSDate*   date;
	NSNumber* ID;

}

@property (nonatomic, retain) NSString* messageBody;
@property (nonatomic, retain) NSString* author;
@property (nonatomic, retain) NSDate* date;
@property (nonatomic, retain) NSNumber* ID;


@end
