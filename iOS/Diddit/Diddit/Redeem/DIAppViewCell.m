//
//  DIAppViewCell.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DIAppViewCell.h"
#import "DIAppDelegate.h"
#import "DIAppStatsView.h"

@implementation DIAppViewCell

@synthesize app = _app;


+(NSString *)cellReuseIdentifier {
	return (NSStringFromClass(self));
}

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[[self class] cellReuseIdentifier]])) {
		
		_holderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 80)];
		[self addSubview:_holderView];
		
		/*
		_imgView = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 11, 60, 60)];
		_imgView.layer.cornerRadius = 8.0;
		_imgView.clipsToBounds = YES;
		_imgView.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0] CGColor];
		_imgView.layer.borderWidth = 1.0;
		[holderView addSubview:_imgView];
		
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 25, 200.0, 22)];
		_titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.textColor = [UIColor colorWithRed:0.000 green:0.663 blue:0.314 alpha:1.0];
		[holderView addSubview:_titleLabel];
		
		_infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 45, 200.0, 22)];
		_infoLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
		_infoLabel.backgroundColor = [UIColor clearColor];
		_infoLabel.textColor = [UIColor blackColor];
		[holderView addSubview:_infoLabel];
		
		_pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 40, 120.0, 16)];
		_pointsLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10.0];
		_pointsLabel.backgroundColor = [UIColor clearColor];
		_pointsLabel.textColor = [UIColor colorWithWhite:0.67 alpha:1.0];
		_pointsLabel.lineBreakMode = UILineBreakModeTailTruncation;
		_pointsLabel.textAlignment = UITextAlignmentRight;
		[holderView addSubview:_pointsLabel];
		*/
		
		UIImageView *dividerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]];
		CGRect frame = dividerImgView.frame;
		frame.origin.y = 79;
		dividerImgView.frame = frame;
		[_holderView addSubview:dividerImgView];
		
		_overlayView = [[UIView alloc] initWithFrame:CGRectMake(0.0, -1.0, 300.0, 81.0)];
		_overlayView.backgroundColor = [UIColor blackColor];
		_overlayView.alpha = 0.0;
		[self addSubview:_holderView];
	}
	
	return (self);
}

-(void)toggleSelected {
	[UIView animateWithDuration:0.25 animations:^(void) {
		_overlayView.alpha = 0.5;
		
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.15 animations:^(void) {
			_overlayView.alpha = 0.0;
		}];		
	}];
}


-(void)dealloc {
	[_imgView release];
	[_titleLabel release];
	[_infoLabel release];
	[_pointsLabel release];
	[_app release];
	[_overlayView release];
	
	[super dealloc];
}

#pragma mark - Accessors
- (void)setApp:(DIApp *)app {
	_app = app;
	
	DIAppStatsView *appStatsView = [[[DIAppStatsView alloc] initWithCoords:CGPointMake(10.0, 10.0) appVO:_app] autorelease];
	[_holderView addSubview:appStatsView];
	
	/*
	_titleLabel.text = _app.title;		
	_infoLabel.text = _app.info;
	_imgView.imageURL = [NSURL URLWithString:_app.ico_url];
	_pointsLabel.text = [NSString stringWithFormat:@"%@ didds", _app.disp_points];
	*/
}


#pragma presentation

@end
