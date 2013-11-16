//
//  CRRController.h
//  Client Room Radio
//
//  Created by Michael Coffey on 01/12/2013.
//  Copyright (c) 2013 Michael Coffey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket/SRWebSocket.h>

#import "AudioStreamer.h"
#import "CRRChatModel.h"
#import "CRRUsersModel.h"

@protocol CRRControllerDelegate <NSObject>

- (void)progressChanged:(NSNumber*)progress;
- (void)skippersChanged:(NSArray*)skippers;
- (void)usersChanged:(NSDictionary*)users;
- (void)skip:(NSString*)username avatar:(NSData*)avatar;
- (void)newChatMessage:(NSDictionary*)message;
- (void)newTrack:(NSString*)title creator:(NSString*)creator duration:(NSNumber*)duration albumArt:(NSData*)albumArt;

@end

@interface CRRController : NSObject <SRWebSocketDelegate> {
    NSUserDefaults* mUserDefaults;
    AudioStreamer* mAudioStreamer;
    NSString* mToken;
    SRWebSocket* mCrrSocket;
    NSTimer* mHeartbeat;
    CRRChatModel* mChatModel;
    CRRUsersModel* mUsersModel;
    NSMutableArray* mDelegates;
}

+ (CRRController*)sharedInstance;

- (void)addDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;

#if TARGET_OS_IPHONE
- (BOOL)loginWithUsername:(NSString*)username password:(NSString*)password;
#else
- (BOOL)login;
- (void)authed;
#endif

- (void)logout;

- (void)openSocket;

- (void)setActive:(BOOL)active withMessage:(NSString*)message;
- (void)setScrobbling:(BOOL)scrobbling;
- (void)skip;
- (void)skipWithMessage:(NSString*)message;
- (void)sendChat:(NSString*)message;

- (void)startAudio;
- (void)stopAudio;

- (CRRChatModel*) getChatModel;
- (CRRUsersModel*) getUsersModel;

@end
