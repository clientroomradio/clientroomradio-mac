//
//  CRRIUsersDataSource.m
//  Client Room Radio
//
//  Created by Michael Coffey on 07/12/2013.
//  Copyright (c) 2013 Michael Coffey. All rights reserved.
//

#import "CRRIUsersDataSource.h"
#import "CRRController.h"

@implementation CRRIUsersDataSource

-(instancetype)init {
    self = [super init];
	if (self != nil)
	{
	}
	return self;
}

-(void)refresh {
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[CRRController sharedInstance] getUsersModel] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    CRRUsersModel* usersModel = [[CRRController sharedInstance] getUsersModel];

    NSString* username = [usersModel usernameAtIndex:indexPath.row];
    BOOL active = [usersModel activeAtIndex:indexPath.row];
    BOOL skipped = [usersModel skippedAtIndex:indexPath.row];
    
    cell.textLabel.text = username;
    
    NSInteger scrobbles = [usersModel scrobblesAtIndex:indexPath.row];
    BOOL loved = [usersModel lovedAtIndex:indexPath.row];
    
    if (scrobbles > 0 && active) {
        cell.textLabel.text = [cell.textLabel.text stringByAppendingFormat:loved ? @" (%ld ❤️)" : @" (%ld)", (long)scrobbles];
    }
    
    if (skipped) {
        cell.imageView.image = [UIImage imageNamed: @"Skipped"];
    }
    else {
        if ([usersModel scrobblingAtIndex:indexPath.row] && active)
            cell.imageView.image = [UIImage imageNamed: @"Scrobbling"];
        else {
            cell.imageView.image = [UIImage imageNamed: @"NotScrobbling"];
        }
    }
    
    cell.textLabel.textColor = active ? [UIColor blackColor] : [UIColor lightGrayColor];
    
    return cell;
}

@end
