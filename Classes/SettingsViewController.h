//
//  SettingsViewController.h
//  LocateMe
//
//  Created by Andres on 13/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SettingsViewController : UIViewController {
    IBOutlet UISwitch *commonRegion;
    IBOutlet UITextField *displayName;
}

-(IBAction)reconnectChat;
@end
