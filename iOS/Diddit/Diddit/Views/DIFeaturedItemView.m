//
//  DIFeaturedItemView.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.11.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIAppDelegate.h"

#import "DIFeaturedItemView.h"

@implementation DIFeaturedItemView

-(id)initWithImage:(UIImage *)img {
	if ((self = [super initWithFrame:CGRectMake(0, 0, 149.0, 94.0)])) {
		[self setBackgroundImage:[img stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
		[self setBackgroundImage:[img stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateSelected];
		[self addTarget:self action:@selector(_goTouchDn) forControlEvents:UIControlEventTouchDown];
		[self addTarget:self action:@selector(_goTouchUp) forControlEvents:UIControlEventTouchUpInside];
	}
	
	return (self);
}

-(void)_goTouchDn {
	[UIView animateWithDuration:0.15 animations:^(void) {
		self.alpha = 0.85;
	}];
}

-(void)_goTouchUp {
	[UIView animateWithDuration:0.15 animations:^(void) {
		self.alpha = 1.0;
	}];
}

-(void)dealloc {
	[super dealloc];
}

@end
