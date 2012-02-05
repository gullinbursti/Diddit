//
//  DITableHeaderView.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.28.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DITableHeaderView.h"
#import "DIAppDelegate.h"

@implementation DITableHeaderView

-(id)initWithTitle:(NSString *)title {
	if ((self = [super init])) {
		UIView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableheaderBG.png"]] autorelease];
		[self addSubview:bgImgView];
		
		_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300.0, 16)];
		_label.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
		_label.backgroundColor = [UIColor clearColor];
		_label.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
		//_label.shadowColor = [UIColor whiteColor];
		//_label.shadowOffset = CGSizeMake(1.0, 1.0);
		_label.text = title;
		[self addSubview:_label];
	}
	
	return (self);
}

-(void)dealloc {
	[_label release];
	
	[super dealloc];
}

@end
