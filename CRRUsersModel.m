//
//  CRRUserModel.m
//  Client Room Radio
//
//  Created by Michael Coffey on 07/12/2013.
//  Copyright (c) 2013 Michael Coffey. All rights reserved.
//

#import "CRRUsersModel.h"

@implementation CRRUsersModel

-(instancetype)init {
    self = [super init];
	if (self != nil) {
		mUsers = [NSDictionary dictionary];
        mTrack = [NSDictionary dictionary];
        mSkippers = [NSArray array];
	}
	return self;
}

-(void)setUsers:(NSDictionary*)users {
    mUsers = users;
}

-(void)setTrack:(NSDictionary*)track {
    mTrack = track;
}

-(void)setSkippers:(NSArray*)skippers {
    mSkippers = skippers;
}

-(NSUInteger)count {
    return [mUsers count];
}

-(NSInteger)activeUserCount {
    int activeUserCount = 0;
    
    for (id user in mUsers) {
        if ([[[mUsers objectForKey:user] objectForKey:@"active"] boolValue]) {
            ++activeUserCount;
        }
    }
    
    return activeUserCount;
}

-(NSInteger)skippersCount {
    return [mSkippers count];
}

-(NSString*)usernameAtIndex:(NSUInteger)index {
    NSDictionary* user = [[mUsers allValues] objectAtIndex:index];
    
    return [user objectForKey:@"username"];
}

-(BOOL)activeAtIndex:(NSUInteger)index {
    NSDictionary* user = [[mUsers allValues] objectAtIndex:index];
    
    return [[user objectForKey:@"active"] boolValue];
}

-(BOOL)scrobblingAtIndex:(NSUInteger)index {
    NSDictionary* user = [[mUsers allValues] objectAtIndex:index];
    
    return [[user objectForKey:@"scrobbling"] boolValue];
}

-(NSInteger)scrobblesAtIndex:(NSUInteger)index {
    NSDictionary* user = [[mUsers allValues] objectAtIndex:index];
    NSString* username = [user objectForKey:@"username"];
    
    NSDictionary* context = [mTrack objectForKey:@"context"];
    
    for (id contextItem in context) {
        if ([[contextItem objectForKey:@"username"] isEqualToString:username]) {
            return [[contextItem objectForKey:@"userplaycount"] integerValue];
        }
    }
    
    return 0;
}

-(BOOL)lovedAtIndex:(NSUInteger)index {
    NSDictionary* user = [[mUsers allValues] objectAtIndex:index];
    NSString* username = [user objectForKey:@"username"];
    
    NSDictionary* context = [mTrack objectForKey:@"context"];
    
    for (id contextItem in context) {
        if ([[contextItem objectForKey:@"username"] isEqualToString:username]) {
            return [[contextItem objectForKey:@"userloved"] boolValue];
        }
    }
    
    return NO;
}

-(BOOL)skippedAtIndex:(NSUInteger)index {
    NSDictionary* user = [[mUsers allValues] objectAtIndex:index];
    NSString* username = [user objectForKey:@"username"];
    
    return [mSkippers containsObject:username];
}

@end
