//
//  CRRLoginViewController.m
//  Client Room Radio
//
//  Created by Michael Coffey on 01/12/2013.
//  Copyright (c) 2013 Michael Coffey. All rights reserved.
//

#import "CRRILoginViewController.h"

@implementation CRRILoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSUserDefaults* userDefaults = [[NSUserDefaults alloc] init];
    
    self.username.text = [userDefaults stringForKey:@"username"];
    self.password.text = [userDefaults stringForKey:@"password"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    if ([[CRRController sharedInstance] loginWithUsername:self.username.text password:self.password.text]) {
        NSUserDefaults* userDefaults = [[NSUserDefaults alloc] init];
        [userDefaults setObject:self.username.text forKey:@"username"];
        [userDefaults setObject:self.password.text forKey:@"password"];
        [self performSegueWithIdentifier:@"Login" sender:self];
    }
}

@end
