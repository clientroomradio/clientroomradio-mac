//
//  CRRApp.m
//  Client Room Radio
//
//  Created by Michael Coffey on 01/12/2013.
//  Copyright (c) 2013 Michael Coffey. All rights reserved.
//

#import "CRRApp.h"
#import "SPMediaKeyTap.h"

@implementation CRRApp

- (void)sendEvent:(NSEvent *)theEvent
{
	// If event tap is not installed, handle events that reach the app instead
	BOOL shouldHandleMediaKeyEventLocally = ![SPMediaKeyTap usesGlobalMediaKeyTap];
    
	if(shouldHandleMediaKeyEventLocally && [theEvent type] == NSSystemDefined && [theEvent subtype] == SPSystemDefinedEventMediaKeys) {
		[(id)[self delegate] mediaKeyTap:nil receivedMediaKeyEvent:theEvent];
	}
	[super sendEvent:theEvent];
}

@end
