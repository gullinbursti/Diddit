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

@interface DIMyChoresViewCell : UITableViewCell <UITextFieldDelegate, UITextViewDelegate> {
	
	UIView *_overlayView;
	
	UIView *_thumbHolderView;
	UILabel *_titleLabel;
//	UILabel *_typeLabel;
	UILabel *_ptsLabel;
	UILabel *_infoLabel;
	
	DIChore *_chore;
	EGOImageView *_pricePakImgView;
	
	UITextField *_messageTxtField;
}

+(NSString *)cellReuseIdentifier;
-(void)toggleSelected;

@property(nonatomic, retain) DIChore *chore;

@end
