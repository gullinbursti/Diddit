//
//  DINavBackBtnView.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.09.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIAppDelegate.h"

#import "DINavBackBtnView.h"

@implementation DINavBackBtnView

@synthesize btn = _btn;

-(id)init {
	CGSize size = CGSizeMake(59.0, 34.0);
	
	if ((self = [super initWithFrame:CGRectMake(0.0, 0.0, size.width, size.height)])) {
		_btn = [UIButton buttonWithType:UIButtonTypeCustom];
		_btn.frame = CGRectMake(-1.0, 3.0, size.width, size.height);
		[_btn setBackgroundImage:[[UIImage imageNamed:@"headerBackButton_nonActive.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
		[_btn setBackgroundImage:[[UIImage imageNamed:@"headerBackButton_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
		_btn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		_btn.titleLabel.shadowColor = [UIColor blackColor];
		_btn.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		_btn.titleEdgeInsets = UIEdgeInsetsMake(-1, 4, 1, -4);
		[_btn setTitle:@"Back" forState:UIControlStateNormal];

		[self addSubview:_btn];
	}
	
	return (self);
}

-(void)dealloc {
	[super dealloc];
}


//-(void)drawRect:(CGRect)rect {
//}

@end
