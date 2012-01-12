//
//  DILoadOverlayView.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.11.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DILoadOverlayView : UIView {
	UIView *_holderView;
}

-(void)toggle:(BOOL)isOn;

@end
