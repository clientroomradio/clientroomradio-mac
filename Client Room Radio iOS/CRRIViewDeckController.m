//
//  CRRIViewDeckController.m
//  Client Room Radio
//
//  Created by Michael Coffey on 15/12/2013.
//  Copyright (c) 2013 Michael Coffey. All rights reserved.
//

#import "CRRIViewDeckController.h"
#import "CRRIViewController.h"

@implementation CRRIViewDeckController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mCenter = [self.storyboard instantiateViewControllerWithIdentifier:@"center"];
    mRight = [self.storyboard instantiateViewControllerWithIdentifier:@"right"];
    
    [self setCenterController:mCenter];
    [self setRightController:mRight];
    
    [self setDelegate:self];
    
    self.navigationItem.title = mCenter.title;
}

- (void)viewDeckController:(IIViewDeckController*)viewDeckController willOpenViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated;
{
    mRight.view.frame = (CGRect) { viewDeckController.rightLedgeSize,
        mRight.view.frame.origin.y,
        mCenter.view.frame.size.width - viewDeckController.rightLedgeSize,
        mRight.view.frame.size.height };
}

@end
