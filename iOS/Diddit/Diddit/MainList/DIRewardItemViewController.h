//
//  DIRewardItemViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 02.06.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIChore.h"
#import "EGOImageView.h"

@interface DIRewardItemViewController : UIViewController {
	DIChore *_chore;
	EGOImageView *_pricePakImgView;
	
	UIImageView *_avatarImgView;
	UIButton *_enterMessageButton;
	
	BOOL _isSelected;
	
	UIImageView *_bubbleFooterImgView;
	
}

-(id)initWithChore:(DIChore *)chore;

@end
