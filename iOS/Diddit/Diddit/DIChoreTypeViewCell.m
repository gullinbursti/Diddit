//
//  DIChoreTypeViewCell.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.13.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DIChoreTypeViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation DIChoreTypeViewCell

@synthesize choreType = _choreType;
@synthesize shouldDrawSeparator = _shouldDrawSeparator;

+(NSString *)cellReuseIdentifier {
	return (NSStringFromClass(self));
}

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[[self class] cellReuseIdentifier]])) {
		_imgView = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 32, 32)];
		_imgView.layer.cornerRadius = 8.0;
		_imgView.clipsToBounds = YES;
		_imgView.layer.borderColor = [[UIColor colorWithWhite:0.671 alpha:1.0] CGColor];
		_imgView.layer.borderWidth = 1.0;
		[self addSubview:_imgView];
		
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 10, 230.0, 20)];
		//_titleLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:11.0];
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.textColor = [UIColor colorWithRed:0.039 green:0.478 blue:0.938 alpha:1.0];
		_titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
		[self addSubview:_titleLabel];
		
		_infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 25, 230.0, 16)];
		//_dateLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:9.5];
		_infoLabel.backgroundColor = [UIColor clearColor];
		_infoLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
		_infoLabel.lineBreakMode = UILineBreakModeTailTruncation;
		[self addSubview:_infoLabel];
		
		UIImageView *chevronView = [[[UIImageView alloc] initWithFrame:CGRectMake(276.0, 20.0, 9, 12)] autorelease];
		chevronView.image = [UIImage imageNamed:@"smallChevron.png"];
		[self addSubview:chevronView];
	}
	
	return (self);
}


-(void)dealloc {
	[super dealloc];
}

#pragma mark - Accessors
- (void)setChoreType:(DIChoreType *)choreType {
	_choreType = choreType;
	
	_titleLabel.text = _choreType.title;		
	_imgView.imageURL = [NSURL URLWithString:_choreType.imgPath];
	_infoLabel.text = _choreType.info;
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
