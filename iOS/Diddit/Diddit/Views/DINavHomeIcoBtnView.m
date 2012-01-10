//
//  DINavHomeIcoBtnView.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.09.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIAppDelegate.h"
#import "DINavHomeIcoBtnView.h"

@implementation DINavHomeIcoBtnView

@synthesize btn = _btn;

-(id)init {
	CGSize size = CGSizeMake(54.0, 34.0);

	if ((self = [super initWithFrame:CGRectMake(0.0, 0.0, size.width, size.height)])) {
		_btn = [UIButton buttonWithType:UIButtonTypeCustom];
		_btn.frame = CGRectMake(-1.0, 3.0, size.width, size.height);
		[_btn setBackgroundImage:[[UIImage imageNamed:@"homeButton_nonActive.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
		[_btn setBackgroundImage:[[UIImage imageNamed:@"homeButton_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
		
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
