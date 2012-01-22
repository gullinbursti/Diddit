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
		
		_imgView = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 59, 59)];
		_imgView.backgroundColor = [UIColor colorWithRed:0.980 green:0.996 blue:0.898 alpha:1.0];
		_imgView.layer.cornerRadius = 8.0;
		_imgView.clipsToBounds = YES;
		_imgView.layer.borderColor = [[UIColor colorWithWhite:0.67 alpha:1.0] CGColor];
		_imgView.layer.borderWidth = 1.0;
		[self addSubview:_imgView];
		
		
		_currencyLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 19, 120.0, 22)];
		_currencyLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		_currencyLabel.backgroundColor = [UIColor clearColor];
		_currencyLabel.textColor = [UIColor colorWithRed:0.000 green:0.663 blue:0.314 alpha:1.0];
		_currencyLabel.text = @"Currency";
		[self addSubview:_currencyLabel];

		_pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 36, 200.0, 22)];
		_pointsLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:15.0];
		_pointsLabel.backgroundColor = [UIColor clearColor];
		_pointsLabel.textColor = [UIColor blackColor];
		_pointsLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
		_pointsLabel.shadowOffset = CGSizeMake(1.0, 1.0);
		[self addSubview:_pointsLabel];
		
		_priceView = [[[UIView alloc] initWithFrame:CGRectMake(255.0, 27.0, 40, 27)] autorelease];
		_priceView.backgroundColor = [UIColor colorWithRed:0.976 green:0.976 blue:0.929 alpha:1.0];
		_priceView.layer.cornerRadius = 6.0;
		_priceView.clipsToBounds = YES;
		_priceView.layer.borderColor = [[UIColor colorWithWhite:0.67 alpha:1.0] CGColor];
		_priceView.layer.borderWidth = 1.0;
		[self addSubview:_priceView];
		
		_priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 40, 22)];
		_priceLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10.0];
		_priceLabel.backgroundColor = [UIColor clearColor];
		_priceLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
		_priceLabel.textAlignment = UITextAlignmentCenter;
		[_priceView addSubview:_priceLabel];
		
		_dividerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]];
		CGRect frame = _dividerImgView.frame;
		frame.origin.y = 81;
		_dividerImgView.frame = frame;
		[self addSubview:_dividerImgView];
	}
	
	return (self);
}


-(void)dealloc {
	[_pricePak release];
	[_imgView release];
	[_pointsLabel release];
	[_priceView release];
	[_priceLabel release];
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
	
	_dividerImgView.alpha = 0.2;
	
	[UIView animateWithDuration:0.2 animations:^(void) {
		//self.alpha = 0.1 + ((int)isSelected * 0.9);
		_imgView.alpha = 0.2 + ((int)isSelected * 0.8);
		_pointsLabel.alpha = 0.2 + ((int)isSelected * 0.8);
		_priceView.alpha = 0.2 + ((int)isSelected * 0.8);
	}];
	
	
	[self drawRect:self.frame];
	
	//[UIView animateWithDuration:0.2 animations:^{
	//	_checkImgView.alpha = (int)isSelected;
	//}];
}
@end
