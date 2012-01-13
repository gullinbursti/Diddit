//
//  DILoadOverlayView.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.11.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIAppDelegate.h"

#import <QuartzCore/QuartzCore.h>
#import "DILoadOverlay.h"
#import "MBProgressHUD.h"

@implementation DILoadOverlay

-(id)init {
	if ((self = [super init])) {
		
		
		_hud = [MBProgressHUD showHUDAddedTo:((DIAppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
		_hud.labelFont = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
		_hud.labelText = @"Loading…";
		_hud.dimBackground = YES;
		
		/*
		_holderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
		
		UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
		bgView.backgroundColor = [UIColor blackColor];
		bgView.alpha = 0.5f;
		[_holderView addSubview:bgView];
		
		UIView *overlayView = [[UIView alloc] initWithFrame:CGRectMake(98.0, 178.0, 124.0, 124.0)];
		overlayView.backgroundColor = [UIColor colorWithRed:0.003921568627451 green:0.301960784313725 blue:0.180392156862745 alpha:0.85];
		overlayView.layer.cornerRadius = 12.0;
		overlayView.clipsToBounds = YES;
		overlayView.layer.borderColor = [[UIColor colorWithWhite:0.15 alpha:0.85] CGColor];
		overlayView.layer.borderWidth = 4.0;
		[_holderView addSubview:overlayView];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(98.0, 210.0, 124.0, 124.0)];
		label.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:13.0];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor whiteColor];
		label.textAlignment = UITextAlignmentCenter;
		label.shadowColor = [UIColor blackColor];
		label.shadowOffset = CGSizeMake(0.0, -1.0);
		label.text = @"Loading…";
		[_holderView addSubview:label];
		 */
	}
	
	return (self);
}

-(void)remove {
	[_hud hide:YES];
	_hud = nil;
}

-(void)dealloc {
	[super dealloc];
}

@end
