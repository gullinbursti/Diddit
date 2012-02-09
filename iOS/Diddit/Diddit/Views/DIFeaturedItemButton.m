//
//  DIFeaturedItemView.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.11.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIAppDelegate.h"
#import "EGOImageView.h"

#import "DIFeaturedItemButton.h"

#import <QuartzCore/QuartzCore.h>

@implementation DIFeaturedItemButton

-(id)initWithApp:(DIApp *)app AtIndex:(int)ind {
	if ((self = [super initWithFrame:CGRectMake(0, 0, 270.0, 130.0)])) {
		_app = app;
		_ind = ind;
		
		[self addTarget:self action:@selector(_goTouchDn) forControlEvents:UIControlEventTouchDown];
		[self addTarget:self action:@selector(_goTouchUp) forControlEvents:UIControlEventTouchUpInside];
		
		/*UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(1.0, 1.0, 147.0, 92.0)];
		bgView.backgroundColor = [UIColor blackColor];
		bgView.layer.cornerRadius = 8.0;
		bgView.clipsToBounds = YES;
		bgView.layer.borderColor = [[UIColor colorWithWhite:0.67 alpha:1.0] CGColor];
		bgView.layer.borderWidth = 0.0;
		[self addSubview:bgView];
		*/
		_imgView = [[[EGOImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 270.0, 130.0)] autorelease];
		_imgView.imageURL = [NSURL URLWithString:app.img_url];
		[self addSubview:_imgView];
		
		[self setBackgroundImage:[_imgView.image stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
		[self setBackgroundImage:[_imgView.image stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateSelected];
	}
	
	return (self);
}

-(void)_goTouchDn {
	[UIView animateWithDuration:0.15 animations:^(void) {
		_imgView.alpha = 0.5;
	}];
}

-(void)_goTouchUp {
	[UIView animateWithDuration:0.15 animations:^(void) {
		_imgView.alpha = 1.0;
	}];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PUSH_FEATURED" object:[NSNumber numberWithInt:_ind]];
}

-(void)dealloc {
	[super dealloc];
}

@end
