//
//  DIActivityViewCell.m
//  Diddit
//
//  Created by Matthew Holcombe on 02.04.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIActivityViewCell.h"
#import "DIAppDelegate.h"

#import <QuartzCore/QuartzCore.h>

@implementation DIActivityViewCell

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
		
		UIImageView *icoView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 44, 44)] autorelease];
		icoView.image = [UIImage imageNamed:@"avatarBG.png"];
		[holderView addSubview:icoView];
		
		_ptsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 23, 54, 16)];
		_ptsLabel.font = [[DIAppDelegate diAdelleFontSemibold] fontWithSize:16];
		_ptsLabel.backgroundColor = [UIColor clearColor];
		_ptsLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
		_ptsLabel.textAlignment = UITextAlignmentCenter;
		//[icoView addSubview:_ptsLabel];
		
		_typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 20, 150, 16)];
		_typeLabel.font = [[DIAppDelegate diOpenSansFontRegular] fontWithSize:10];
		_typeLabel.backgroundColor = [UIColor clearColor];
		_typeLabel.textColor = [UIColor colorWithWhite:0.201 alpha:1.0];
		[holderView addSubview:_typeLabel];
		
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 40, 180.0, 20)];
		_titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:14.0];
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.textColor = [UIColor colorWithWhite:0.201 alpha:1.0];
		_titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
		_titleLabel.shadowColor = [UIColor whiteColor];
		_titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
		[holderView addSubview:_titleLabel];
		
		_approveButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		_approveButton.frame = CGRectMake(245, 27, 66, 30);
		_approveButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		[_approveButton setBackgroundImage:[[UIImage imageNamed:@"infoButtonBG.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
		[_approveButton setBackgroundImage:[[UIImage imageNamed:@"infoButtonBG.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
		[_approveButton setTitleColor:[UIColor colorWithWhite:0.2588 alpha:1.0] forState:UIControlStateNormal];
		[_approveButton setTitle:@"APPROVE" forState:UIControlStateNormal];
		[_approveButton addTarget:self action:@selector(_goApprove) forControlEvents:UIControlEventTouchUpInside];
		[holderView addSubview:_approveButton];
		
		_dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(245, 35, 80.0, 14)];
		_dateLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10];
		_dateLabel.backgroundColor = [UIColor clearColor];
		_dateLabel.textColor = [UIColor colorWithWhite:0.201 alpha:1.0];
		[holderView addSubview:_dateLabel];
		
		UIImageView *dividerImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_separator.png"]] autorelease];
		CGRect frame = dividerImgView.frame;
		frame.origin.x = 30;
		frame.origin.y = 80;
		dividerImgView.frame = frame;
		//[self addSubview:dividerImgView];
		
		_overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
		_overlayView.backgroundColor = [UIColor blackColor];
		_overlayView.layer.cornerRadius = 8.0;
		_overlayView.clipsToBounds = YES;
		_overlayView.layer.borderColor = [[UIColor colorWithWhite:0.67 alpha:1.0] CGColor];
		_overlayView.layer.borderWidth = 1.0;
		_overlayView.alpha = 0.0;
		//[self addSubview:_overlayView];
		
		
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

-(void)_goApprove {
	
}


-(void)dealloc {
	[_chore release];
	[_thumbHolderView release];
	[_titleLabel release];
	[_typeLabel release];
	[_ptsLabel release];
	[_overlayView release];
	
	[super dealloc];
}

#pragma mark - Accessors
- (void)setChore:(DIChore *)chore {
	_chore = chore;
	
	_titleLabel.text = _chore.title;
	_ptsLabel.text = _chore.disp_points;
	
	if (_chore.type_id == 1) {
		_typeLabel.text = @"CHORE";
		_dateLabel.hidden = YES;
	
	} else {
		_typeLabel.text = @"REWARD";
		_approveButton.hidden = YES;
	}
	
	_dateLabel.text = _chore.disp_expires;
}

@end
