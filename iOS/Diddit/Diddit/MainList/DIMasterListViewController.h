//
//  DIMasterListViewController.h
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "DIPaginationView.h"

@class DILoadOverlay;

@interface DIMasterListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ASIHTTPRequestDelegate, UIScrollViewDelegate> {
	
	ASIFormDataRequest *_activityRequest;
	ASIFormDataRequest *_choreUpdRequest;
	ASIFormDataRequest *_userUpdRequest;
	ASIFormDataRequest *_devicesRequest;
	
	UIButton *_devicesToggleButton;
	UIButton *_activityToggleButton;
	
	DILoadOverlay *_loadOverlay;
	
	UITableView *_activityTableView;
	
	NSMutableArray *_activity;
	NSMutableArray *_devices;
	NSMutableArray *_viewControllers;
	UIScrollView *_devicesScrollView;
	
	UIImageView *_footerImgView;	
	
	DIPaginationView *_paginationView;
}

@end
