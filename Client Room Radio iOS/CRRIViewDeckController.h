//
//  CRRIViewDeckController.h
//  Client Room Radio
//
//  Created by Michael Coffey on 15/12/2013.
//  Copyright (c) 2013 Michael Coffey. All rights reserved.
//

#import <ViewDeck/IIViewDeckController.h>

@interface CRRIViewDeckController : IIViewDeckController<IIViewDeckControllerDelegate> {
    UIViewController* mCenter;
    UIViewController* mRight;
}

@end
