//
//  DIAppStatsView.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.12.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DIApp.h"
#import "EGOImageView.h"
#import "DIAppRatingStarsView.h"
#import "DIAppStatsView.h"
#import "DIAppDelegate.h"

@implementation DIAppStatsView

-(id)initWithCoords:(CGPoint)pos appVO:(DIApp *)app {
	if ((self = [super initWithFrame:CGRectMake(pos.x, pos.y, 300.0, 60.0)])) {
		_app = app;
		
		EGOImageView *icoImgView = [[[EGOImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 60, 60)] autorelease];
		icoImgView.imageURL = [NSURL URLWithString:_app.ico_url];
		icoImgView.layer.cornerRadius = 8.0;
		icoImgView.clipsToBounds = YES;
		icoImgView.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0] CGColor];
		icoImgView.layer.borderWidth = 1.0;
		[self addSubview:icoImgView];
		
		UILabel *appTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(66.0, 5.0, 180.0, 22)] autorelease];
		appTitleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
		appTitleLabel.backgroundColor = [UIColor clearColor];
		appTitleLabel.textColor = [UIColor colorWithRed:0.208 green:0.682 blue:0.369 alpha:1.0];
		appTitleLabel.text = _app.title;
		[self addSubview:appTitleLabel];
		
		UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(66.0, 23.0, 300.0, 16)] autorelease];
		infoLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:14];
		infoLabel.textColor = [UIColor blackColor];
		infoLabel.backgroundColor = [UIColor clearColor];
		infoLabel.text = _app.info;
		[self addSubview:infoLabel];
		
		DIAppRatingStarsView *appRatingStarsView = [[[DIAppRatingStarsView alloc] initWithCoords:CGPointMake(66.0, 38.0) appScore:_app.score] autorelease];
		[self addSubview:appRatingStarsView];
		
		UIView *ptsView = [[[UIView alloc] initWithFrame:CGRectMake(247.0, 14.0, 52, 25)] autorelease];
		ptsView.backgroundColor = [UIColor colorWithRed:0.976 green:0.976 blue:0.929 alpha:1.0];
		ptsView.layer.cornerRadius = 6.0;
		ptsView.clipsToBounds = YES;
		ptsView.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0] CGColor];
		ptsView.layer.borderWidth = 2.0;
		[self addSubview:ptsView];
		
		UILabel *pointsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 3, 52, 20)] autorelease];
		pointsLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
		pointsLabel.backgroundColor = [UIColor clearColor];
		pointsLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
		pointsLabel.text = [NSString stringWithFormat:@"%@ D", _app.disp_points];
		pointsLabel.textAlignment = UITextAlignmentCenter;
		[ptsView addSubview:pointsLabel];
	}
	
	return (self);
		  
}


-(void)dealloc {
	[_app release];
	
	[super dealloc];
}

@end
