//
//  DIFooterBtnView.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.10.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIAppDelegate.h"

#import "DIFooterBtnView.h"

@implementation DIFooterBtnView

@synthesize btn = _btn;

-(id)initWithLabel:(NSString *)lbl {
	if ((self = [super init])) {
		UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 348, 320, 72)];
		footerView.backgroundColor = [UIColor colorWithRed:0.2706 green:0.7804 blue:0.4549 alpha:1.0];
		[self addSubview:footerView];
		
		_btn = [UIButton buttonWithType:UIButtonTypeCustom];
		_btn.frame = CGRectMake(0, 352, 320, 59);
		[_btn setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_nonActive.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
		[_btn setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
		_btn.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
		_btn.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
		[_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[_btn setTitle:lbl forState:UIControlStateNormal];
		
		[self addSubview:_btn];
	}
	
	return (self);
}

-(void)dealloc {
	[super dealloc];
}

@end
