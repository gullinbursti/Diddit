//
//  DIAchievementViewCell.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.15.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIAchievement.h"
#import "EGOImageView.h"

@interface DIAchievementViewCell : UITableViewCell {
	EGOImageView *_appIcoView;
	UILabel *_titleLabel;
	UILabel *_infoLabel;
	
	DIAchievement *_achievement;
	BOOL _shouldDrawSeparator;
}

+(NSString *)cellReuseIdentifier;

@property(nonatomic) BOOL shouldDrawSeparator;
@property(nonatomic, retain) DIAchievement *achievement;

@end
