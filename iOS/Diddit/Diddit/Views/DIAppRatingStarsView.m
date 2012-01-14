//
//  DIAppRatingStarsView.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.12.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIAppRatingStarsView.h"

@implementation DIAppRatingStarsView

-(id)init {
	if ((self = [super init])) {
		
		int offset = 0;
		for (int i=1; i<=5; i++) {
			UIImageView *emptyStarImgView = [[UIImageView alloc] initWithFrame:CGRectMake(offset, 0.0, 14.0, 14.0)];
			emptyStarImgView.image = [UIImage imageNamed:@"star_nonActive.png"];
			[self addSubview:emptyStarImgView];
			
			offset += 15;
		}
	}
		
	return (self);
}

-(id)initWithCoords:(CGPoint)pos appScore:(int)score {
	if ((self = [super initWithFrame:CGRectMake(pos.x, pos.y, 80.0, 14.0)])) {
		_score = score;
		
		int offset = 0;
		for (int i=1; i<=5; i++) {
			UIImageView *starImgView = [[UIImageView alloc] initWithFrame:CGRectMake(offset, 0.0, 14.0, 14.0)];
			
			if (i <= _score)
				starImgView.image = [UIImage imageNamed:@"star.png"];
			
			else
				starImgView.image = [UIImage imageNamed:@"star_nonActive.png"];
			
			[self addSubview:starImgView];
			//[starImgView release];
			
			offset += 15;
		}
	}
	
	return (self);
}

-(id)initWithScore:(int)score {
	if ((self = [self init])) {
		_score = score;
		
		int offset = 0;
		for (int i=1; i<=5; i++) {
			UIImageView *starImgView = [[UIImageView alloc] initWithFrame:CGRectMake(offset, 0.0, 14.0, 14.0)];
			
			if (i <= _score)
				starImgView.image = [UIImage imageNamed:@"star.png"];
			
			else
				starImgView.image = [UIImage imageNamed:@"star_nonActive.png"];
			
			[self addSubview:starImgView];
			//[starImgView release];
			
			offset += 15;
		}
	}
	
	return (self);
}


-(void) dealloc {
	[super dealloc];
}

@end
