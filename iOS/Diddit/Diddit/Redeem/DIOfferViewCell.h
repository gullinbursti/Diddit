//
//  DIOfferViewCell.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIOffer.h"
#import "EGOImageView.h"

@interface DIOfferViewCell : UITableViewCell {
	
	EGOImageView *_imgView;
	UILabel *_titleLabel;
	UILabel *_pointsLabel;
	
	DIOffer *_offer;
}

+(NSString *)cellReuseIdentifier;

@property(nonatomic, retain) DIOffer *offer;

@end
