//
//  CRRAppDelegate.h
//  Client Room Radio
//
//  Created by Michael Coffey on 16/11/2013.
//  Copyright (c) 2013 Michael Coffey. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CRRController.h"
#import "CRRChatDataSource.h"
#import "CRRUsersDataSource.h"

#import "SPMediaKeyTap.h"

@interface CRRAppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate, CRRControllerDelegate> {
    SPMediaKeyTap* mSPMediaKeyTap;
}

@property (assign) IBOutlet CRRChatDataSource* chat;
@property (assign) IBOutlet CRRUsersDataSource* users;

@property (assign) IBOutlet NSWindow* window;
@property (assign) IBOutlet NSTextField* chatMessage;
@property (assign) IBOutlet NSImageView* albumArt;
@property (assign) IBOutlet NSProgressIndicator* progress;
@property (assign) IBOutlet NSTextField* trackDetails;
@property (assign) IBOutlet NSTextField* skippers;

- (IBAction)skip:(id)sender;
- (IBAction)sendChat:(id)sender;

@end
