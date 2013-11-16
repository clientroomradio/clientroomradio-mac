//
//  CRRChatDelegate.m
//  Client Room Radio
//
//  Created by Michael Coffey on 27/11/2013.
//  Copyright (c) 2013 Michael Coffey. All rights reserved.
//

#import "CRRIChatDataSource.h"

#import "CRRController.h"

@implementation CRRIChatDataSource

-(instancetype)init {
    self = [super init];
	if (self != nil)
	{
	}
	return self;
}

-(void)refresh {
    [_tableView reloadData];

    int lastRowNumber = [[[CRRController sharedInstance] getChatModel] count] - 1;
    NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
    [_tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[CRRController sharedInstance] getChatModel] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
    
    CRRChatModel* chatModel = [[CRRController sharedInstance] getChatModel];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@: %@", [chatModel timestampAtIndex:indexPath.row], [chatModel usernameAtIndex:indexPath.row], [chatModel messageAtIndex:indexPath.row]];
    
    return cell;
}


@end
