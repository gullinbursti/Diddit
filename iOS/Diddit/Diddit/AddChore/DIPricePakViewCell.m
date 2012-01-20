//
//  DIPricePakViewCell.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.07.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DIPricePakViewCell.h"

#import "DIAppDelegate.h"

@implementation DIPricePakViewCell

@synthesize pricePak = _pricePak;

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
		_pointsLabel.textColor = [UIColor colorWithRed:0.027 green:0.557 blue:0.294 alpha:1.0];
		_pointsLabel.lineBreakMode = UILineBreakModeTailTruncation;
		_pointsLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
		_pointsLabel.shadowOffset = CGSizeMake(1.0, 1.0);
		[self addSubview:_pointsLabel];
		
		_priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, 120.0, 22)];
		_priceLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		_priceLabel.backgroundColor = [UIColor clearColor];
		_priceLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
		_priceLabel.lineBreakMode = UILineBreakModeTailTruncation;
		[self addSubview:_priceLabel];
		
		_circleOffImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(280.0, 40.0, 19, 19)] autorelease];
		_circleOffImgView.image = [UIImage imageNamed:@"circleDot_nonActive.png"];
		[self addSubview:_circleOffImgView];
		
		_circleOnImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(280.0, 40.0, 19, 19)] autorelease];
		_circleOnImgView.image = [UIImage imageNamed:@"circleDot_Active.png"];
		_circleOnImgView.hidden = YES;
		[self addSubview:_circleOnImgView];
		
		_checkImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(283.0, 37.0, 19, 19)] autorelease];
		_checkImgView.image = [UIImage imageNamed:@"checkMarkIcon.png"];
		_checkImgView.alpha = 0.0;
		[self addSubview:_checkImgView];
		
		_dividerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]];
		CGRect frame = _dividerImgView.frame;
		frame.origin.y = 95;
		_dividerImgView.frame = frame;
		[self addSubview:_dividerImgView];
	}
	
	return (self);
}


-(void)dealloc {
	[_pricePak release];
	[_imgView release];
	[_pointsLabel release];
	[_priceLabel release];
	[_circleOffImgView release];
	[_circleOnImgView release];
	[_checkImgView release];
	[_dividerImgView release];
	
	[super dealloc];
}

#pragma mark - Accessors
-(void)setPricePak:(DIPricePak *)pricePak {
	_pricePak = pricePak;
	
	_pointsLabel.text = [NSString stringWithFormat:@"%@ didds", _pricePak.disp_points];
	_priceLabel.text = _pricePak.price;
	
	_imgView.imageURL = [NSURL URLWithString:_pricePak.ico_url];
	//_imgView.imageURL = [NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/app/images/pointPak_ico.png"];
}


#pragma presentation
-(void)toggleSelect:(BOOL)isSelected {
	
	_circleOnImgView.hidden = !isSelected;
	_checkImgView.hidden = !isSelected;
	_dividerImgView.alpha = 0.2;
	
	[UIView animateWithDuration:0.2 animations:^(void) {
		//self.alpha = 0.1 + ((int)isSelected * 0.9);
		_imgView.alpha = 0.2 + ((int)isSelected * 0.8);
		_pointsLabel.alpha = 0.2 + ((int)isSelected * 0.8);
		_priceLabel.alpha = 0.2 + ((int)isSelected * 0.8);
		_circleOnImgView.alpha = 0.2 + ((int)isSelected * 0.8);
		_checkImgView.alpha = (int)isSelected;
	}];
	
	
	[self drawRect:self.frame];
	
	//[UIView animateWithDuration:0.2 animations:^{
	//	_checkImgView.alpha = (int)isSelected;
	//}];
}
@end
