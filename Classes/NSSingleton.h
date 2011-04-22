//
//  NSSingleton.h
//  TCCALC
//  ©Jean-Luc Pedroni
//
//  Created by Jean-Luc Pedroni on 12/05/08.
//  Mail: jeanluc.pedroni AT free.fr
//
//  Code provided as is, without warranty.
//  You can use it as you wish,
//  but please keep this header.
//

#import <Foundation/NSObject.h>

@interface NSSingleton : NSObject {
}

+(void)cleanup;
// Deux cas:
// . [NSSingleton cleanup]  : Free all singletons.
// . [MySingleton cleanup] : Free MySingleton.

+(id)sharedInstance;
// Notes :
// . +(id)sharedInstance can be overridden to return the right type..
//   ex : (MySingleton *)sharedInstance { return [super sharedInstance]; }
// . Singleton initialization must be done as usual in -(id)init.
//
@end