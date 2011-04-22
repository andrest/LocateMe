//
//  AddNewTopicViewController.m
//  LocateMe
//
//  Created by Andres on 23/03/2011.
//  Copyright 2011 Ventus. All rights reserved.
//

#import "AddNewTopicViewController.h"


@implementation AddNewTopicViewController
@synthesize message, headline;

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

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(addNewTopic)];          
    self.navigationItem.rightBarButtonItem = postButton;
    [postButton release];
    
    sharedVariables = [Singleton sharedInstance];
    
}

- (void)addNewTopic
{
    SBJsonWriter *writer = [SBJsonWriter new];
    NSError *writeError = nil;
    
    ServerController *server = [sharedVariables serverController];

    NSString *encodedHeadline = [[headline text] urlEncodeUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedMessage = [[message text] urlEncodeUsingEncoding:NSUTF8StringEncoding];

    // Add the new thread                            
    NSString *requestString = [NSString stringWithFormat: @"addTopicWithName=%@&message=%@&regionID=%@",encodedHeadline, encodedMessage, [sharedVariables regionID]];
    
    
    // Write out the details of the new topic being posted
    NSLog(@"Write error: %@, Headline value: %@, This is the requestString: %@", [writeError localizedDescription], [headline text], requestString);
    [server sendRequest: [server requestWithString:requestString]];
    
    // Refresh
    [server sendRequest: [server requestWithString: [NSString stringWithFormat:@"getThreadsForRegionID=%@", [sharedVariables regionID]]]];
    
    [self.navigationController popViewControllerAnimated:YES];
        
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
