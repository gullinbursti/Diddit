//
//  DIDiddsPakView.h
//  Diddit
//
//  Created by Matthew Holcombe on 02.01.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIPricePak.h"

@interface DIDiddsPakView : UIView {
	DIPricePak *_pricePak;
	UIButton *_btn;
	UILabel *_priceLabel;
	
}

@property (nonatomic, retain) UIButton *btn;
@property (nonatomic, retain) UILabel *priceLabel;
@property (nonatomic, retain) DIPricePak *pricePak;
@property (nonatomic) BOOL isSelected;

-(id)initWithPricePak:(DIPricePak *)pricePak;

@end
