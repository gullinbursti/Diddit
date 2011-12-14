//
//  DICreditsViewCell.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.13.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIChore.h"
#import "EGOImageView.h"

@interface DICreditsViewCell : UITableViewCell {
	EGOImageView *_appIcoView;
	UILabel *_titleLabel;
	UILabel *_infoLabel;
	UILabel *_pointsLabel;
	
	DIChore *_chore;
	
	BOOL _shouldDrawSeparator;
}

+(NSString *)cellReuseIdentifier;

@property(nonatomic) BOOL shouldDrawSeparator;
@property(nonatomic, retain) DIChore *chore;

@end
