//
//  CRRIUsersController.m
//  Client Room Radio
//
//  Created by Michael Coffey on 15/12/2013.
//  Copyright (c) 2013 Michael Coffey. All rights reserved.
//

#import "CRRIUsersController.h"
#import "CRRController.h"

@implementation CRRIUsersController

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [[CRRController sharedInstance] addDelegate:self];
    [self.users refresh];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[CRRController sharedInstance] removeDelegate:self];
}

-(void)usersChanged:(NSDictionary*)users {
    [self.users refresh];
}

- (void)newTrack:(NSString*)title creator:(NSString*)creator duration:(NSNumber*)duration albumArt:(NSData*)albumArt {
    [self.users refresh];
}

- (void)skippersChanged:(NSArray*)skippers {
    [self.users refresh];
}

- (IBAction)activityChanged:(id)sender {
    UISwitch* activity = (UISwitch*)sender;
    [[CRRController sharedInstance] setActive:activity.on withMessage:@""];
    
    if (activity.on) {
        [[CRRController sharedInstance] startAudio];
    }
    else {
        [[CRRController sharedInstance] stopAudio];
    }
}

- (IBAction)scrobblingChanged:(id)sender {
    UISwitch* scrobbling = (UISwitch*)sender;
    [[CRRController sharedInstance] setScrobbling:scrobbling.on];
}

@end
