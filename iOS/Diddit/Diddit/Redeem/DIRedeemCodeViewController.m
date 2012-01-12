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
#import "DIFooterBtnView.h"

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
	
	UIView *codeBGView = [[UIView alloc] initWithFrame:CGRectMake(25, 256, 274, 64)];
	[codeBGView setBackgroundColor:[UIColor whiteColor]];
	codeBGView.layer.cornerRadius = 8.0;
	codeBGView.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0] CGColor];
	codeBGView.layer.borderWidth = 1.0;
	[self.view addSubview:codeBGView];
	
	UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 280, 274, 16)];
	codeLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:16];
	codeLabel.textColor = [UIColor blackColor];
	codeLabel.backgroundColor = [UIColor clearColor];
	codeLabel.textAlignment = UITextAlignmentCenter;
	codeLabel.text = _redeemCode;
	[self.view addSubview:codeLabel];
	
	DIFooterBtnView *view = [[DIFooterBtnView alloc] initWithLabel:@"copy code to clipboard"];
	[[view btn] addTarget:self action:@selector(_goCopy) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:view];
	
	UIImageView *overlayImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]];
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
	[super dealloc];
}

#pragma mark - navigation
-(void)_goCopy {
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	[pasteboard setValue:_redeemCode forPasteboardType:@"public.utf8-plain-text"];
}

@end
