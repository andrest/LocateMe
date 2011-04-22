//
//  TopicViewController.h
//  LocateMe
//
//  Created by Andres on 16/03/2011.
//  Copyright 2011 Ventus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "Thread.h"

@interface TopicViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>  {
    Singleton *sharedVariables;
    NSNumber *threadID;
    
    UITableView IBOutlet *tableView;
}

- (CGRect)CGRectForText:(NSString*)text;
- (CGRect)CGRectForHeader:(CGRect)cellRect;
- (void)buttonClicked;
- (void)refresh;


@property (nonatomic, retain) NSNumber* threadID;

@end
