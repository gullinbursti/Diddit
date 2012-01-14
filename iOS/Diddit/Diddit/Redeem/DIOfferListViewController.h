//
//  DIOfferListViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIFormDataRequest.h"

@class DILoadOverlay;

@interface DIOfferListViewController : UIViewController <ASIHTTPRequestDelegate, UITableViewDataSource, UITableViewDelegate> {
	
	UITableView *_offersTableView;
	NSMutableArray *_offers;
	
	UILabel *_emptyLabel;
	
	ASIFormDataRequest *_offersDataRequest;
	
	DILoadOverlay *_loadOverlay;
}

@end
