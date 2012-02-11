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
#import "DIAppRatingStarsView.h"

@interface DIOfferViewCell : UITableViewCell {
	
	EGOImageView *_imgView;
	DIAppRatingStarsView *_starsView;
	UILabel *_typeLabel;
	UILabel *_titleLabel;
	UILabel *_pointsLabel;
	UIView *_overlayView;
	
	DIOffer *_offer;
}

+(NSString *)cellReuseIdentifier;
-(id)initWithIndex:(int)index;
-(void)toggleSelected;

@property(nonatomic, retain) DIOffer *offer;

@end
