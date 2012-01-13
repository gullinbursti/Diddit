//
//  DICreditsViewCell.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.13.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DIStoreCreditsViewCell.h"

@implementation DIStoreCreditsViewCell

@synthesize app = _app;
@synthesize shouldDrawSeparator = _shouldDrawSeparator;


+(NSString *)cellReuseIdentifier {
	return (NSStringFromClass(self));
}

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[[self class] cellReuseIdentifier]])) {
		_icoView = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 32, 32)];
		_icoView.layer.cornerRadius = 8.0;
		_icoView.clipsToBounds = YES;
		_icoView.layer.borderColor = [[UIColor colorWithWhite:0.671 alpha:1.0] CGColor];
		_icoView.layer.borderWidth = 1.0;
		[self addSubview:_icoView];
		
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 10, 200.0, 20)];
		//_titleLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:11.0];
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.textColor = [UIColor colorWithRed:0.039 green:0.478 blue:0.938 alpha:1.0];
		_titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
		[self addSubview:_titleLabel];
		
		_infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 25, 200.0, 16)];
		//_dateLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:9.5];
		_infoLabel.backgroundColor = [UIColor clearColor];
		_infoLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
		_infoLabel.lineBreakMode = UILineBreakModeTailTruncation;
		[self addSubview:_infoLabel];
		
		_pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 10, 80.0, 16)];
		//_pointsLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:9.5];
		_pointsLabel.backgroundColor = [UIColor clearColor];
		_pointsLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
		_pointsLabel.lineBreakMode = UILineBreakModeTailTruncation;
		[self addSubview:_pointsLabel];
		
		UIImageView *chevronView = [[[UIImageView alloc] initWithFrame:CGRectMake(300.0, 20.0, 9, 12)] autorelease];
		chevronView.image = [UIImage imageNamed:@"smallChevron.png"];
		[self addSubview:chevronView];
	}
	
	return (self);
}


-(void)dealloc {
	[super dealloc];
}

#pragma mark - Accessors
- (void)setApp:(DIApp *)app {
	_app = app;
	
	_titleLabel.text = [NSString stringWithFormat:@"%@", _app.title];		
	_icoView.imageURL = [NSURL URLWithString:_app.ico_url];
	_infoLabel.text = _app.info;
	_pointsLabel.text = [NSString stringWithFormat:@"%dpts", _app.points];
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
