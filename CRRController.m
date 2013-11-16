//
//  CRRController.m
//  Client Room Radio
//
//  Created by Michael Coffey on 01/12/2013.
//  Copyright (c) 2013 Michael Coffey. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "CRRController.h"
#import "Keys.h"

@interface CRRController()

- (CRRController*)init;

@end

@implementation CRRController

static CRRController* sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (CRRController *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super alloc] init];
    }
    
    return sharedInstance;
}

-(CRRController*)init {
    self = [super init];
	if (self != nil) {
        mUserDefaults = [[NSUserDefaults alloc] init];
        
        mChatModel = [[CRRChatModel alloc] init];
        mUsersModel = [[CRRUsersModel alloc] init];
        
        mDelegates = [NSMutableArray array];
    }
    
    return self;
}

- (void)addDelegate:(id)delegate {
    [mDelegates addObject:delegate];
}

- (void)removeDelegate:(id)delegate {
    [mDelegates removeObject:delegate];
}

#if TARGET_OS_IPHONE
-(BOOL)loginWithUsername:(NSString*)username password:(NSString*)password {
    BOOL loggedIn = NO;
    
    // for iOS we do mobile auth
    NSString* apiSig = [self md5:[NSString stringWithFormat:@"api_key%@methodauth.getmobilesessionpassword%@username%@%@", LASTFM_API_KEY, password, username, LASTFM_API_SECRET]];
    
    NSURL* authGetMobileSessionURL = [NSURL URLWithString:@"https://ws.audioscrobbler.com/2.0/"];
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters setObject:username forKey:@"username"];
    [parameters setObject:password forKey:@"password"];
    [parameters setObject:LASTFM_API_KEY forKey:@"api_key"];
    [parameters setObject:apiSig forKey:@"api_sig"];
    [parameters setObject:@"auth.getmobilesession" forKey:@"method"];
    [parameters setObject:@"json" forKey:@"format"];
    
    NSMutableArray * encodedParameters = [NSMutableArray array];
    for (NSString * key in parameters) {
        NSString * value = [parameters objectForKey:key];
        NSString * encoded = [NSString stringWithFormat:@"%@=%@", [key stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], [value stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        [encodedParameters addObject:encoded];
    }
    
    NSString* post = [encodedParameters componentsJoinedByString:@"&"];
    NSData* postData = [post dataUsingEncoding:NSASCIIStringEncoding];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:authGetMobileSessionURL];
    [request setHTTPMethod:@"POST"];
    request.HTTPBody = postData;
    
    NSError* error = nil;
    NSURLResponse* response;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString* myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"auth.getMobileSesssion: %@", myString);
    
    NSDictionary* payload = [NSJSONSerialization
                             JSONObjectWithData:data
                             options:0
                             error:&error];
    
    if ([payload objectForKey:@"error"] == nil) {
        [mUserDefaults setObject:data forKey:@"session"];
        loggedIn = YES;
    }
    
    return loggedIn;
}

#else
-(BOOL)login {
    BOOL loggedIn = YES;
    
    NSData* session = [mUserDefaults dataForKey:@"session"];
    
    if (session == nil) {
        NSURL* authGetTokenURL = [NSURL URLWithString:[NSString stringWithFormat: @"http://ws.audioscrobbler.com/2.0/?method=auth.gettoken&format=json&api_key=%@", LASTFM_API_KEY]];
        
        NSError* error = nil;
        NSDictionary* payload = [NSJSONSerialization
                                 JSONObjectWithData:[NSData dataWithContentsOfURL:(NSURL*)authGetTokenURL]
                                 options:0
                                 error:&error];
        
        mToken = [[payload objectForKey:@"lfm"] objectForKey:@"token"];
        
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.last.fm/api/auth/?api_key=%@&token=%@", LASTFM_API_KEY, mToken]]];
        
        loggedIn = NO;
    }
    
    return loggedIn;
}

- (void)authed {
    
    NSString* apiSig = [self md5:[NSString stringWithFormat: @"api_key%@methodauth.getsessiontoken%@%@", LASTFM_API_KEY, mToken, LASTFM_API_SECRET]];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://ws.audioscrobbler.com/2.0/?method=auth.getsession&api_key=%@&format=json&token=%@&api_sig=%@", LASTFM_API_KEY, mToken, apiSig]]];
    
    NSError* error = nil;
    NSURLResponse* response;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString* myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"auth.getSesssion: %@", myString);
    
    [mUserDefaults setObject:data forKey:@"session"];
}
#endif

- (void)openSocket {
    NSMutableURLRequest* crrSocketRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"wss://clientroomradio.com/echo/websocket/"]];
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"cert" ofType:@"der"];
    NSData* myCertData = [NSData dataWithContentsOfFile:filePath];
    
    SecCertificateRef cert = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)myCertData);
    
    crrSocketRequest.SR_SSLPinnedCertificates = [NSArray arrayWithObject:(__bridge id)cert];
    
    mCrrSocket = [[SRWebSocket alloc] initWithURLRequest:crrSocketRequest];
    [mCrrSocket setDelegate:self];
    [mCrrSocket open];
}

- (NSString*)md5:(NSString*)str {
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString
            stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1],
            result[2], result[3],
            result[4], result[5],
            result[6], result[7],
            result[8], result[9],
            result[10], result[11],
            result[12], result[13],
            result[14], result[15]
            ];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSError *error = nil;
    NSDictionary* payload = [NSJSONSerialization
                             JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding]
                             options:0
                             error:&error];
    
    NSString* type = [payload objectForKey:@"type"];
    
    if ([type isEqualToString:@"progress"]) {
        for (id delegate in mDelegates) {
            if ([delegate respondsToSelector:@selector(progressChanged:)]) {
                [delegate progressChanged:[payload objectForKey:@"data"]];
            }
        }
    }
    else if ([type isEqualToString:@"skippers"]) {
        NSArray* skippers = [payload objectForKey:@"data"];
        
        [mUsersModel setSkippers:skippers];
        
        for (id delegate in mDelegates) {
            if ([delegate respondsToSelector:@selector(skippersChanged:)]) {
                [delegate skippersChanged:skippers];
            }
        }
    }
    else if ([type isEqualToString:@"users"]) {
        NSDictionary* users = [payload objectForKey:@"data"];
        [mUsersModel setUsers:users];
        for (id delegate in mDelegates) {
            if ([delegate respondsToSelector:@selector(usersChanged:)]) {
                [delegate usersChanged:users];
            }
        }
    }
    else if ([type isEqualToString:@"newTrack"])
    {
        id data = [payload objectForKey:@"data"];
        if (data) {
            [mUsersModel setTrack:data];
            NSString* imageUrl = [data objectForKey:@"image"];
            NSData* imageData = NULL;
            if (imageUrl) {
                imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            }
            for (id delegate in mDelegates) {
                if ([delegate respondsToSelector:@selector(newTrack:creator:duration:albumArt:)]) {
                    [delegate newTrack:[data objectForKey:@"title"] creator:[data objectForKey:@"creator"] duration:[data objectForKey:@"duration"] albumArt:imageData];
                }
            }
        }
    }
    else if ([type isEqualToString:@"skip"])
    {
        NSDictionary* skipper = [[payload objectForKey:@"data"] objectForKey:@"skipper"];
        NSString* username = [skipper objectForKey:@"username"];
        NSString* imageUrl = [skipper objectForKey:@"image"];
        NSData* imageData = NULL;
        if (imageUrl) {
            imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        }
        
        for (id delegate in mDelegates) {
            if ([delegate respondsToSelector:@selector(skip:avatar:)]) {
                [delegate skip:username avatar:imageData];
            }
        }
    }
    else if ([type isEqualToString:@"chat"]) {
        NSDictionary* chat = [payload objectForKey:@"data"];
        [mChatModel addChat:chat];
        
        for (id delegate in mDelegates) {
            if ([delegate respondsToSelector:@selector(newChatMessage:)]) {
                [delegate newChatMessage:chat];
            }
        }
    }
    else {
        NSLog(@"Unknown message type: %@", type);
        for (id key in payload) {
            NSLog(@"key: %@, value: %@ \n", key, [payload objectForKey:key]);
        }
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"webSocketDidOpen");
    
    [webSocket send:[mUserDefaults dataForKey:@"session"]];
    
    mAudioStreamer = [[AudioStreamer alloc] initWithURL:[NSURL URLWithString:@"http://www.clientroomradio.com:8080/stream.mp3"]];
    [mAudioStreamer start];
    
    // start the heartbeat timer
    mHeartbeat = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(heartbeat:) userInfo:self repeats:YES];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", [error localizedDescription]);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"didCloseWithCode %ld %@", (long)code, reason);
}

- (void)logout {
    [mUserDefaults removeObjectForKey:@"session"];
    [mCrrSocket close];
    mCrrSocket = nil;
    
    [mHeartbeat invalidate];
    mHeartbeat = nil;
    
    [mAudioStreamer stop];
    mAudioStreamer = nil;
    
    mChatModel = [[CRRChatModel alloc] init];
    mUsersModel = [[CRRUsersModel alloc] init];
}

- (void)setActive:(BOOL)active withMessage:(NSString*)message {
    [mCrrSocket send:[NSString stringWithFormat:@"{\"type\": \"activeStatus\", \"data\": { \"status\": %@, \"message\": \"%@\" } }", active ? @"true" : @"false", message]];
}

- (void)setScrobbling:(BOOL)scrobbling {
    [mCrrSocket send:[NSString stringWithFormat:@"{\"type\": \"scrobbleStatus\", \"data\": %@ }", scrobbling ? @"true" : @"false"]];
}

- (void)skip {
    [self skipWithMessage:@""];
}

- (void)skipWithMessage:(NSString*)message {
    [mCrrSocket send:[NSString stringWithFormat:@"{\"type\": \"skip\", \"data\": { \"text\": \"%@\" } }", message]];
}

- (void)sendChat:(NSString*)message; {
    [mCrrSocket send:[NSString stringWithFormat:@"{\"type\": \"chatMessage\", \"data\": { \"text\": \"%@\" } }", message]];
}

- (void)heartbeat:(NSTimer*)theTimer {
    [mCrrSocket send:@"{\"type\": \"heartbeat\", \"data\": \"\" }"];
}

- (void)startAudio {
    [mAudioStreamer start];
}

- (void)stopAudio {
    [mAudioStreamer stop];
}

- (CRRChatModel*) getChatModel {
    return mChatModel;
}

- (CRRUsersModel*) getUsersModel {
    return mUsersModel;
}

@end
