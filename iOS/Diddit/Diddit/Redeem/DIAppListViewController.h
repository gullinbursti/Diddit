//
//  DIAppListViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIFormDataRequest.h"
#import "DIPaginationView.h"

#import "DILoadOverlayView.h"

@interface DIAppListViewController : UIViewController <ASIHTTPRequestDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate> {
	
	UIView *_featuredView;
	UIScrollView *_featuredScrollView;
	DIPaginationView *_paginationView;
	
	UITableView *_appsTableView;
	
	ASIFormDataRequest *_featuredDataRequest;
	ASIFormDataRequest *_appsDataRequest;
	
	NSMutableArray *_features;
	NSMutableArray *_apps;
	
	NSMutableArray *_cells;
	
	DILoadOverlayView *_loadOverlayView;
}

-(void)fillFeatured:(int)tot;

@end
