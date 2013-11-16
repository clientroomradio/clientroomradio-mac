//
//  CRRChatDelegate.h
//  Client Room Radio
//
//  Created by Michael Coffey on 27/11/2013.
//  Copyright (c) 2013 Michael Coffey. All rights reserved.
//

#import "CRRChatModel.h"

@interface CRRChatDataSource : NSObject <NSTableViewDataSource> {
}

@property (assign) IBOutlet NSTableView* tableView;
@property (assign) IBOutlet NSTableColumn* userColumn;
@property (assign) IBOutlet NSTableColumn* messageColumn;
@property (assign) IBOutlet NSTableColumn* timestampColumn;

-(void)addChat:(NSDictionary*)chat;

-(int)numberOfRowsInTableView:(NSTableView *)aTableView;
-(id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex;

-(void)resizeColumnToContents:(NSTableColumn*)column;
@end
