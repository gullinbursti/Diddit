//
//  DIAppDetailsViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIApp.h"
#import "DIPaginationView.h"
#import "DILoadOverlay.h"

#import "ASIFormDataRequest.h"

@interface DIAppDetailsViewController : UIViewController <UIScrollViewDelegate, ASIHTTPRequestDelegate, UIAlertViewDelegate> {
	DIApp *_app;
	DIPaginationView *_paginationView;
	UIScrollView *_imgScrollView;
	DILoadOverlay *_loadOverlay;
	
	UIButton *_footerBtn;
	BOOL _isStoreAlert;
}

-(id)initWithApp:(DIApp *)app;

@end
