//
//  DINavTitleView.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.09.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIAppDelegate.h"

#import "DINavTitleView.h"

@implementation DINavTitleView

-(id)initWithTitle:(NSString *)title {
	if ((self = [super init])) {
		UIFont *font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
		CGSize textSize = [title sizeWithFont:font constrainedToSize:CGSizeMake(230.0, CGFLOAT_MAX) lineBreakMode:UILineBreakModeClip];
		
		_label = [[[UILabel alloc] initWithFrame:CGRectMake(-textSize.width * 0.5, (-textSize.height * 0.5) + 4.0, textSize.width, textSize.height)] autorelease];
		[_label setFont:font];
		_label.backgroundColor = [UIColor clearColor];
		_label.textColor = [UIColor colorWithRed:0.184313725490196 green:0.537254901960784 blue:0.298039215686275 alpha:1.0];
		_label.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
		_label.shadowOffset = CGSizeMake(0.0, 1.0);
		[_label setText:title];
		
		[self addSubview:_label];
	}
	
	return (self);
}


-(void)dealloc {
	[super dealloc];
}

@end
