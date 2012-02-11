//
//  DIRewardItemViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 02.06.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIChore.h"

@interface DIRewardItemViewController : UIViewController {
	DIChore *_chore;
	
	UIImageView *_avatarImgView;
	UIButton *_pricePakButton;
	UIButton *_enterMessageButton;
	
	BOOL _isSelected;
	
	UIImageView *_bubbleFooterImgView;
	int _commentOffset;
	UIImageView *_dividerImgView;
	
}

@property (nonatomic, retain) DIChore *chore;

-(id)initWithChore:(DIChore *)chore;

@end
