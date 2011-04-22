//
//  AddNewReplyViewController.m
//  LocateMe
//
//  Created by Andres on 23/03/2011.
//  Copyright 2011 Ventus. All rights reserved.
//

#import "AddNewReplyViewController.h"


@implementation AddNewReplyViewController
@synthesize message, threadID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(addNewReply)];          
    self.navigationItem.rightBarButtonItem = postButton;
    [postButton release];
    
    sharedVariables = [Singleton sharedInstance];
}

- (void)addNewReply
{
    NSError *writeError = nil;
    
    ServerController *server = [sharedVariables serverController];
    
    NSString *encodedMessage = [[message text] urlEncodeUsingEncoding:NSUTF8StringEncoding];
    
    // Add the new reply                            
    NSString *requestString = [NSString stringWithFormat: @"addReplyWithMessage=%@&threadID=%@", encodedMessage, [threadID intValue]+1];
    
    
    // Write out the details of the new topic being posted
    NSLog(@"Write error: %@, This is the requestString: %@", [writeError localizedDescription], requestString);
    [server sendRequest: [server requestWithString:requestString]];
    
    // Refresh
    //[server sendRequest: [server requestWithString: [NSString stringWithFormat:@"getThread=%i", [threadID intValue]+1]]];
    [server sendRequest: [server requestWithString: [NSString stringWithFormat:@"getThreadsForRegionID=%i", sharedVariables.regionID]]];

    NSArray* viewControllers = self.navigationController.viewControllers;
    //[[viewControllers objectAtIndex:[viewControllers count]-2] refresh];
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
