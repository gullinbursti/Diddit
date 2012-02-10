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
-(id)initWithIndex:(int)index {
	if ((self = [super init])) {
		
		int bgAlpha;
		
		if (index % 2 == 0)
			bgAlpha = 5;//10;
		
		else
			bgAlpha = 5;
		
		
		UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"rowBG_%dpercent.png",bgAlpha]]] autorelease];
		[self addSubview:bgImgView];
		
		
		UIView *holderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
		holderView.backgroundColor = [UIColor clearColor];
		[self addSubview:holderView];
		
		_avatarImgView = [[[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)] autorelease];
		
		_ptsLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 54, 16)];
		_ptsLabel.font = [[DIAppDelegate diAdelleFontSemibold] fontWithSize:12];
		_ptsLabel.backgroundColor = [UIColor clearColor];
		_ptsLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
		_ptsLabel.textAlignment = UITextAlignmentCenter;
		[holderView addSubview:_ptsLabel];
		
		_typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 150, 16)];
		_typeLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10];
		_typeLabel.backgroundColor = [UIColor clearColor];
		_typeLabel.textColor = [UIColor colorWithWhite:0.201 alpha:1.0];
		[holderView addSubview:_typeLabel];
		
		_dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(245, 30, 80.0, 14)];
		_dateLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10];
		_dateLabel.backgroundColor = [UIColor clearColor];
		_dateLabel.textColor = [UIColor colorWithWhite:0.201 alpha:1.0];
		[holderView addSubview:_dateLabel];
		
		UIImageView *dividerImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]] autorelease];
		CGRect frame = dividerImgView.frame;
		frame.origin.x = 10;
		frame.origin.y = 70;
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
	/*[_chore release];
	[_typeLabel release];
	[_ptsLabel release];
	[_dateLabel release];
	[_avatarImgView release];
	[_overlayView release];
	*/
	[super dealloc];
}

#pragma mark - Accessors
- (void)setChore:(DIChore *)chore {
	_chore = chore;
	
	//_avatarImgView.imageURL = [NSURL URLWithString:_chore.icoPath];
	_ptsLabel.text = [NSString stringWithFormat:@"%@ didds", _chore.disp_points];
	
	if (_chore.type_id == 1)
		_typeLabel.text = @"CHORE";
		
	else if (_chore.type_id == 2)
		_typeLabel.text = @"REWARD";
	
	else
		_typeLabel.text = @"APP";
	
	_dateLabel.text = _chore.disp_expires;
}
@end
