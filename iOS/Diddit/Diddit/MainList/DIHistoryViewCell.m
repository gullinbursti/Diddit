//
//  DIHistoryViewCell.m
//  Diddit
//
//  Created by Matthew Holcombe on 02.04.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIHistoryViewCell.h"
#import "DIAppDelegate.h"

#import "DIChore.h"

#import <QuartzCore/QuartzCore.h>

@implementation DIHistoryViewCell

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
		
		_avatarImgView = [[[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)] autorelease];
		
		_ptsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 23, 54, 16)];
		_ptsLabel.font = [[DIAppDelegate diAdelleFontSemibold] fontWithSize:16];
		_ptsLabel.backgroundColor = [UIColor clearColor];
		_ptsLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
		_ptsLabel.textAlignment = UITextAlignmentCenter;
		[holderView addSubview:_ptsLabel];
		
		_typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 20, 150, 16)];
		_typeLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10];
		_typeLabel.backgroundColor = [UIColor clearColor];
		_typeLabel.textColor = [UIColor colorWithWhite:0.201 alpha:1.0];
		[holderView addSubview:_typeLabel];
				
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
	[_typeLabel release];
	[_ptsLabel release];
	[_dateLabel release];
	[_avatarImgView release];
	[_overlayView release];
	
	[super dealloc];
}

#pragma mark - Accessors
- (void)setChore:(DIChore *)chore {
	_chore = chore;
	
	//_avatarImgView.imageURL = [NSURL URLWithString:_chore.icoPath];
	_ptsLabel.text = _chore.disp_points;
	
	if (_chore.type_id == 1)
		_typeLabel.text = @"CHORE";
		
	else if (_chore.type_id == 2)
		_typeLabel.text = @"REWARD";
	
	else
		_typeLabel.text = @"APP";
	
	_dateLabel.text = _chore.disp_expires;
}
@end
