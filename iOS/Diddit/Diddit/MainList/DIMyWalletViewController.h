//
//  DIMyWalletViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 02.04.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DILoadOverlay.h"
#import "ASIFormDataRequest.h"

@interface DIMyWalletViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate> {
	UITableView *_historyTableView;
	NSMutableArray *_history;
	
	DILoadOverlay *_loadOverlay;
	ASIFormDataRequest *_historyDataRequest;
	ASIFormDataRequest *_offersDataRequest;
	ASIFormDataRequest *_storeDataRequest;
}

@end
