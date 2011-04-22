//
//  TopicViewController.m
//  LocateMe
//
//  Created by Andres on 16/03/2011.
//  Copyright 2011 Ventus. All rights reserved.
//

#import "TopicViewController.h"

@class AddNewReplyViewController;


#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@implementation TopicViewController
@synthesize threadID;

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	sharedVariables = [Singleton sharedInstance];
    
    UIBarButtonItem *replyButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(buttonClicked)];         
    self.navigationItem.rightBarButtonItem = replyButton;
    [replyButton release];
    
    NSLog(@"baan");

}

- (void)refresh
{
    [tableView reloadData];
}

- (void)buttonClicked
{    
    AddNewReplyViewController *replyController = [[AddNewReplyViewController alloc] initWithNibName:@"AddNewReplyView" bundle:[NSBundle mainBundle]];
    
    [replyController setThreadID: threadID];

    [self.navigationController pushViewController:replyController animated:YES];
    
    [replyController release];    
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
    Thread *myThread = [sharedVariables.forumArray objectAtIndex: [threadID intValue]-1];
    NSString *text;
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) 
            text = [myThread messageBody];
    }
    else
    {
        NSArray *replies = [myThread replies];
        text = [[replies objectAtIndex:indexPath.row] messageBody];
    }
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    if (!label)
        label = (UILabel*)[cell viewWithTag:1];
    
    [label setText:text];
    [label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
    label.backgroundColor = [UIColor greenColor];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    // Calculate the cell height needed to fit the text
    Thread *myThread = [sharedVariables.forumArray objectAtIndex: [threadID intValue]-1];

    NSString *text;
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) 
            text = [myThread messageBody];
    }
    else
    {
        NSArray *replies = [myThread replies];
        text = [[replies objectAtIndex:indexPath.row] messageBody];
    }
        
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height + (CELL_CONTENT_MARGIN * 2);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView titleForHeaderInSection:section] != nil) {
        return CGRectGetHeight([self CGRectForText:[self tableView:tableView titleForHeaderInSection:section]]) + (CGFloat)(2*CELL_CONTENT_MARGIN);
    }
    else {
        // If no section header title, no section header needed
        return 0;
    }
}


- (UIView *)tableView:(UITableView *)tv viewForHeaderInSection:(NSInteger)section {
   /*
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    */
    // Adjust the size of the cell to fit the text
    
    UITableViewCell *cell;
    UILabel *label = nil;
    

        
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    [label setLineBreakMode:UILineBreakModeWordWrap];
    [label setMinimumFontSize:FONT_SIZE];
    [label setNumberOfLines:0];
    [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    [label setTag:1];

    // If array happens to be empty then break
    if ([sharedVariables.forumArray count] <= 0)
        return;
    
    Thread *myThread = [sharedVariables.forumArray objectAtIndex: [threadID intValue] - 1];
    NSString *text;
    if (section == 0) {
        text = [myThread name];
    }
    else
    {
        text = @"Replies:";
    }

    
    
    [label setText:text];
    CGRect myRect = [self CGRectForText:text];
    [label setFrame:myRect];   
    
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:[self CGRectForHeader:myRect]];
    
    if (section == 0) {
        label.backgroundColor = [UIColor redColor];
        view.backgroundColor = [UIColor redColor];
    }
    else
    {
        label.backgroundColor = [UIColor grayColor];
        view.backgroundColor = [UIColor grayColor];  
    }
    
    [view autorelease];
    [view addSubview:label];
    
    return view;
}

- (CGRect)CGRectForText:(NSString*)text;
{
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    return CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f));
}
                                
                                
- (CGRect)CGRectForHeader:(CGRect)cellRect;
{
    cellRect.size.width += (CELL_CONTENT_MARGIN * 2);
    cellRect.size.height += (CELL_CONTENT_MARGIN * 2);
    return cellRect;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Count the topics
    
    int i = 0;
    if (section == 0)
    {
        i = 1;
    }
    else
    {
        i = [[[sharedVariables.forumArray objectAtIndex:[threadID intValue]-1] replies] count];
    }
    return i;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    int i = 2;
	return i;
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionHeader = nil;
	
	if(section == 0) {
		sectionHeader = @"Post name goes here";
	}
	if(section == 1) {
		sectionHeader = @"Replies:";
	}
	
	
	return sectionHeader;
}

@end
