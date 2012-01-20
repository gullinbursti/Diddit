//
//  DIPricePakViewCell.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.07.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIPricePak.h"
#import "EGOImageView.h"

@interface DIPricePakViewCell : UITableViewCell {
	
	DIPricePak *_pricePak;
	
	EGOImageView *_imgView;
	UILabel *_pointsLabel;
	UILabel *_priceLabel;
	
	UIImageView *_circleOffImgView;
	UIImageView *_circleOnImgView;
	UIImageView *_checkImgView;
	
	UIImageView *_dividerImgView;
}

+(NSString *)cellReuseIdentifier;
-(void)toggleSelect:(BOOL)isSelected;

@property(nonatomic, retain) DIPricePak *pricePak;

@end
