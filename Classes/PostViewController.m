    //
//  PostViewController.m
//  LocateMe
//
//  Created by Andres on 11/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import "PostViewController.h"

@class AddNewTopicViewController;

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@implementation PostViewController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	sharedVariables = [Singleton sharedInstance];
    
    // Add button
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action: @selector(addButtonClicked)];          
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
    
    // Refresh button
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshClicked)];
    self.navigationItem.leftBarButtonItem = refreshButton;

    [refreshButton release];
    
    // Have to reload the table (new data perhaps)
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(refreshTableview)
     name:@"forumArrayUpdate"          
     object:nil];
}

- (void)refreshTableview
{
    [topicTable reloadData];
}

- (void)refreshClicked
{
    ServerController *server = [sharedVariables serverController];
    [server sendRequest: [server requestWithString:[NSString stringWithFormat: @"getThreadsForRegionID=%@", [sharedVariables regionID]]]];
}

- (void)addButtonClicked
{
    AddNewTopicViewController *topicController = [[AddNewTopicViewController alloc] initWithNibName:@"AddNewTopicView" bundle:[NSBundle mainBundle]];
    
    [self.navigationController pushViewController:topicController animated:YES];
    
    [topicController release];   
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


/*
- (CGFloat)tableView:(UITableView *)tableView 
            heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize s;
    NSString *text = [[sharedVariables.forumArray objectAtIndex: indexPath.row] name];

    s = [self getSizeOfText:text withFont:[UIFont systemFontOfSize:14]];
    return s.height +11; //I put some padding on it.
}


- (CGSize)getSizeOfText:(NSString *)text withFont:(UIFont *)font
{
    
    return [text sizeWithFont: font constrainedToSize:CGSizeMake(280, 500)];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
		
    NSLog(@"daCount: %i", [sharedVariables.forumArray count]);
	return [sharedVariables.forumArray count];
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionHeader = nil;
	
	if(section == 0) {
		sectionHeader = @"Home Team";
	}
	if(section == 1) {
		sectionHeader = @"Away Team";
	}
	
	
	return sectionHeader;
}
*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    TopicViewController *topicController = [[TopicViewController alloc] initWithNibName:@"TopicView" bundle:[NSBundle mainBundle]];
    
    //TopicViewController* topicController = [[TopicViewController alloc] initWithNibName:@"TopicView" bundle:nil];
    //addNoteController.title = @"My Notes";
    [sharedVariables.serverController requestWithString:
     [NSString stringWithFormat: @"getThread=%i", [NSNumber numberWithInt:(int) indexPath.row]]];
    
    topicController.threadID = [NSNumber numberWithInt:(int) indexPath.row + 1];
    [self.navigationController pushViewController:topicController animated:YES];

    [topicController release];    

}
 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    // Calculate the cell height needed to fit the text
    
    NSString *text = [[sharedVariables.forumArray objectAtIndex: indexPath.row] name];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height + (CELL_CONTENT_MARGIN * 2);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Count the topics
    
	return [sharedVariables.forumArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Adjust the size of the cell to fit the text
    
    UITableViewCell *cell;
    UILabel *label = nil;
    
    cell = [tv dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Cell"] autorelease];
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setLineBreakMode:UILineBreakModeWordWrap];
        [label setMinimumFontSize:FONT_SIZE];
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [label setTag:1];
        
        //[[label layer] setBorderWidth:2.0f];
        
        [[cell contentView] addSubview:label];
        
    }
    NSString *text = [[sharedVariables.forumArray objectAtIndex: indexPath.row] name];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    if (!label)
        label = (UILabel*)[cell viewWithTag:1];
    
    [label setText:text];
    [label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
    
    return cell;
}
/*
    // Try to retrieve from the table view a now-unused cell with the given identifier.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    

    // If no cell is available, create a new one using the given identifier.
    if (cell == nil) {
        // Use the default cell style.
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
    }
    
    // Set up the cell.
    cell.textLabel.text = [[sharedVariables.forumArray objectAtIndex:[indexPath row]] name];
    
    return cell;
     
}
 */
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	PostViewController *secondController = [[PostViewController alloc]
												initWithNibName: @"TopicView" bundle: [NSBundle mainBundle]];

	if (secondController != nil) 
	{
		[self.navigationController pushViewController: secondController animated: YES];
		[secondController release];
	}
	*/



@end
