//
//  DIRewardCommentView.m
//  Diddit
//
//  Created by Matthew Holcombe on 02.06.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIRewardCommentView.h"

#import "DIAppDelegate.h"

@implementation DIRewardCommentView

#pragma mark - View Lifecycle
-(id)initWithMessage:(NSString *)msg {
	if ((self = [super init])) {
		CGRect frame;
		
		_bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"commentsBG.png"]];
		frame = _bgImgView.frame;
		frame.origin.x = 0;
		frame.origin.y = 0;
		_bgImgView.frame = frame;
		[self addSubview:_bgImgView];
		
		_avatarImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"defaultCommentImage.png"]];
		frame = _avatarImgView.frame;
		frame.origin.x = 8;
		frame.origin.y = 15;
		_avatarImgView.frame = frame;
		[self addSubview:_avatarImgView];
		
		_messageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(40, 20, 170, 16)] autorelease];
		_messageLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:14.0];
		_messageLabel.backgroundColor = [UIColor clearColor];
		_messageLabel.textColor = [UIColor colorWithWhite:0.398 alpha:1.0];
		_messageLabel.numberOfLines = 0;
		_messageLabel.text = msg;
		[self addSubview:_messageLabel];
	}
	
	return (self);
}

-(void)dealloc {
	[super dealloc];
}
@end
