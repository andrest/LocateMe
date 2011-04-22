//
//  AddNewTopicViewController.h
//  LocateMe
//
//  Created by Andres on 23/03/2011.
//  Copyright 2011 Ventus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "ServerController.h"
#import "SBJsonWriter.h"
#import "NSString+URLEncoding.h"

@interface AddNewTopicViewController : UIViewController {
    Singleton *sharedVariables;
    
    IBOutlet UITextView  *message;
    IBOutlet UITextField *headline;
}

- (void)addNewTopic;

@property (nonatomic, retain) IBOutlet UITextView*  message;
@property (nonatomic, retain) IBOutlet UITextField* headline;

@end
