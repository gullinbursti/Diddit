//
//  DIPaginationView.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.10.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIPaginationView.h"

@implementation DIPaginationView

-(id)initWithTotal:(int)total coords:(CGPoint)pos {
	if ((self = [super initWithFrame:CGRectMake(pos.x - ((total * 7.0) * 0.5), pos.y, total * 7.0, 7.0)])) {
		_totPages = total;
		_curPage = 0.0;
		
		int xOffset = -3.5;
		
		for (int i=0; i<_totPages; i++) {
			UIImageView *ledImgView = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, -3.5, 7.0, 7.0)];
			[ledImgView setImage:[UIImage imageNamed:@"pagination_off.png"]];
			[self addSubview:ledImgView];
			xOffset += 14.0;
		}
		
		_onImgView = [[UIImageView alloc] initWithFrame:CGRectMake(-3.5, -3.5, 7.0, 7.0)];
		[_onImgView setImage:[UIImage imageNamed:@"pagination_on.png"]];
		[self addSubview:_onImgView];
	}
	
	return (self);
}

-(void)updToPage:(int)page {
	_curPage = page;
	_onImgView.frame = CGRectMake(-3.5 + (_curPage * 14.0), -3.5, 7.0, 7.0);
}

-(void)dealloc {
	[super dealloc];
}

@end
