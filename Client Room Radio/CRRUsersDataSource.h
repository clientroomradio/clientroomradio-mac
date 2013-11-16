//
//  CRRChatDelegate.h
//  Client Room Radio
//
//  Created by Michael Coffey on 27/11/2013.
//  Copyright (c) 2013 Michael Coffey. All rights reserved.
//

#include "CRRUsersModel.h"

@interface CRRUsersDataSource : NSObject <NSTableViewDataSource> {
}

@property (assign) IBOutlet NSTableView* tableView;

-(void)setUsers:(NSDictionary*)users;

-(int)numberOfRowsInTableView:(NSTableView *)aTableView;
-(id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex;

-(void)resizeColumnToContents:(NSTableColumn*)column;
@end
