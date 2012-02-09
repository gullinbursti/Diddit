//
//  DIStoreItemButton.h
//  Diddit
//
//  Created by Matthew Holcombe on 02.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EGOImageView.h"
#import "DIApp.h"

@interface DIStoreItemButton : UIButton {
	DIApp *_app;
	EGOImageView *_icoImgView;
	int _ind;
}

-(id)initWithApp:(DIApp *)app AtIndex:(int)ind;

@end
