//
//  CRRViewController.h
//  Client Room Radio iPad
//
//  Created by Michael Coffey on 01/12/2013.
//  Copyright (c) 2013 Michael Coffey. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <TPKeyboardAvoiding/TPKeyboardAvoidingScrollView.h>
#import <IIViewDeckController.h>

#import "CRRController.h"
#import "CRRIChatDataSource.h"
#import "CRRIUsersDataSource.h"

@interface CRRIViewController : UIViewController <CRRControllerDelegate, UITextFieldDelegate> {
    Boolean mKeyboardIsShown;
}

@property (assign) IBOutlet UILabel* trackTitle;
@property (assign) IBOutlet UILabel* userCount;
@property (assign) IBOutlet UILabel* skipThreshold;
@property (assign) IBOutlet UIImageView* albumArt;
@property (assign) IBOutlet UIProgressView* progress;
@property (assign) IBOutlet UIProgressView* skipProgress;
@property (assign) IBOutlet UITextField* message;
@property (assign) IBOutlet TPKeyboardAvoidingScrollView* scrollView;

@property (assign) IBOutlet CRRIChatDataSource* chat;
@property (assign) IBOutlet CRRIUsersDataSource* users;

- (IBAction)skipButtonPressed:(id)sender;

- (IBAction)activityChanged:(id)sender;
- (IBAction)scrobblingChanged:(id)sender;

@end
