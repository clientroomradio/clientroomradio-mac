//
//  CRRViewController.m
//  Client Room Radio iPad
//
//  Created by Michael Coffey on 01/12/2013.
//  Copyright (c) 2013 Michael Coffey. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

#import "CRRIViewController.h"

@implementation CRRIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.albumArt.image = [UIImage imageNamed: @"CRR"];
    
    [[CRRController sharedInstance] addDelegate:self];
    [[CRRController sharedInstance] openSocket];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[CRRController sharedInstance] removeDelegate:self];
    [[CRRController sharedInstance] logout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)progressChanged:(NSNumber*)progress {
    self.progress.progress = ([progress isMemberOfClass:[NSNull class]]) ? 0 : [progress floatValue];
}

-(void)skippersChanged:(NSArray*)skippers {
    [self.users refresh];
    [self updateSkipProgress];
}

-(void)updateSkipProgress {
    float skipLimit = ceil((float)[[[CRRController sharedInstance] getUsersModel] activeUserCount] / 2.0f);
    
    self.skipThreshold.text = [NSString stringWithFormat:@"%d", (int)skipLimit];
    
    self.skipProgress.progress = (float)[[[CRRController sharedInstance] getUsersModel] skippersCount] / skipLimit;
}

-(void)usersChanged:(NSDictionary*)users {
    [self.users refresh];
    [self updateSkipProgress];
    
    NSUInteger userCount = [[[CRRController sharedInstance] getUsersModel] count];
    
    self.userCount.text = userCount == 1 ? @"1 user": [NSString stringWithFormat:@"%lu users", (unsigned long)userCount];
}

-(void)skip:(NSString*)username avatar:(NSData*)avatar {
    
}

-(void)newChatMessage:(NSDictionary*)message {
    [self.chat refresh];
}

-(void)newTrack:(NSString*)title creator:(NSString*)creator duration:(NSNumber*)duration
       albumArt:(NSData*)albumArt {
    if (title == nil || creator == nil) {
        self.albumArt.image = [UIImage imageNamed: @"CRR"];
        self.trackTitle.text = @"Loading...";
    }
    else {
        duration = (duration == nil) ? 0 : duration;
        int minutes = ([duration intValue] / 1000) / 60;
        int seconds = ([duration intValue] / 1000) % 60;
        
        self.trackTitle.text = [NSString stringWithFormat:@"%@ - %@ (%02d:%02d)", creator, title, minutes, seconds];
        [self.trackTitle sizeToFit];
        
        UIImage* image = [[UIImage alloc] initWithData:albumArt];
        self.albumArt.image = image;
        
        // Set the now playing track (for the lock screen, etc)
        NSMutableDictionary* mediaInfo = [NSMutableDictionary dictionary];
        [mediaInfo setObject:title forKey:MPMediaItemPropertyTitle];
        [mediaInfo setObject:creator forKey:MPMediaItemPropertyArtist];
        
        if (image != nil)
            [mediaInfo setObject:[[MPMediaItemArtwork alloc] initWithImage:image] forKey:MPMediaItemPropertyArtwork];
        
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:mediaInfo];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ( ![self.scrollView focusNextTextField] ) {
        [textField resignFirstResponder];
    }
    
    [[CRRController sharedInstance] sendChat:textField.text];
    
    textField.text = @"";
    
    return YES;
}

- (IBAction)skipButtonPressed:(id)sender {
    [[CRRController sharedInstance] skip];
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
