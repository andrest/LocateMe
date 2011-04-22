//
//  ChatViewController.m
//  LocateMe
//
//  Created by Andres on 10/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#define kOFFSET_FOR_KEYBOARD 170.0


#import "ChatViewController.h"
@class IRCMessage;
@implementation ChatViewController
@synthesize myTextView, headingLabel, delegate;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
-(void)viewDidLoad 
{
	[self loadView];
	[super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(displayMessage:)
	 name:@"displayMessage"          
	 object:nil];
}

-(void)displayMessage:(NSNotification*)notification
{
	IRCMessage* message = [notification object];
	myTextView.text = [myTextView.text stringByAppendingFormat:@"\n<%@> %@", message.nick, message.body];
}

-(IBAction)buttonPressed;
{	
	IRCMessage *message = [IRCMessage messageWithNick:@"Me" message:[chatInputBox text]];
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:@"displayMessage" object:message];
	
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:@"sendMessage" object:message];
	
	chatInputBox.text = @"";
}

-(IBAction)keyboardDone
{
	[chatInputBox resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	chatInputBox.frame = CGRectMake(chatInputBox.frame.origin.x, (chatInputBox.frame.origin.y - 170.0), chatInputBox.frame.size.width, chatInputBox.frame.size.height);
	sendButton.frame = CGRectMake(sendButton.frame.origin.x, (sendButton.frame.origin.y - 170.0), sendButton.frame.size.width, sendButton.frame.size.height);

	[UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	chatInputBox.frame = CGRectMake(chatInputBox.frame.origin.x, (chatInputBox.frame.origin.y + 170.0), chatInputBox.frame.size.width, chatInputBox.frame.size.height);
	sendButton.frame = CGRectMake(sendButton.frame.origin.x, (sendButton.frame.origin.y + 170.0), sendButton.frame.size.width, sendButton.frame.size.height);
	[UIView commitAnimations];
}

/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end

