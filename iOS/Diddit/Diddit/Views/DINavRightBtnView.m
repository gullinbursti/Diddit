//
//  DINavRightBtnView.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.09.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIAppDelegate.h"

#import "DINavRightBtnView.h"

@implementation DINavRightBtnView

@synthesize btn = _btn;

-(id)initWithLabel:(NSString *)lbl {
	CGSize size = CGSizeMake(59.0, 34.0);
	
	if ((self = [super initWithFrame:CGRectMake(0.0, 0.0, size.width, size.height)])) {
		_btn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		_btn.frame = CGRectMake(-1.0, 3.0, size.width, size.height);
		[_btn setBackgroundImage:[[UIImage imageNamed:@"headerButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
		[_btn setBackgroundImage:[[UIImage imageNamed:@"headerButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
		_btn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		_btn.titleEdgeInsets = UIEdgeInsetsMake(-1, 1, 1, -1);
		_btn.titleLabel.shadowColor = [UIColor blackColor];
		_btn.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		[_btn setTitle:lbl forState:UIControlStateNormal];
		
		[self addSubview:_btn];
	}
	
	return (self);
}

-(void)dealloc {
	[_btn release];
	
	[super dealloc];
}


//-(void)drawRect:(CGRect)rect {
//}

@end
