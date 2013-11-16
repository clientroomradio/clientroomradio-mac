//
//  CRRIUsersDataSource.h
//  Client Room Radio
//
//  Created by Michael Coffey on 07/12/2013.
//  Copyright (c) 2013 Michael Coffey. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CRRUsersModel.h"

@interface CRRIUsersDataSource : NSObject <UITableViewDataSource> {
}

@property (assign) IBOutlet UITableView* tableView;

-(void)refresh;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath;

@end
