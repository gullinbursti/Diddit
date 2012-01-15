//
//  DIFeaturedItemButton.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.11.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIApp.h"
#import "EGOImageView.h"

@interface DIFeaturedItemButton : UIButton {
	DIApp *_app;
	EGOImageView *_imgView;
	int _ind;
}

-(id)initWithApp:(DIApp *)app AtIndex:(int)ind;
@end
