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
#import "DILoadOverlay.h"

@interface DIAppListViewController : UIViewController <ASIHTTPRequestDelegate, UIScrollViewDelegate> {
	
	UIScrollView *_featuredScrollView;
	UIScrollView *_appsScrollView;
	DIPaginationView *_paginationView;
	
	ASIFormDataRequest *_featuredDataRequest;
	ASIFormDataRequest *_appsDataRequest;
	
	NSMutableArray *_features;
	NSMutableArray *_apps;
	NSMutableArray *_giftCards;
	
	
	DILoadOverlay *_loadOverlay;
}

@end
