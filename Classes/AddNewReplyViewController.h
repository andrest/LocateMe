//
//  AddNewReplyViewController.h
//  LocateMe
//
//  Created by Andres on 23/03/2011.
//  Copyright 2011 Ventus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "ServerController.h"
#import "NSString+URLEncoding.h"

@interface AddNewReplyViewController : UIViewController {
    Singleton *sharedVariables;
    
    NSNumber *threadID;
    
    IBOutlet UITextView  *message;
}

- (void)addNewReply;

@property (nonatomic, retain) IBOutlet UITextView*  message;
@property (nonatomic, retain) NSNumber* threadID;

@end
