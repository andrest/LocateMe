//
//  ChatViewController.h
//  LocateMe
//
//  Created by Andres on 10/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
@class ChatViewController;
@protocol ChatViewControllerDelegate

-(void)chatButtonPressed:(NSString*)message;
//-(void)keyboardClosed;

@end
#import <UIKit/UIKit.h>
#import "LocationController.h"

@interface ChatViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UILabel *locationLabel;
	IBOutlet UILabel *headingLabel;
	IBOutlet UITextView *myTextView;
	IBOutlet UITextField *chatInputBox;
	IBOutlet UIButton *sendButton;
	
	id <ChatViewControllerDelegate> delegate;

	
	int test;
}
-(IBAction)keyboardDone;
-(IBAction)buttonPressed;
-(void)displayMessage:(NSNotification*)notification;






@property (nonatomic, assign) id <ChatViewControllerDelegate> delegate;
@property (nonatomic, assign) IBOutlet UITextView *myTextView;
@property (nonatomic, assign) IBOutlet UILabel *headingLabel;



@end
