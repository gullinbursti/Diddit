//
//  DIOfferDetailsViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIOffer.h"
#import "DIPaginationView.h"

@interface DIOfferDetailsViewController : UIViewController <UIScrollViewDelegate> {
	DIOffer *_offer;
	
	DIPaginationView *_paginationView;
	UIScrollView *_imgScrollView;
}

-(id)initWithOffer:(DIOffer *)offer;

@end
