//
//  DIRewardItemViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 02.06.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIRewardItemViewController.h"
#import "DIAppDelegate.h"
#import "DIRewardCommentView.h"
#import "EGOImageView.h"

@implementation DIRewardItemViewController

@synthesize chore = _chore;

#pragma mark - View lifecycle
-(id)initWithChore:(DIChore *)chore {
	if ((self = [super init])) {
		_chore = chore;
		_commentOffset = 0;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_addedComment:) name:@"ADDED_CHORE_COMMENT" object:nil];
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	CGRect frame;
	
	_avatarImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatarBG.png"]] autorelease];
	frame = _avatarImgView.frame;
	frame.origin.x = 20;
	frame.origin.y = 25;
	_avatarImgView.frame = frame;
	[self.view addSubview:_avatarImgView];
	
	UIImageView *bubbleBGImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rewardBG_Top.png"]] autorelease];
	frame = bubbleBGImgView.frame;
	frame.origin.x = 65;
	frame.origin.y = 20;
	bubbleBGImgView.frame = frame;
	[self.view addSubview:bubbleBGImgView];
	
	UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(95, 45, 280.0, 32)] autorelease];
	titleLabel.font = [[DIAppDelegate diAdelleFontRegular] fontWithSize:26.0];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textColor = [UIColor colorWithRed:0.251 green:0.675 blue:0.376 alpha:1.0];
	titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
	titleLabel.shadowColor = [UIColor whiteColor];
	titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	titleLabel.text = _chore.title;
	[self.view addSubview:titleLabel];
	
	UILabel *commentsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(95, 80, 200.0, 16)] autorelease];
	commentsLabel.font = [[DIAppDelegate diAdelleFontSemibold] fontWithSize:14.0];
	commentsLabel.backgroundColor = [UIColor clearColor];
	commentsLabel.textColor = [UIColor colorWithWhite:0.398 alpha:1.0];
	commentsLabel.text = _chore.info;
	[self.view addSubview:commentsLabel];
	
	EGOImageView *pricePakImgView = [[EGOImageView alloc] initWithFrame:CGRectMake(90, 100, 189, 119)];
	pricePakImgView.imageURL = [NSURL URLWithString:_chore.imgPath];
		
	_pricePakButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_pricePakButton.frame = CGRectMake(90, 100, 189.0, 119.0);
	[_pricePakButton setBackgroundImage:[pricePakImgView.image stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
	[_pricePakButton setBackgroundImage:[pricePakImgView.image stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateSelected];
	[self.view addSubview:_pricePakButton];
		
	_bubbleFooterImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rewardBG_Bottom.png"]] autorelease];
	frame = _bubbleFooterImgView.frame;
	frame.origin.x = 67;
	frame.origin.y = 20 + bubbleBGImgView.bounds.size.height;
	_bubbleFooterImgView.frame = frame;
	[self.view addSubview:_bubbleFooterImgView];
	
	if (_chore.status_id != 2) {
		_pricePakButton.alpha = 0.25;
	
	} else {
		[_pricePakButton addTarget:self action:@selector(_goFinishChore) forControlEvents:UIControlEventTouchUpInside];
	}
	
	_enterMessageButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_enterMessageButton.frame = CGRectMake(_bubbleFooterImgView.frame.origin.x + 15, _bubbleFooterImgView.frame.origin.y + 7, 209.0, 29.0);
	[_enterMessageButton setBackgroundImage:[[UIImage imageNamed:@"inputBG.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
	[_enterMessageButton setBackgroundImage:[[UIImage imageNamed:@"inputBG.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateSelected];
	_enterMessageButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
	[_enterMessageButton setTitleColor:[DIAppDelegate diColor333333] forState:UIControlStateNormal];
	[_enterMessageButton setTitleColor:[DIAppDelegate diColor333333] forState:UIControlStateSelected];
	_enterMessageButton.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 35);
	[_enterMessageButton setTitle:@"Enter comments here" forState:UIControlStateNormal];
	[_enterMessageButton addTarget:self action:@selector(_goComments) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_enterMessageButton];
	
		
	_dividerImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_separator.png"]] autorelease];
	frame = _dividerImgView.frame;
	frame.origin.x = 30;
	frame.origin.y = 295;
	_dividerImgView.frame = frame;
	[self.view addSubview:_dividerImgView];
}

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidUnload {
    [super viewDidUnload];
}

-(void)dealloc {
	[super dealloc];
}

#pragma mark - Navigation
-(void)_goComments {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_CHORE_COMMENT" object:_chore];
	_isSelected = YES;
}

-(void)_goFinishChore {
	[UIView animateWithDuration:0.25 animations:^(void) { 
		_pricePakButton.alpha = 0.0;
	
	} completion:^(BOOL finished) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"FINISH_CHORE" object:_chore];
	}];
}

#pragma mark - Notifications
-(void)_addedComment:(NSNotification *)notification {
	//_enterMessageButton.titleLabel.text = [[notification object] string];
	
	if (_isSelected) {
		NSLog(@"ADDED COMMENT:[%@]", [notification object]);
		DIRewardCommentView *commentView = [[[DIRewardCommentView alloc] initWithMessage:[notification object]] autorelease];
		CGRect frame = CGRectMake(96, _bubbleFooterImgView.frame.origin.y + _commentOffset + 55, 170, 16);
		commentView.frame = frame;
		[self.view addSubview:commentView];
				
		_commentOffset += 50;
		
		frame = _dividerImgView.frame;
		frame.origin.y += _commentOffset;
		_dividerImgView.frame = frame;
	}
	_isSelected = NO;
}

@end
