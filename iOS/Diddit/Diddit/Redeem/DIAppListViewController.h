//
//  DIAppListViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIFormDataRequest.h"

@interface DIAppListViewController : UIViewController <ASIHTTPRequestDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate> {
	UIScrollView *_featuredScrollView;
	UITableView *_appsTableView;
	
	ASIFormDataRequest *_featuredDataRequest;
	ASIFormDataRequest *_appsDataRequest;
	
	NSMutableArray *_features;
	NSMutableArray *_apps;
}

@end
