//
//  MySingleton.m
//  test singleton
//
//  Created by Jean-Luc Pedroni on 12/05/08.
//  Mail: jeanluc.pedroni AT free.fr
//
//  You can use it as you wish,
//  but please keep this header.
//
#import "MySingleton.h"

@implementation MySingleton

@synthesize userLocation, locationID;
@synthesize value = _value;

-(void)dealloc
{
	[super dealloc];
	
	//
	// MySingleton cleanup.
	//
}

-(id)init
{
	id _self_ = [super init];
	
	if (_self_ != nil) {
		self = _self_;
		_value = 1;
		
		userLocation = @"";
		locationID = 0;
	}
	
	return (_self_);
}

+(MySingleton *)sharedMySingleton
{
	return (MySingleton *)[super sharedInstance];
}

@end