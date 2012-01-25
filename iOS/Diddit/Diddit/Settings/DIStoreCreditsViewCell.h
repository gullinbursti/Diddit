//
//  DIStoreCreditsViewCell.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.13.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIApp.h"
#import "EGOImageView.h"

@interface DIStoreCreditsViewCell : UITableViewCell {
	
	UIView *_holderView;
	DIApp *_app;
	
	EGOImageView *_icoImgView;
	UILabel *_titleLabel;
	UILabel *_infoLabel;
	
	BOOL _shouldDrawSeparator;
}

+(NSString *)cellReuseIdentifier;

@property(nonatomic) BOOL shouldDrawSeparator;
@property(nonatomic, retain) DIApp *app;

@end
