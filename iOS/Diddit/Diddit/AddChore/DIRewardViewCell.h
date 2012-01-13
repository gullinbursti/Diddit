//
//  DIRewardViewCell.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.07.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIReward.h"
#import "EGOImageView.h"

@interface DIRewardViewCell : UITableViewCell {
	
	DIReward *_reward;
	
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

@property(nonatomic, retain) DIReward *reward;

@end
