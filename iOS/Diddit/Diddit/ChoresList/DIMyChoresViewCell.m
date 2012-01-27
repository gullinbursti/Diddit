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
		UIView *holderView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 300, 80)];
		holderView.backgroundColor = [UIColor clearColor];
		[self addSubview:holderView];
		
		_thumbHolderView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 58, 58)];
		_thumbHolderView.backgroundColor = [UIColor whiteColor];
		_thumbHolderView.layer.borderColor = [[UIColor colorWithWhite:0.4 alpha:1.0] CGColor];
		_thumbHolderView.layer.borderWidth = 1.0;
		_thumbHolderView.layer.cornerRadius = 8.0;
		_thumbHolderView.clipsToBounds = YES;
		[holderView addSubview:_thumbHolderView];
		
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 10, 185.0, 22)];
		_titleLabel.font = [[DIAppDelegate diAdelleFontRegular] fontWithSize:18.0];
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
		_titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
		_titleLabel.shadowColor = [UIColor whiteColor];
		_titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
		[holderView addSubview:_titleLabel];

//		UIImageView *icoView = [[[UIImageView alloc] initWithFrame:CGRectMake(80, 43.0, 17, 17)] autorelease];
//		icoView.image = [UIImage imageNamed:@"piggyIcon.png"];
//		[holderView addSubview:icoView];
		
		_typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 35, 120.0, 16)];
		_typeLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10.0];
		_typeLabel.backgroundColor = [UIColor clearColor];
		_typeLabel.textColor = [UIColor colorWithWhite:0.45 alpha:1.0];
		_typeLabel.text = @"REWARD";
		[holderView addSubview:_typeLabel];
		
		UIView *ptsHolderView = [[UIView alloc] initWithFrame:CGRectMake(260, 30, 50, 26)];
		ptsHolderView.backgroundColor = [UIColor colorWithRed:0.922 green:0.953 blue:0.902 alpha:1.0];
		ptsHolderView.layer.borderColor = [[UIColor colorWithWhite:0.4 alpha:1.0] CGColor];
		ptsHolderView.layer.borderWidth = 1.0;
		ptsHolderView.layer.cornerRadius = 8.0;
		[self addSubview:ptsHolderView];
		
		_ptsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 50.0, 16)];
		_ptsLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10.0];
		_ptsLabel.backgroundColor = [UIColor clearColor];
		_ptsLabel.textColor = [UIColor colorWithWhite:0.45 alpha:1.0];
		_ptsLabel.textAlignment = UITextAlignmentCenter;
		[ptsHolderView addSubview:_ptsLabel];
		
		_overlayView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 80)];
		_overlayView.backgroundColor = [UIColor blackColor];
		_overlayView.layer.cornerRadius = 8.0;
		_overlayView.clipsToBounds = YES;
		_overlayView.layer.borderColor = [[UIColor colorWithWhite:0.67 alpha:1.0] CGColor];
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
	[_ptsLabel release];
	[_overlayView release];
	
	[super dealloc];
}

#pragma mark - Accessors
- (void)setChore:(DIChore *)chore {
	_chore = chore;
	
	_titleLabel.text = [NSString stringWithFormat:@"%@", _chore.title];		
	_ptsLabel.text = [NSString stringWithFormat:@"%@ D", _chore.disp_points];
	
	
	if (![_chore.imgPath isEqualToString:@"00000000000000"]) {
		NSData *imageData = [[NSUserDefaults standardUserDefaults] valueForKey:_chore.imgPath];
		
		UIImageView *picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 58, 58)];
		picImageView.image = [UIImage imageWithData:imageData];
		[_thumbHolderView addSubview:picImageView];
		
	}
	
//	UIImageView *cameraImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(29, 31.0, 24, 24)] autorelease];
//	cameraImgView.image = [UIImage imageNamed:@"cameraIcon.png"];
//	[_thumbHolderView addSubview:cameraImgView];	
}


#pragma presentation

@end
