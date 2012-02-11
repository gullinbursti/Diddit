//
//  DIOfferViewCell.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DIAppDelegate.h"
#import "DIOfferViewCell.h"
#import "DIAppRatingStarsView.h"


@implementation DIOfferViewCell

@synthesize offer = _offer;


+(NSString *)cellReuseIdentifier {
	return (NSStringFromClass(self));
}

#pragma mark - View lifecycle
-(id)initWithIndex:(int)index {
	if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[[self class] cellReuseIdentifier]])) {
		
		if (index % 2 == 0) {
			UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tablerow-l_BG.png"]] autorelease];
			[self addSubview:bgImgView];
		}
		
		UIView *holderView = [[[UIView alloc] initWithFrame:CGRectMake(17, 17, 300, 80)] autorelease];
		holderView.backgroundColor = [UIColor clearColor];
		[self addSubview:holderView];
		
		_imgView = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, 57, 57)];
		_imgView.layer.cornerRadius = 8.0;
		_imgView.clipsToBounds = YES;
		_imgView.layer.borderColor = [[UIColor colorWithWhite:0.67 alpha:1.0] CGColor];
		_imgView.layer.borderWidth = 1.0;
		[holderView addSubview:_imgView];
		
		_typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(86, 5, 185.0, 22)];
		_typeLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
		_typeLabel.backgroundColor = [UIColor clearColor];
		_typeLabel.textColor = [DIAppDelegate diColor666666];
		_typeLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
		_typeLabel.shadowOffset = CGSizeMake(1.0, 1.0);
		_typeLabel.lineBreakMode = UILineBreakModeTailTruncation;
		_typeLabel.text = @"TRAILER";
		[holderView addSubview:_typeLabel];
		
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(86, 18, 150.0, 22)];
		_titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:14.0];
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.textColor = [UIColor blackColor];
		_titleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
		_titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
		_titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
		[holderView addSubview:_titleLabel];
		
		_starsView = [[[DIAppRatingStarsView alloc] initWithCoords:CGPointMake(86, 36) appScore:4] autorelease];
		[holderView addSubview:_starsView];
		
		UIView *ptsView = [[[UIView alloc] initWithFrame:CGRectMake(238, 16, 50, 25)] autorelease];
		ptsView.backgroundColor = [UIColor whiteColor];
		ptsView.layer.cornerRadius = 8.0;
		ptsView.clipsToBounds = YES;
		ptsView.layer.borderColor = [[UIColor colorWithWhite:0.67 alpha:1.0] CGColor];
		ptsView.layer.borderWidth = 1.0;
		[holderView addSubview:ptsView];
		
		_pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 50.0, 16)];
		_pointsLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10.0];
		_pointsLabel.backgroundColor = [UIColor clearColor];
		_pointsLabel.textColor = [DIAppDelegate diColor333333];
		_pointsLabel.textAlignment = UITextAlignmentCenter;
		[ptsView addSubview:_pointsLabel];
	}
	
	return (self);
}

-(void)toggleSelected {
	/*
	[UIView animateWithDuration:0.25 animations:^(void) {
		_overlayView.alpha = 0.5;
		
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.15 animations:^(void) {
			_overlayView.alpha = 0.0;
		}];		
	}];
	*/
}

-(void)dealloc {
	[_imgView release];
	[_titleLabel release];
	[_pointsLabel release];
	[_offer release];
	
	[super dealloc];
}

#pragma mark - Accessors
- (void)setOffer:(DIOffer *)offer {
	_offer = offer;
	
	_titleLabel.text = [NSString stringWithFormat:@"%@", _offer.title];		
	_imgView.imageURL = [NSURL URLWithString:_offer.ico_url];
	
	_pointsLabel.text = [NSString stringWithFormat:@"%@ D", _offer.disp_points];
}


#pragma presentation

@end
