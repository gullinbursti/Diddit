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
	EGOImageView *_icoView;
	UILabel *_titleLabel;
	UILabel *_infoLabel;
	UILabel *_pointsLabel;
	
	DIApp *_app;
	
	BOOL _shouldDrawSeparator;
}

+(NSString *)cellReuseIdentifier;

@property(nonatomic) BOOL shouldDrawSeparator;
@property(nonatomic, retain) DIApp *app;

@end
