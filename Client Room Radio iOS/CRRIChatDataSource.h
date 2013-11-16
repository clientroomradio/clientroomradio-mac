//
//  CRRChatDelegate.h
//  Client Room Radio
//
//  Created by Michael Coffey on 27/11/2013.
//  Copyright (c) 2013 Michael Coffey. All rights reserved.
//

#include "CRRChatModel.h"

@interface CRRIChatDataSource : NSObject <UITableViewDataSource> {
}

@property (assign) IBOutlet UITableView* tableView;

-(void)refresh;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
