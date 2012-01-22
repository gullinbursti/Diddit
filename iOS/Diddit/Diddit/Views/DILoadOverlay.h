//
//  DILoadOverlay.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.11.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;

@interface DILoadOverlay : NSObject {
	UIImageView *_bgImgView;
	MBProgressHUD *_hud;
}

-(void)remove;

@end
