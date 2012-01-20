//
//  DIChorePriceViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.14.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

#import "DIBasePushHeaderViewController.h"
#import "ASIFormDataRequest.h"
#import "DIChore.h"

@class DILoadOverlay;


@interface DIChorePriceViewController : DIBasePushHeaderViewController <UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate, ASIHTTPRequestDelegate> {
	DIChore *_chore;
	
	UITableView *_iapTableView;
	NSMutableArray *_iapPaks;
	NSMutableArray *_cells;
	
	UIButton *_howBtn;
	
	int _points;
	float _cost;
	int _selIndex;
	
	DILoadOverlay *_loadOverlay;
	
	ASIFormDataRequest *_iapPakRequest;
	ASIFormDataRequest *_addChoreDataRequest;
}


-(id)initWithChore:(DIChore *)chore;

@end
