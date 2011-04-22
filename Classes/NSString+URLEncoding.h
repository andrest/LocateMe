//
//  NSString+URLEncoding.h
//  LocateMe
//
//  Created by Andres on 24/03/2011.
//  Copyright 2011 Ventus. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSString (URLEncoding)
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;
@end