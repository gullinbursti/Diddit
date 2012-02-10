//
//  DICreditsViewCell.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.13.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DIStoreCreditsViewCell.h"
#import "DIAppDelegate.h"

@implementation DIStoreCreditsViewCell

@synthesize app = _app;
@synthesize shouldDrawSeparator = _shouldDrawSeparator;


+(NSString *)cellReuseIdentifier {
	return (NSStringFromClass(self));
}

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[[self class] cellReuseIdentifier]])) {
		
		
		_holderView = [[UIView alloc] initWithFrame:CGRectMake(10, 15, 300, 80)];
		[self addSubview:_holderView];
		
		UIImageView *dividerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]];
		CGRect frame = dividerImgView.frame;
		frame.origin.x = -10;
		frame.origin.y = 70;
		dividerImgView.frame = frame;
		[_holderView addSubview:dividerImgView];
		
		//_overlayView = [[UIView alloc] initWithFrame:CGRectMake(0.0, -1.0, 300.0, 81.0)];
		//_overlayView.backgroundColor = [UIColor blackColor];
		//_overlayView.alpha = 0.0;
		//[self addSubview:_overlayView];
		
		_icoImgView = [[[EGOImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 60, 60)] autorelease];
		_icoImgView.imageURL = [NSURL URLWithString:_app.ico_url];
		_icoImgView.layer.cornerRadius = 8.0;
		_icoImgView.clipsToBounds = YES;
		_icoImgView.layer.borderColor = [[UIColor colorWithWhite:0.67 alpha:1.0] CGColor];
		_icoImgView.layer.borderWidth = 1.0;
		[_holderView addSubview:_icoImgView];
		
		_titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(66.0, 5.0, 180.0, 22)] autorelease];
		_titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.textColor = [UIColor colorWithRed:0.208 green:0.682 blue:0.369 alpha:1.0];
		[_holderView addSubview:_titleLabel];
		
		_infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(66.0, 23.0, 300.0, 16)] autorelease];
		_infoLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:14];
		_infoLabel.textColor = [UIColor blackColor];
		_infoLabel.backgroundColor = [UIColor clearColor];
		[_holderView addSubview:_infoLabel];
		
		UIView *ptsView = [[[UIView alloc] initWithFrame:CGRectMake(220.0, 16.0, 78, 30)] autorelease];
		ptsView.backgroundColor = [UIColor colorWithRed:0.976 green:0.976 blue:0.929 alpha:1.0];
		ptsView.layer.cornerRadius = 6.0;
		ptsView.clipsToBounds = YES;
		ptsView.layer.borderColor = [[UIColor colorWithWhite:0.67 alpha:1.0] CGColor];
		ptsView.layer.borderWidth = 1.0;
		[_holderView addSubview:ptsView];
		
		UILabel *ptsLbl = [[[UILabel alloc] initWithFrame:CGRectMake(0, 6, 78, 20)] autorelease];
		ptsLbl.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10.0];
		ptsLbl.backgroundColor = [UIColor clearColor];
		ptsLbl.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
		ptsLbl.text = @"PURCHASED";
		ptsLbl.textAlignment = UITextAlignmentCenter;
		[ptsView addSubview:ptsLbl];
	}
	
	return (self);
}


-(void)dealloc {
	[_icoImgView release];
	[_titleLabel release];
	[_infoLabel release];
	[_app release];
	
	[super dealloc];
}

#pragma mark - Accessors
- (void)setApp:(DIApp *)app {
	_app = app;
	
	_icoImgView.imageURL = [NSURL URLWithString:_app.ico_url];
	_titleLabel.text = [NSString stringWithFormat:@"%@", _app.title];		
	_infoLabel.text = _app.info;
}


#pragma presentation
- (void)setShouldDrawSeparator:(BOOL)shouldDrawSeparator {
	_shouldDrawSeparator = shouldDrawSeparator;
	[[self viewWithTag:1] setHidden:shouldDrawSeparator];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}

@end
