//
//  MySingleton.h
//  test singleton
//
//  Created by Jean-Luc Pedroni on 12/05/08.
//  Mail: jeanluc.pedroni AT free.fr
//
//  You can use it as you wish,
//  but please keep this header.
//
//#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSSingleton.h"

@interface MySingleton : NSSingleton
{
@private
	int _value;
	NSString* userLocation;
	int locationID;
}

@property (nonatomic) int value;
@property (nonatomic) NSString* userLocation;
@property (nonatomic) int locationID;

+(MySingleton *)sharedMySingleton;
@end