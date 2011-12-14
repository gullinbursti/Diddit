//
//  DIChoreTypeViewCell.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.13.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EGOImageView.h"
#import "DIChoreType.h"

@interface DIChoreTypeViewCell : UITableViewCell {
	EGOImageView *_imgView;
	UILabel *_titleLabel;
	UILabel *_infoLabel;
	
	DIChoreType *_choreType;
	
	BOOL _shouldDrawSeparator;
}

+(NSString *)cellReuseIdentifier;

@property(nonatomic) BOOL shouldDrawSeparator;
@property(nonatomic, retain) DIChoreType *choreType;

@end
