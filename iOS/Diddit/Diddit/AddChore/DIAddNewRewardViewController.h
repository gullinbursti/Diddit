//
//  DIAddNewRewardViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.31.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

#import "ASIFormDataRequest.h"

#import "DIChore.h"
#import "DILoadOverlay.h"

@interface DIAddNewRewardViewController : UIViewController <SKProductsRequestDelegate, ASIHTTPRequestDelegate> {
	DILoadOverlay *_loadOverlay;
	
	ASIFormDataRequest *_iapPakRequest;
	ASIFormDataRequest *_addChoreDataRequest;
	
	NSMutableArray *_iapPaks;
	
	DIChore *_chore;
}

@end
