//
//  DIMyChoresViewCell.h
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIChore.h"

@interface DIMyChoresViewCell : UITableViewCell {
	
	UIView *_overlayView;
	
	UIView *_thumbHolderView;
	UILabel *_titleLabel;
	UILabel *_pointsLabel;
	
	DIChore *_chore;
}

+(NSString *)cellReuseIdentifier;
-(void)toggleSelected;

@property(nonatomic, retain) DIChore *chore;

@end
