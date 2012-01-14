//
//  DIChoreStatsView.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.10.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIChoreStatsView : UIView {
	UIButton *_ptsBtn;
	UIButton *_totBtn;
}

@property (nonatomic, retain) UIButton *ptsBtn;
@property (nonatomic, retain) UIButton *totBtn;

@end
