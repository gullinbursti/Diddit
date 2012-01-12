//
//  DIFooterBtnView.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.10.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIFooterBtnView : UIView {
	UIButton *_btn;
}

-(id)initWithLabel:(NSString *)lbl;
@property (nonatomic, retain) UIButton *btn;

@end
