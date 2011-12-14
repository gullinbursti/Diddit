//
//  DIMyChoresViewCell.h
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIChore.h"
#import "EGOImageView.h"

@interface DIMyChoresViewCell : UITableViewCell {
	
	EGOImageView *_icoView;
	UILabel *_titleLabel;
	UILabel *_infoLabel;
	
	DIChore *_chore;
	
	BOOL _shouldDrawSeparator;
}

+(NSString *)cellReuseIdentifier;

@property(nonatomic) BOOL shouldDrawSeparator;
@property(nonatomic, retain) DIChore *chore;

@end
