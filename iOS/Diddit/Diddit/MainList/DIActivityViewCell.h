//
//  DIActivityViewCell.h
//  Diddit
//
//  Created by Matthew Holcombe on 02.04.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIChore.h"

@interface DIActivityViewCell : UITableViewCell {
	DIChore *_chore;
	
	UIView *_overlayView;
	
	UIView *_thumbHolderView;
	UILabel *_titleLabel;
	UILabel *_typeLabel;
	UILabel *_dateLabel;
	UIButton *_approveButton;
	UILabel *_ptsLabel;
}

+(NSString *)cellReuseIdentifier;
-(void)toggleSelected;

@property(nonatomic, retain) DIChore *chore;

@end
