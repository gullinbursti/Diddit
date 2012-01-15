//
//  DIMyChoresViewCell.m
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DIAppDelegate.h"
#import "DIMyChoresViewCell.h"

@implementation DIMyChoresViewCell

@synthesize chore = _chore;


+(NSString *)cellReuseIdentifier {
	return (NSStringFromClass(self));
}

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[[self class] cellReuseIdentifier]])) {
		
		UIView *holderView = [[UIView alloc] initWithFrame:CGRectMake(10, 15, 300, 80)];
		holderView.backgroundColor = [UIColor colorWithRed:0.98034 green:0.9922 blue:0.7843 alpha:1.0];
		holderView.layer.cornerRadius = 8.0;
		holderView.clipsToBounds = YES;
		holderView.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0] CGColor];
		holderView.layer.borderWidth = 1.0;
		[self addSubview:holderView];
		
		_thumbHolderView = [[UIView alloc] initWithFrame:CGRectMake(10, 11, 58, 58)];
		_thumbHolderView.backgroundColor = [UIColor colorWithRed:1.0 green:0.988235294117647 blue:0.874509803921569 alpha:1.0];
		_thumbHolderView.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0] CGColor];
		_thumbHolderView.layer.borderWidth = 1.0;
		_thumbHolderView.clipsToBounds = YES;
		
		UIImageView *emptyImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emptyChoreThumb.jpg"]] autorelease];
		[_thumbHolderView addSubview:emptyImgView];
		
		[holderView addSubview:_thumbHolderView];
		
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 185.0, 22)];
		_titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:17.0];
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.textColor = [UIColor colorWithRed:0.027 green:0.557 blue:0.294 alpha:1.0];
		_titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
		_titleLabel.shadowColor = [UIColor whiteColor];
		_titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
		[holderView addSubview:_titleLabel];
		
		UIImageView *icoView = [[[UIImageView alloc] initWithFrame:CGRectMake(80, 43.0, 17, 17)] autorelease];
		icoView.image = [UIImage imageNamed:@"piggyIcon.png"];
		[holderView addSubview:icoView];
		
		_pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 45, 120.0, 16)];
		_pointsLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10.0];
		_pointsLabel.backgroundColor = [UIColor clearColor];
		_pointsLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
		_pointsLabel.lineBreakMode = UILineBreakModeTailTruncation;
		[holderView addSubview:_pointsLabel];
		
		UIImageView *chevronView = [[[UIImageView alloc] initWithFrame:CGRectMake(270.0, 33.0, 14, 14)] autorelease];
		chevronView.image = [UIImage imageNamed:@"mainListChevron.png"];
		[holderView addSubview:chevronView];
		
		_overlayView = [[UIView alloc] initWithFrame:CGRectMake(10, 15, 300, 80)];
		_overlayView.backgroundColor = [UIColor blackColor];
		_overlayView.layer.cornerRadius = 8.0;
		_overlayView.clipsToBounds = YES;
		_overlayView.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0] CGColor];
		_overlayView.layer.borderWidth = 1.0;
		_overlayView.alpha = 0.0;
		[self addSubview:_overlayView];
		
		
		[holderView release];
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
	[_chore release];
	[_thumbHolderView release];
	[_titleLabel release];
	[_pointsLabel release];
	[_overlayView release];
	
	[super dealloc];
}

#pragma mark - Accessors
- (void)setChore:(DIChore *)chore {
	_chore = chore;
	
	_titleLabel.text = [NSString stringWithFormat:@"%@", _chore.title];		
	_pointsLabel.text = [NSString stringWithFormat:@"%@ didds", _chore.disp_points];
	
	
	if (![_chore.imgPath isEqualToString:@"00000000000000"]) {
		NSData *imageData = [[NSUserDefaults standardUserDefaults] valueForKey:_chore.imgPath];
		
		UIImageView *picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 58, 58)];
		picImageView.image = [UIImage imageWithData:imageData];
		[_thumbHolderView addSubview:picImageView];
		
	}
	
	UIImageView *cameraImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(29, 31.0, 24, 24)] autorelease];
	cameraImgView.image = [UIImage imageNamed:@"cameraIcon.png"];
	[_thumbHolderView addSubview:cameraImgView];	
}


#pragma presentation

@end
