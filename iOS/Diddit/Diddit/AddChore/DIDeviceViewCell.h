//
//  DIDeviceViewCell.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.28.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIDevice.h"

@interface DIDeviceViewCell : UITableViewCell {
	UILabel *_titleLabel;
	UILabel *_lockedLabel;
	
	DIDevice *_device;
	BOOL _isSelected;
	
	UIImageView *_overlayImgView;
}

@property(nonatomic, retain) DIDevice *device;
@property(nonatomic) BOOL isSelected;

+(NSString *)cellReuseIdentifier;

-(void)toggleSelected;


@end
