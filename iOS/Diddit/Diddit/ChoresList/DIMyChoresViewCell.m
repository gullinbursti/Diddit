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
		
		_imgView = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
		[holderView addSubview:_imgView];
		
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 200.0, 22)];
		_titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:17.0];
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.textColor = [UIColor blackColor];
		_titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
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
	}
	
	return (self);
}


-(void)dealloc {
	[super dealloc];
}

#pragma mark - Accessors
- (void)setChore:(DIChore *)chore {
	_chore = chore;
	
	_titleLabel.text = [NSString stringWithFormat:@"%@", _chore.title];		
	_imgView.imageURL = [NSURL URLWithString:_chore.icoPath];
	
	_pointsLabel.text = [NSString stringWithFormat:@"%@ didds", _chore.disp_points];
}


#pragma presentation

@end
