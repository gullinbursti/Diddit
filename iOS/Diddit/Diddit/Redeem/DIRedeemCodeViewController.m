//
//  DIRedeemCodeViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.09.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DIRedeemCodeViewController.h"

#import "DIAppDelegate.h"

@implementation DIRedeemCodeViewController

#pragma mark - View lifecycle

-(id)initWithApp:(DIApp *)app {
	_app = app;
	
	if ((self = [self initWithTitle:@"thank you" header:@"iTunes Card redemption code" closeLabel:@"Done"])) {
		
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	_redeemCode = [[DIAppDelegate md5:[NSString stringWithFormat:@"%d", arc4random()]] uppercaseString];
	_redeemCode = [_redeemCode substringToIndex:[_redeemCode length] - 12];
	
	UIView *codeBGView = [[[UIView alloc] initWithFrame:CGRectMake(25, 256, 274, 64)] autorelease];
	[codeBGView setBackgroundColor:[UIColor whiteColor]];
	codeBGView.layer.cornerRadius = 8.0;
	codeBGView.layer.borderColor = [[UIColor colorWithWhite:0.67 alpha:1.0] CGColor];
	codeBGView.layer.borderWidth = 1.0;
	[self.view addSubview:codeBGView];
	
	UILabel *codeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(25, 280, 274, 16)] autorelease];
	codeLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:16];
	codeLabel.textColor = [UIColor blackColor];
	codeLabel.backgroundColor = [UIColor clearColor];
	codeLabel.textAlignment = UITextAlignmentCenter;
	codeLabel.text = _redeemCode;
	[self.view addSubview:codeLabel];
	
	UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 348, 320, 72)] autorelease];
	footerView.backgroundColor = [UIColor colorWithRed:0.2706 green:0.7804 blue:0.4549 alpha:1.0];
	[self.view addSubview:footerView];
	
	UIButton *copyButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	copyButton.frame = CGRectMake(0, 352, 320, 59);
	copyButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
	copyButton.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
	[copyButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[copyButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[copyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[copyButton setTitle:@"copy code to clipboard" forState:UIControlStateNormal];
	[copyButton addTarget:self action:@selector(_goCopy) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:copyButton];
	
	UIImageView *overlayImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]] autorelease];
	CGRect frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];
}

-(void)viewDidLoad {
	[super viewDidLoad];
}

-(void)viewDidUnload {
	[super viewDidUnload];
}

-(void)dealloc {
	//[_app release];
	//[_redeemCode release];
	
	[super dealloc];
}

#pragma mark - navigation
-(void)_goCopy {
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	[pasteboard setValue:_redeemCode forPasteboardType:@"public.utf8-plain-text"];
}

@end
