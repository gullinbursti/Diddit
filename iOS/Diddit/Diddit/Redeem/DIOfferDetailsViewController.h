//
//  DIOfferDetailsViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIOffer.h"

@interface DIOfferDetailsViewController : UIViewController {
	DIOffer *_offer;
}

-(id)initWithOffer:(DIOffer *)offer;

@end
