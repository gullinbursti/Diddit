//
//  DICreditsViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.13.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIFormDataRequest.h"

@class DILoadOverlayView;

@interface DICreditsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ASIHTTPRequestDelegate> {
	
	UITableView *_creditsTableView;
	NSArray *_sectionTitles;
	
	int _points;
	NSMutableArray *_chores;
	NSMutableArray *_apps;
	
	UILabel *_creditsLabel;
	
	DILoadOverlayView *_loadOverlayView;
}

-(id)initWithPoints:(int)points;

@end
