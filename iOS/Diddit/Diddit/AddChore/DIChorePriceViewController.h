//
//  DIChorePriceViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.14.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIBasePushHeaderViewController.h"
#import "ASIFormDataRequest.h"

@class DIChore, DILoadOverlay;


@interface DIChorePriceViewController : DIBasePushHeaderViewController <UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, ASIHTTPRequestDelegate> {
	DIChore *_chore;
	
	UITableView *_rewardTableView;
	NSMutableArray *_rewards;
	NSMutableArray *_cells;
	
	UIButton *_howBtn;
	
	int _points;
	float _cost;
	int _selIndex;
	
	DILoadOverlay *_loadOverlay;
}


-(id)initWithChore:(DIChore *)chore;

@end
