//
//  DIDiddsPakView.m
//  Diddit
//
//  Created by Matthew Holcombe on 02.01.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIDiddsPakView.h"
#import "DIAppDelegate.h"

@implementation DIDiddsPakView

@synthesize btn = _btn;
@synthesize priceLabel = _priceLabel;
@synthesize pricePak = _pricePak;
@synthesize isSelected;


-(id)init {
	if ((self = [super init])) {
		_btn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		_btn.frame = CGRectMake(0, 0, 49, 49);
		_btn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		[_btn setBackgroundImage:[[UIImage imageNamed:@"diddsBG.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
		[_btn setBackgroundImage:[[UIImage imageNamed:@"diddsBG.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
		[_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[_btn setTitleEdgeInsets:UIEdgeInsetsMake(-8, 0, 8, 0)];
		[_btn setTitle:_pricePak.disp_points forState:UIControlStateNormal];
		[_btn addTarget:self action:@selector(_goSelected) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_btn];
		
		_priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 50, 50, 16)];
		_priceLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
		_priceLabel.backgroundColor = [UIColor clearColor];
		_priceLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
		_priceLabel.textAlignment = UITextAlignmentCenter;
		_priceLabel.text = _pricePak.price;
		[self addSubview:_priceLabel];
	}
	
	return (self);
}

-(id)initWithPricePak:(DIPricePak *)pricePak {
	_pricePak = pricePak;
	
	if ((self = [self init])) {
		
	}
	
	return (self);
}

-(void)_goSelected {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PRICE_PAK_SELECTED" object:_pricePak];
}
@end
