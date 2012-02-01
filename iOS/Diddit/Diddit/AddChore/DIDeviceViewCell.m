//
//  DIDeviceViewCell.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.28.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIDeviceViewCell.h"
#import "DIAppDelegate.h"

@implementation DIDeviceViewCell

@synthesize device = _device;
@synthesize isSelected;

+(NSString *)cellReuseIdentifier {
	return (NSStringFromClass(self));
}

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[[self class] cellReuseIdentifier]])) {
		
		UIView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tablerow-l_BG.png"]] autorelease];
		[self addSubview:bgImgView];
		
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 30, 185.0, 22)];
		_titleLabel.font = [[DIAppDelegate diAdelleFontRegular] fontWithSize:18.0];
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
		_titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
		_titleLabel.shadowColor = [UIColor whiteColor];
		_titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
		[self addSubview:_titleLabel];
		
		_lockedLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 58, 185.0, 22)];
		_lockedLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
		_lockedLabel.backgroundColor = [UIColor clearColor];
		_lockedLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
		_lockedLabel.shadowColor = [UIColor whiteColor];
		_lockedLabel.shadowOffset = CGSizeMake(1.0, 1.0);
		[self addSubview:_lockedLabel];
		
		_overlayImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tablerow-l_BG.png"]];
		_overlayImgView.hidden = YES;
		[self addSubview:_overlayImgView];
	}
	
	return (self);
}

#pragma mark - Accessors
- (void)setDevice:(DIDevice *)device {
	_device = device;
	
	_titleLabel.text = _device.device_name;		
	_lockedLabel.text = _device.locked;
	
	self.isSelected = NO;
}

-(void)toggleSelected {
	self.isSelected = !self.isSelected;
	_overlayImgView.hidden = !self.isSelected;
}

@end
