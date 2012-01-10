//
//  DINavRightBtnView.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.09.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DINavRightBtnView : UIView {
	UIButton *_btn;
}

-(id)initWithLabel:(NSString *)lbl;
@property (nonatomic, retain) UIButton *btn;

@end
