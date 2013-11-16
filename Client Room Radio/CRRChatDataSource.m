//
//  CRRChatDelegate.m
//  Client Room Radio
//
//  Created by Michael Coffey on 27/11/2013.
//  Copyright (c) 2013 Michael Coffey. All rights reserved.
//

#import "CRRChatDataSource.h"
#import "CRRController.h"

@implementation CRRChatDataSource

-(instancetype)init {
    self = [super init];
	if (self != nil) {
	}
	return self;
}

-(void)addChat:(NSDictionary*)chat {
    NSRect bounds = [[_tableView superview] bounds];
    bounds.origin.y += bounds.size.height - 1;
    NSInteger lastVisibleRow = [_tableView rowAtPoint:bounds.origin];
    BOOL scrollToEnd = lastVisibleRow == [[[CRRController sharedInstance] getChatModel] count] - 1;
    
    [[[CRRController sharedInstance] getChatModel] addChat:chat];
    [self.tableView reloadData];
    
    NSInteger numberOfRows = [_tableView numberOfRows];
    
    if (scrollToEnd && numberOfRows > 0)
        [self.tableView scrollRowToVisible:numberOfRows - 1];
    
    [self resizeColumnToContents:_timestampColumn];
    [self resizeColumnToContents:_userColumn];
}

-(void)resizeColumnToContents:(NSTableColumn*)column {
    int biggestWidth = 0;

    for (int i = 0 ; i < [_tableView numberOfRows] ; ++i ) {
        NSCell* myCell = [column dataCellForRow:i];
        if ([myCell cellSize].width > biggestWidth) {
            biggestWidth = [myCell cellSize].width;
        }
    }
    
    [column setMinWidth:biggestWidth];
    [column setWidth:biggestWidth];
}



-(int)numberOfRowsInTableView:(NSTableView *)aTableView {
    return [[[CRRController sharedInstance] getChatModel] count];
}

-(id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex {
    
    if (aTableColumn == _userColumn) {
        return [[[CRRController sharedInstance] getChatModel] usernameAtIndex:rowIndex];
    }
    else if (aTableColumn == _timestampColumn) {
        return [[[CRRController sharedInstance] getChatModel] timestampAtIndex:rowIndex];
    }
    else if (aTableColumn == _messageColumn) {
        return [[[CRRController sharedInstance] getChatModel] messageAtIndex:rowIndex];
    }
    
    return nil;
}


@end
