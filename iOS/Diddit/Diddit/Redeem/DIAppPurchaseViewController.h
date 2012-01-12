//
//  DIAppPurchaseViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.17.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIFormDataRequest.h"
#import "EGOImageView.h"
#import "DIApp.h"

@class DILoadOverlayView;

@class MBProgressHUD;

@interface DIAppPurchaseViewController : UIViewController <ASIHTTPRequestDelegate> {
	MBProgressHUD *_hud;
	
	DIApp *_app;
	EGOImageView *_icoImgView;
	UILabel *_resultLabel;
	
	DILoadOverlayView *_loadOverlayView;
}


-(id)initWithApp:(DIApp *)app;
@end
