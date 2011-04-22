//
//  PostViewController.h
//  LocateMe
//
//  Created by Andres on 11/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "TopicViewController.h"
#import "ServerController.h"

@interface PostViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	Singleton *sharedVariables;
    
    IBOutlet UITableView* topicTable;
}

- (void)addButtonClicked;
- (void)refreshTableview;
- (void)refreshClicked;
- (NSString *)getTextForIndexPath:(NSIndexPath *)indexPath;

@end
