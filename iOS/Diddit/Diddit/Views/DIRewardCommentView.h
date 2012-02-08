//
//  DIRewardCommentView.h
//  Diddit
//
//  Created by Matthew Holcombe on 02.06.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIRewardCommentView : UIView {
	UIImageView *_bgImgView;
	UIImageView *_avatarImgView;
	UILabel *_messageLabel;
}

-(id)initWithMessage:(NSString *)msg;

@end
