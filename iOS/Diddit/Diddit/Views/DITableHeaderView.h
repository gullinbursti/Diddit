//
//  DITableHeaderView.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.28.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DITableHeaderView : UIView {
	UILabel *_label;
}

-(id)initWithTitle:(NSString *)title;

@end
