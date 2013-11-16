//
//  CRRChatModel.h
//  Client Room Radio
//
//  Created by Michael Coffey on 07/12/2013.
//  Copyright (c) 2013 Michael Coffey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRRChatModel : NSObject {
    NSMutableArray* mData;
    NSMutableDictionary* mFormats;
}

-(void)addChat:(NSDictionary*)chat;

-(NSUInteger)count;
-(NSString*)timestampAtIndex:(NSUInteger)index;
-(NSString*)usernameAtIndex:(NSUInteger)index;
-(NSString*)messageAtIndex:(NSUInteger)index;

@end
