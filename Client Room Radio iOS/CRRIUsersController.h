//
//  CRRIUsersController.h
//  Client Room Radio
//
//  Created by Michael Coffey on 15/12/2013.
//  Copyright (c) 2013 Michael Coffey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRRIUsersDataSource.h"

@interface CRRIUsersController : UIViewController
    
@property (assign) IBOutlet UITableView* table;
@property (assign) IBOutlet CRRIUsersDataSource* users;

-(void)usersChanged:(NSDictionary*)users;

- (IBAction)activityChanged:(id)sender;
- (IBAction)scrobblingChanged:(id)sender;

@end
