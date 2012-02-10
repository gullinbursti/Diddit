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
		
		UIImageView *dividerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]];
		CGRect frame = dividerImgView.frame;
		frame.origin.y = 79;
		dividerImgView.frame = frame;
		[_holderView addSubview:dividerImgView];
		
		_overlayView = [[UIView alloc] initWithFrame:CGRectMake(0.0, -1.0, 300.0, 81.0)];
		_overlayView.backgroundColor = [UIColor blackColor];
		_overlayView.alpha = 0.0;
		[self addSubview:_overlayView];
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
	//[_app release];
	[_overlayView release];
	
	[super dealloc];
}

#pragma mark - Accessors
- (void)setApp:(DIApp *)app {
	_app = app;
}


#pragma presentation

@end
