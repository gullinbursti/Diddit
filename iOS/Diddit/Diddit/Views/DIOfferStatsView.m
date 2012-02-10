//
//  DIOfferStatsView.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.21.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIOfferStatsView.h"

#import <QuartzCore/QuartzCore.h>

#import "EGOImageView.h"
#import "DIAppDelegate.h"

@implementation DIOfferStatsView

-(id)initWithCoords:(CGPoint)pos offerVO:(DIOffer *)offer {
	if ((self = [super initWithFrame:CGRectMake(pos.x, pos.y, 300.0, 60.0)])) {
		_offer = offer;
		
		EGOImageView *icoImgView = [[[EGOImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 60, 60)] autorelease];
		icoImgView.imageURL = [NSURL URLWithString:_offer.ico_url];
		icoImgView.layer.cornerRadius = 8.0;
		icoImgView.clipsToBounds = YES;
		icoImgView.layer.borderColor = [[UIColor colorWithWhite:0.67 alpha:1.0] CGColor];
		icoImgView.layer.borderWidth = 1.0;
		[self addSubview:icoImgView];
		
		UILabel *appTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(66.0, 5.0, 180.0, 22)] autorelease];
		appTitleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
		appTitleLabel.backgroundColor = [UIColor clearColor];
		appTitleLabel.textColor = [UIColor colorWithRed:0.208 green:0.682 blue:0.369 alpha:1.0];
		appTitleLabel.text = _offer.app_name;
		[self addSubview:appTitleLabel];
		
		UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(66.0, 23.0, 300.0, 16)] autorelease];
		infoLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:14];
		infoLabel.textColor = [UIColor blackColor];
		infoLabel.backgroundColor = [UIColor clearColor];
		infoLabel.text = _offer.title;
		[self addSubview:infoLabel];
		
		_ptsView = [[[UIView alloc] initWithFrame:CGRectMake(247.0, 16.0, 52, 30)] autorelease];
		_ptsView.backgroundColor = [UIColor colorWithRed:0.976 green:0.976 blue:0.929 alpha:1.0];
		_ptsView.layer.cornerRadius = 6.0;
		_ptsView.clipsToBounds = YES;
		_ptsView.layer.borderColor = [[UIColor colorWithWhite:0.67 alpha:1.0] CGColor];
		_ptsView.layer.borderWidth = 2.0;
		[self addSubview:_ptsView];
		
		_ptsLbl = [[[UILabel alloc] initWithFrame:CGRectMake(0, 5, 52, 20)] autorelease];
		_ptsLbl.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
		_ptsLbl.backgroundColor = [UIColor clearColor];
		_ptsLbl.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
		_ptsLbl.text = [NSString stringWithFormat:@"%@ D", _offer.disp_points];
		_ptsLbl.textAlignment = UITextAlignmentCenter;
		[_ptsView addSubview:_ptsLbl];
	}
	
	return (self);
	
}

-(void)makePuchased {
	CGRect frame = _ptsView.frame;
	frame.origin.x = 217;
	frame.size.width = 82;
	_ptsView.frame = frame;
	
	frame = _ptsLbl.frame;
	frame.origin.x = 0;
	frame.size.width = 82;
	_ptsLbl.frame = frame;
	
	_ptsLbl.text = @"PURCHASED";
}


-(void)dealloc {
	[_offer release];
	//[_ptsLbl release];
	
	[super dealloc];
}


@end
