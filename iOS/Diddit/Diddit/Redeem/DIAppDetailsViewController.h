//
//  DIAppDetailsViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIApp.h"
#import "DIChoreStatsView.h"
#import "DIPaginationView.h"
#import "DILoadOverlay.h"
#import "DIAppStatsView.h"

#import "ASIFormDataRequest.h"

@interface DIAppDetailsViewController : UIViewController <UIScrollViewDelegate, ASIHTTPRequestDelegate, UIAlertViewDelegate> {
	DIApp *_app;
	DIPaginationView *_paginationView;
	UIScrollView *_imgScrollView;
	DILoadOverlay *_loadOverlay;
	DIChoreStatsView *_choreStatsView;
	DIAppStatsView *_appStatsView;
	
	
	UIView *_footerView;
	UIButton *_footerBtn;
}

-(id)initWithApp:(DIApp *)app;

@end
