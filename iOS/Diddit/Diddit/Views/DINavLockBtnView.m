//
//  DINavLockBtnView.m
//  Diddit
//
//  Created by Matthew Holcombe on 02.01.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DINavLockBtnView.h"

@implementation DINavLockBtnView

@synthesize btn = _btn;

-(id)init {
		CGSize size = CGSizeMake(19.0, 19.0);
		
		if ((self = [super initWithFrame:CGRectMake(0.0, 0.0, size.width, size.height)])) {
			_btn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
			_btn.frame = CGRectMake(-1.0, 3.0, size.width, size.height);
			[_btn setBackgroundImage:[[UIImage imageNamed:@"padLockIcon_nonActive.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
			[_btn setBackgroundImage:[[UIImage imageNamed:@"padLockIcon_active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
			
			[self addSubview:_btn];
	}
	
	return (self);
}

-(void)dealloc {
	[super dealloc];
}

@end
