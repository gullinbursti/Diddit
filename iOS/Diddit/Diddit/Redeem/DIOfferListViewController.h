//
//  DIOfferListViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIFormDataRequest.h"

@class DILoadOverlayView;

@interface DIOfferListViewController : UIViewController <ASIHTTPRequestDelegate, UITableViewDataSource, UITableViewDelegate> {
	
	UITableView *_offersTableView;
	UIButton *_pointsButton;
	NSMutableArray *_offers;
	
	UILabel *_emptyLabel;
	
	ASIFormDataRequest *_offersDataRequest;
	
	DILoadOverlayView *_loadOverlayView;
}

@end
