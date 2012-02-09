//
//  DIStoreItemButton.m
//  Diddit
//
//  Created by Matthew Holcombe on 02.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DIStoreItemButton.h"
#import "DIAppDelegate.h"


@implementation DIStoreItemButton

-(id)initWithApp:(DIApp *)app AtIndex:(int)ind {
	if ((self = [super initWithFrame:CGRectMake(0, 0, 57, 57)])) {
		_app = app;
		_ind = ind;
		
		[self addTarget:self action:@selector(_goTouchDn) forControlEvents:UIControlEventTouchDown];
		[self addTarget:self action:@selector(_goTouchUp) forControlEvents:UIControlEventTouchUpInside];
		
		_icoImgView = [[[EGOImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 57, 57.0)] autorelease];
		_icoImgView.layer.cornerRadius = 8.0;
		_icoImgView.clipsToBounds = YES;
		_icoImgView.layer.borderColor = [[UIColor colorWithWhite:0.67 alpha:1.0] CGColor];
		_icoImgView.layer.borderWidth = 0.0;
		_icoImgView.imageURL = [NSURL URLWithString:app.ico_url];
		[self addSubview:_icoImgView];
		
		//[self setBackgroundImage:[_icoImgView.image stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
		//[self setBackgroundImage:[_icoImgView.image stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateSelected];
		
		UILabel *pointsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 65, 57, 16)] autorelease];
		pointsLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
		pointsLabel.backgroundColor = [UIColor clearColor];
		pointsLabel.textColor = [UIColor colorWithWhite:0.398 alpha:1.0];
		pointsLabel.textAlignment = UITextAlignmentCenter;
		pointsLabel.shadowColor = [UIColor whiteColor];
		pointsLabel.shadowOffset = CGSizeMake(1.0, 1.0);
		pointsLabel.text = _app.disp_points;
		[self addSubview:pointsLabel];
	}
	
	return (self);
}

-(void)_goTouchDn {
	[UIView animateWithDuration:0.15 animations:^(void) {
		_icoImgView.alpha = 0.5;
	}];
}

-(void)_goTouchUp {
	[UIView animateWithDuration:0.15 animations:^(void) {
		_icoImgView.alpha = 1.0;
	}];
	
	if (_app.type_id == 1)
		[[NSNotificationCenter defaultCenter] postNotificationName:@"PUSH_STORE_APP" object:[NSNumber numberWithInt:_ind]];
	
	else
		[[NSNotificationCenter defaultCenter] postNotificationName:@"PUSH_STORE_CARD" object:[NSNumber numberWithInt:_ind]];
}

-(void)dealloc {
	[super dealloc];
}

@end
