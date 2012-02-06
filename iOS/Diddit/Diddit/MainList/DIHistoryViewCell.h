//
//  DIHistoryViewCell.h
//  Diddit
//
//  Created by Matthew Holcombe on 02.04.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIChore.h"
#import "EGOImageView.h"

@interface DIHistoryViewCell : UITableViewCell {
	DIChore *_chore;
	
	UIView *_overlayView;
	
	EGOImageView *_avatarImgView;
	UILabel *_ptsLabel;
	UILabel *_typeLabel;
	UILabel *_dateLabel;
}

+(NSString *)cellReuseIdentifier;
-(id)initWithIndex:(int)index;

-(void)toggleSelected;

@property(nonatomic, retain) DIChore *chore;

@end
