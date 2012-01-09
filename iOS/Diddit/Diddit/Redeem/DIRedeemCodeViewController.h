//
//  DIRedeemCodeViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.09.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIBaseModalHeaderViewController.h"
#import "DIApp.h"

@interface DIRedeemCodeViewController : DIBaseModalHeaderViewController {
	DIApp *_app;
	
	NSString *_redeemCode;
}

-(id)initWithApp:(DIApp *)app;

@end
