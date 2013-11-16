//
//  CRRUserModel.h
//  Client Room Radio
//
//  Created by Michael Coffey on 07/12/2013.
//  Copyright (c) 2013 Michael Coffey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRRUsersModel : NSObject {
    NSDictionary* mUsers;
    NSDictionary* mTrack;
    NSArray* mSkippers;
}

-(void)setUsers:(NSDictionary*)users;
-(void)setTrack:(NSDictionary*)track;
-(void)setSkippers:(NSArray*)skippers;

-(NSInteger)activeUserCount;
-(NSInteger)skippersCount;

-(NSUInteger)count;
-(NSString*)usernameAtIndex:(NSUInteger)index;
-(BOOL)activeAtIndex:(NSUInteger)index;
-(BOOL)scrobblingAtIndex:(NSUInteger)index;
-(NSInteger)scrobblesAtIndex:(NSUInteger)index;
-(BOOL)lovedAtIndex:(NSUInteger)index;
-(BOOL)skippedAtIndex:(NSUInteger)index;

@end
