//
//  CRRChatModel.m
//  Client Room Radio
//
//  Created by Michael Coffey on 07/12/2013.
//  Copyright (c) 2013 Michael Coffey. All rights reserved.
//

#import "CRRChatModel.h"

@implementation CRRChatModel

-(instancetype)init {
    self = [super init];
	if (self != nil)
	{
		mData = [NSMutableArray arrayWithCapacity:50];
        
        mFormats = [[NSMutableDictionary alloc] init];
        [mFormats setObject:@"joined" forKey:@"join"];
        [mFormats setObject:@"timed out" forKey:@"timedOut"];
        [mFormats setObject:@"just loved this track" forKey:@"love"];
        [mFormats setObject:@"just unloved this track" forKey:@"unlove"];
        
        [mFormats setObject:@"%@" forKey:@"newTrack"];
        
        [mFormats setObject:@"skipped" forKey:@"skip_no_text"];
        [mFormats setObject:@"skipped \"%@\"" forKey:@"skip"];
        [mFormats setObject:@"already skipped" forKey:@"alreadySkipped_no_text"];
        [mFormats setObject:@"already skipped \"%@\"" forKey:@"alreadySkipped"];
        [mFormats setObject:@"tried to skip while away" forKey:@"inactiveUserWantsToSkip_no_text"];
        [mFormats setObject:@"tried to skip while away \"%@\"" forKey:@"inactiveUserWantsToSkip"];
        [mFormats setObject:@"away" forKey:@"becomesInactive_no_text"];
        [mFormats setObject:@"away \"%@\"" forKey:@"becomesInactive"];
        [mFormats setObject:@"back" forKey:@"becomesActive_no_text"];
        [mFormats setObject:@"back \"%@\"" forKey:@"becomesActive"];
	}
	return self;
}

-(void)addChat:(NSDictionary*)chat {
    [mData addObject:chat];
}

- (NSUInteger)count {
    return [mData count];
}

- (NSString*)timestampAtIndex:(NSUInteger)index {
    // add the timestamp
    NSNumber* timestamp = [[mData objectAtIndex:index] objectForKey:@"timestamp"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue] / 1000];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"[HH:mm:ss]"];
    return [dateFormatter stringFromDate:date];
}


- (NSString*)usernameAtIndex:(NSUInteger)index {
    NSDictionary* rowData = [mData objectAtIndex:index];
    NSString* system = [rowData objectForKey:@"system"];
    return [system isEqualToString:@"newTrack"] ? @"Client Room Radio" : [rowData valueForKey:@"user"];
}


- (NSString*)messageAtIndex:(NSUInteger)index {
    NSDictionary* rowData = [mData objectAtIndex:index];
    NSString* system = [rowData objectForKey:@"system"];
    
    if (system != nil) {
        if ([system isEqualToString:@"join"]
            || [system isEqualToString:@"timedOut"]
            || [system isEqualToString:@"love"]
            || [system isEqualToString:@"unlove"]) {
            return [mFormats objectForKey:system];
        }
        else if ([system isEqualToString:@"skip"]
                 || [system isEqualToString:@"alreadySkipped"]
                 || [system isEqualToString:@"inactiveUserWantsToSkip"]
                 || [system isEqualToString:@"becomesInactive"]
                 || [system isEqualToString:@"becomesActive"]
                 || [system isEqualToString:@"newTrack"]) {
            NSString* text = [rowData objectForKey:@"text"];
            
            if (![system isEqualToString:@"newTrack"] && (text == nil || [text isKindOfClass:[NSNull class]] || [text isEqualToString:@""])) {
                NSString* key = [system stringByAppendingString:@"_no_text"];
                return [mFormats objectForKey:key];
            }
            else {
                return [NSString stringWithFormat:[mFormats objectForKey:system], text];
            }
        }
        else if ([system isEqualToString:@"spotifyRequest"]) {
            // spotifyRequest', user, '', track);
            return @"spotify request";
        }
        else if ([system isEqualToString:@"startVoting"]) {
            // startVoting', user, '', { type: type, data: data, id: id });
            return @"voting started";
        }
    }
    else {
        // just a chat message
        return [rowData objectForKey:@"text"];
    }
    
    return @"";
}


@end
