//
//  DISubDeviceViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.31.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIDevice.h"

@interface DISubDeviceViewController : UIViewController {
	DIDevice *_device;
	
	UIImageView *_deviceImgView;
	UILabel *_deviceNameLabel;
	UILabel *_infoLabel;
	UIButton *_rewardButton;
}

-(id)initWithDevice:(DIDevice *)device;

@end
