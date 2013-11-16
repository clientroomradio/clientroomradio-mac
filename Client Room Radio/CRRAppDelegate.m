//
//  CRRAppDelegate.m
//  Client Room Radio
//
//  Created by Michael Coffey on 16/11/2013.
//  Copyright (c) 2013 Michael Coffey. All rights reserved.
//

#import "CRRAppDelegate.h"
#import "CRRController.h"

@implementation CRRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Register defaults for the whitelist of apps that want to use media keys
	[[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys: [SPMediaKeyTap defaultMediaKeyUserBundleIdentifiers], kMediaKeyUsingBundleIdentifiersDefaultsKey, nil]];
    
    mSPMediaKeyTap = [[SPMediaKeyTap alloc] initWithDelegate:self];
    if([SPMediaKeyTap usesGlobalMediaKeyTap])
		[mSPMediaKeyTap startWatchingMediaKeys];
	else
		NSLog(@"Media key monitoring disabled");
    
    [[CRRController sharedInstance] addDelegate:self];
    
    if ([[CRRController sharedInstance] login]) {
        [[CRRController sharedInstance] openSocket];
    }
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeAllDeliveredNotifications];
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didDeliverNotification:
    (NSUserNotification *)notification {
    //[center removeDeliveredNotification: notification];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    return YES; // always display notifications, even when app is focussed
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification {
    
    NSLog(@"didActivateNotification: %ld", [notification activationType]);
    
    if ([notification activationType] == NSUserNotificationActivationTypeActionButtonClicked ) {
        [[CRRController sharedInstance] skipWithMessage:@""];
    }
    
    [center removeDeliveredNotification: notification];
}

-(void)mediaKeyTap:(SPMediaKeyTap*)keyTap receivedMediaKeyEvent:(NSEvent*)event
{
	NSAssert([event type] == NSSystemDefined && [event subtype] == SPSystemDefinedEventMediaKeys, @"Unexpected NSEvent in mediaKeyTap:receivedMediaKeyEvent:");
	// here be dragons...
	int keyCode = (([event data1] & 0xFFFF0000) >> 16);
	int keyFlags = ([event data1] & 0x0000FFFF);
	BOOL keyIsPressed = (((keyFlags & 0xFF00) >> 8)) == 0xA;
	int keyRepeat = (keyFlags & 0x1);
	
	if (keyIsPressed) {
		NSString *debugString = [NSString stringWithFormat:@"%@", keyRepeat?@", repeated.":@"."];
		switch (keyCode) {
			case NX_KEYTYPE_PLAY:
				debugString = [@"Play/pause pressed" stringByAppendingString:debugString];
				break;
				
			case NX_KEYTYPE_FAST:
				debugString = [@"Ffwd pressed" stringByAppendingString:debugString];
                [[CRRController sharedInstance] skipWithMessage:@""];
				break;
				
			case NX_KEYTYPE_REWIND:
				debugString = [@"Rewind pressed" stringByAppendingString:debugString];
				break;
			default:
				debugString = [NSString stringWithFormat:@"Key %d pressed%@", keyCode, debugString];
				break;
                // More cases defined in hidsystem/ev_keymap.h
		}
		NSLog(@"Media key: %@", debugString);
	}
}

-(void)progressChanged:(NSNumber*)progress {
    [_progress setDoubleValue: ([progress isMemberOfClass:[NSNull class]]) ? 0 : [progress doubleValue]];
}

-(void)skippersChanged:(NSArray*)skippers {
    if ([skippers count] > 0) {
        NSString* skippersString = @"Skippers:";
    
        for (int i = 0 ; i < [skippers count] ; ++i) {
            skippersString = [skippersString stringByAppendingFormat:@" %@", [skippers objectAtIndex:i]];
        }
        [_skippers setStringValue:skippersString];
    } else {
        [_skippers setStringValue:@"No one has skipped yet..."];
    }
}

-(void)usersChanged:(NSDictionary*)users {
    [_users setUsers:users];
}

-(void)skip:(NSString*)username avatar:(NSData*)avatar {
    NSImage* image = [[NSImage alloc] initWithData:avatar];
    
    NSUserNotification* notification = [[NSUserNotification alloc] init];
    notification.title = [NSString stringWithFormat:@"%@ skipped", username];
    notification.informativeText = @"THIS IS HELL";
    notification.hasActionButton = NO;
    notification.identifier = username;
    notification.contentImage = image;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

-(void)newChatMessage:(NSDictionary*)message {
    [_chat addChat:message];
}

-(void)newTrack:(NSString*)title creator:(NSString*)creator duration:(NSNumber*)duration albumArt:(NSData*)albumArt {
    NSImage* image = [[NSImage alloc] initWithData:albumArt];
    
    duration = (duration == nil) ? 0 : duration;
    int minutes = ([duration intValue] / 1000) / 60;
    int seconds = ([duration intValue] / 1000) % 60;
    
    NSString* trackDetails = [NSString stringWithFormat:@"%@ - %@ (%02d:%02d)", creator, title, minutes, seconds];
    
    [_trackDetails setStringValue:trackDetails];
    
    [_albumArt setImage:image];
    
    NSUserNotification* notification = [[NSUserNotification alloc] init];
    notification.title = title;
    notification.informativeText = creator;
    notification.hasActionButton = YES;
    notification.actionButtonTitle = @"Skip";
    notification.identifier = @"newTrack";
    notification.contentImage = image;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    
    // remove all the skip notifications
    for (NSUserNotification* notification in [[NSUserNotificationCenter defaultUserNotificationCenter] deliveredNotifications]) {
        if (![notification.identifier isEqualToString:@"newTrack"]) {
            [[NSUserNotificationCenter defaultUserNotificationCenter] removeDeliveredNotification:notification];
        }
    }
}

- (IBAction)skip:(id)sender {
    [[CRRController sharedInstance] skip];
}

-(IBAction)sendChat:(id)sender {
    [[CRRController sharedInstance] sendChat:[_chatMessage stringValue]];
}

@end
