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
		UIView *holderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
		holderView.backgroundColor = [UIColor clearColor];
		[self addSubview:holderView];
		
		UIImageView *imgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainList_itemBG.png"]] autorelease];
		CGRect frame = imgView.frame;
		frame.origin.x = 42;
		frame.origin.y = 32;
		imgView.frame = frame;
		[holderView addSubview:imgView];
				
		_ptsLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 55, 220.0, 64)];
		_ptsLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:54];
		_ptsLabel.backgroundColor = [UIColor clearColor];
		_ptsLabel.textColor = [UIColor colorWithWhite:0.201 alpha:1.0];
		_ptsLabel.textAlignment = UITextAlignmentCenter;
		[holderView addSubview:_ptsLabel];
		
		UIView *tapHereView = [[[UIView alloc] initWithFrame:CGRectMake(66, 95, 105, 20)] autorelease];
		tapHereView.backgroundColor = [UIColor colorWithRed:0.827 green:0.831 blue:0.776 alpha:1.0];
		tapHereView.layer.cornerRadius = 10.0;
		[imgView addSubview:tapHereView];
		
		UILabel *tapHereLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 3, 95, 14)];
		tapHereLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10.0];
		tapHereLabel.backgroundColor = [UIColor clearColor];
		tapHereLabel.textColor = [UIColor colorWithWhite:0.201 alpha:1.0];
		tapHereLabel.text = @"Tap here to redeem";
		[tapHereView addSubview:tapHereLabel];
		
		
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 206, 280.0, 32)];
		_titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:26.0];
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.textColor = [UIColor colorWithWhite:0.201 alpha:1.0];
		_titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
		_titleLabel.textAlignment = UITextAlignmentCenter;
		_titleLabel.shadowColor = [UIColor whiteColor];
		_titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
		[holderView addSubview:_titleLabel];
		
		
		_infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 245, 280.0, 16)];
		_infoLabel.font = [[DIAppDelegate diAdelleFontSemibold] fontWithSize:14.0];
		_infoLabel.backgroundColor = [UIColor clearColor];
		_infoLabel.textColor = [UIColor colorWithWhite:0.398 alpha:1.0];
		_infoLabel.numberOfLines = 0;
		_infoLabel.textAlignment = UITextAlignmentCenter;
		[holderView addSubview:_infoLabel];
		

//		UIImageView *icoView = [[[UIImageView alloc] initWithFrame:CGRectMake(80, 43.0, 17, 17)] autorelease];
//		icoView.image = [UIImage imageNamed:@"piggyIcon.png"];
//		[holderView addSubview:icoView];
		
//		_typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 35, 120.0, 16)];
//		_typeLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10.0];
//		_typeLabel.backgroundColor = [UIColor clearColor];
//		_typeLabel.textColor = [UIColor colorWithWhite:0.45 alpha:1.0];
//		
//		if (_chore.type_id == 1)
//			_typeLabel.text = @"CHORE";
//		else
//			_typeLabel.text = @"REWARD";
//		
//		[holderView addSubview:_typeLabel];
		
//		UIView *ptsHolderView = [[UIView alloc] initWithFrame:CGRectMake(260, 30, 50, 26)];
//		ptsHolderView.backgroundColor = [UIColor colorWithRed:0.922 green:0.953 blue:0.902 alpha:1.0];
//		ptsHolderView.layer.borderColor = [[UIColor colorWithWhite:0.4 alpha:1.0] CGColor];
//		ptsHolderView.layer.borderWidth = 1.0;
//		ptsHolderView.layer.cornerRadius = 8.0;
//		[holderView addSubview:ptsHolderView];
//		
				
		UIImageView *dividerImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_separator.png"]] autorelease];
		frame = dividerImgView.frame;
		frame.origin.x = 30;
		frame.origin.y = 295;
		dividerImgView.frame = frame;
		[self addSubview:dividerImgView];
		
		_overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
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
	
	_titleLabel.text = _chore.title;
	_infoLabel.text = _chore.info;
	_ptsLabel.text = _chore.disp_points;
	
	
//	if (![_chore.imgPath isEqualToString:@"00000000000000"]) {
//		NSData *imageData = [[NSUserDefaults standardUserDefaults] valueForKey:_chore.imgPath];
//		
//		UIImageView *picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 58, 58)];
//		picImageView.image = [UIImage imageWithData:imageData];
//		[_thumbHolderView addSubview:picImageView];
//		
//	}
	
//	UIImageView *cameraImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(29, 31.0, 24, 24)] autorelease];
//	cameraImgView.image = [UIImage imageNamed:@"cameraIcon.png"];
//	[_thumbHolderView addSubview:cameraImgView];	
}


#pragma presentation

@end
