//
//  CRRChatDelegate.m
//  Client Room Radio
//
//  Created by Michael Coffey on 27/11/2013.
//  Copyright (c) 2013 Michael Coffey. All rights reserved.
//

#import "CRRUsersDataSource.h"
#import "CRRController.h"

@implementation CRRUsersDataSource

-(instancetype)init {
    self = [super init];
	if (self != nil) {
	}
	return self;
}

-(void)setUsers:(NSDictionary*)users {
    [[[CRRController sharedInstance] getUsersModel] setUsers:users];
    [self.tableView reloadData];
}

-(int)numberOfRowsInTableView:(NSTableView *)aTableView {
    return [[[CRRController sharedInstance] getUsersModel] count];
}

-(id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex {
    return [[[CRRController sharedInstance] getUsersModel] usernameAtIndex: rowIndex];
}


@end
