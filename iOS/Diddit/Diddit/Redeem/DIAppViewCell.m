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
		
		UIView *holderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 80)];
		[self addSubview:holderView];
		
		UIImageView *dividerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]];
		[holderView addSubview:dividerImgView];
		
		_imgView = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
		[holderView addSubview:_imgView];
		
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 25, 200.0, 22)];
		_titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.textColor = [UIColor blackColor];
		_titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
		[holderView addSubview:_titleLabel];
		
		_infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 45, 200.0, 22)];
		_infoLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
		_infoLabel.backgroundColor = [UIColor clearColor];
		_infoLabel.textColor = [UIColor colorWithWhite:0.67 alpha:1.0];
		_infoLabel.lineBreakMode = UILineBreakModeTailTruncation;
		[holderView addSubview:_infoLabel];
		
		_pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 40, 120.0, 16)];
		_pointsLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10.0];
		_pointsLabel.backgroundColor = [UIColor clearColor];
		_pointsLabel.textColor = [UIColor colorWithWhite:0.67 alpha:1.0];
		_pointsLabel.lineBreakMode = UILineBreakModeTailTruncation;
		_pointsLabel.textAlignment = UITextAlignmentRight;
		[holderView addSubview:_pointsLabel];
	}
	
	return (self);
}


-(void)dealloc {
	[super dealloc];
}

#pragma mark - Accessors
- (void)setApp:(DIApp *)app {
	_app = app;
	
	_titleLabel.text = _app.title;		
	_infoLabel.text = _app.info;
	_imgView.imageURL = [NSURL URLWithString:_app.ico_url];
	_pointsLabel.text = [NSString stringWithFormat:@"%@ didds", _app.disp_points];
}


#pragma presentation

@end
