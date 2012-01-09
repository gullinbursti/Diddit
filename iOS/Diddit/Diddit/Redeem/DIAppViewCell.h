//
//  DIAppViewCell.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIApp.h"
#import "EGOImageView.h"

@interface DIAppViewCell : UITableViewCell {
	
	EGOImageView *_imgView;
	UILabel *_titleLabel;
	UILabel *_infoLabel;
	UILabel *_pointsLabel;
	
	DIApp *_app;
}

+(NSString *)cellReuseIdentifier;

@property(nonatomic, retain) DIApp *app;
@end
