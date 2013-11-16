//
//  CRRLoginViewController.h
//  Client Room Radio
//
//  Created by Michael Coffey on 01/12/2013.
//  Copyright (c) 2013 Michael Coffey. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CRRController.h"

@interface CRRILoginViewController : UIViewController

@property (assign) IBOutlet UITextField* username;
@property (assign) IBOutlet UITextField* password;
@property (assign) IBOutlet UIButton* loginButton;

- (IBAction)login:(id)sender;

@end
