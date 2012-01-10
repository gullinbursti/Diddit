//
//  DIRewardViewCell.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.07.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DIRewardViewCell.h"

#import "DIAppDelegate.h"

@implementation DIRewardViewCell

@synthesize reward = _reward;

+(NSString *)cellReuseIdentifier {
	return (NSStringFromClass(self));
}




#pragma mark - View lifecycle
-(id)init {
	if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[[self class] cellReuseIdentifier]])) {
				
		_imgView = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 20, 59, 59)];
		[self addSubview:_imgView];
		
		_pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 200.0, 22)];
		_pointsLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:17.0];
		_pointsLabel.backgroundColor = [UIColor clearColor];
		_pointsLabel.textColor = [UIColor blackColor];
		_pointsLabel.lineBreakMode = UILineBreakModeTailTruncation;
		[self addSubview:_pointsLabel];
		
		_priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, 120.0, 22)];
		_priceLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		_priceLabel.backgroundColor = [UIColor clearColor];
		_priceLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
		_priceLabel.lineBreakMode = UILineBreakModeTailTruncation;
		[self addSubview:_priceLabel];
		
		_circleOffImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(280.0, 40.0, 24, 24)] autorelease];
		_circleOffImgView.image = [UIImage imageNamed:@"circleDot_nonActive.png"];
		[self addSubview:_circleOffImgView];
		
		_circleOnImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(280.0, 40.0, 24, 24)] autorelease];
		_circleOnImgView.image = [UIImage imageNamed:@"circleDot_Active.png"];
		_circleOnImgView.hidden = YES;
		[self addSubview:_circleOnImgView];
		
		_checkImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(283.0, 37.0, 24, 24)] autorelease];
		_checkImgView.image = [UIImage imageNamed:@"checkMarkIcon.png"];
		_checkImgView.hidden = YES;
		[self addSubview:_checkImgView];
		
		UIImageView *dividerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]];
		CGRect frame = dividerImgView.frame;
		frame.origin.y = 95;
		dividerImgView.frame = frame;
		[self addSubview:dividerImgView];
	}
	
	return (self);
}


-(void)dealloc {
	[super dealloc];
}

#pragma mark - Accessors
-(void)setReward:(DIReward *)reward {
	_reward = reward;
	
	_pointsLabel.text = [NSString stringWithFormat:@"%@ didds", _reward.disp_points];
	_priceLabel.text = _reward.price;
	
	_imgView.imageURL = [NSURL URLWithString:_reward.ico_url];
}


#pragma presentation
-(void)toggleSelect:(BOOL)isSelected {
	
	_circleOffImgView.hidden = isSelected;
	_circleOnImgView.hidden = !isSelected;
	_checkImgView.hidden = !isSelected;
	
	//[UIView animateWithDuration:0.2 animations:^{
	//	_checkImgView.alpha = (int)isSelected;
	//}];
}
@end
