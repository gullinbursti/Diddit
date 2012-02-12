//
//  DIEmoticonView.m
//  Diddit
//
//  Created by Matthew Holcombe on 02.11.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIEmoticonView.h"

@implementation DIEmoticonView

-(id)init {
	if ((self = [super init])) {
		_type = 0;
		
		UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emotoBG_UP.png"]];
		[self addSubview:bgImgView];
		
		
		int row = 0;
		int col = 0;
		for (int i=0; i<7; i++) {
			row = i / 4;
			col = i % 4;
			
			UIImageView *faceImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emotiIconExample.png"]];
			CGRect frame = faceImgView.frame;
			frame.origin = CGPointMake(col * 20, 20 +(row * 20));
			faceImgView.frame = frame;
			
			[self addSubview:faceImgView];	
		}
	}
	
	return (self);
}

-(void)dealloc {
	[super dealloc];
}
@end
