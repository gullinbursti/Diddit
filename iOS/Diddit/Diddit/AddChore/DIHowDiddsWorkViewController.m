//
//  DIHowDiddsWorkViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.07.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIHowDiddsWorkViewController.h"

#import "DIAppDelegate.h"

@implementation DIHowDiddsWorkViewController

#pragma mark - View lifecycle
-(void)loadView {
	[super loadView];
	
	NSString *txtString = [NSString stringWithString:@"Claritas est etiam processus dynamicus qui sequitur mutationem. Decima et quinta decima typi qui.\n\nDecima et quinta decima eodem modo typi qui nunc nobis videntur parum clari fiant sollemnes in. Consectetuer adipiscing elit. Saepius claritas est etiam processus dynamicus qui sequitur mutationem consuetudium lectorum mirum est.\n\nLegentis in qui facit eorum claritatem Investigationes demonstraverunt lectores legere. Blandit praesent luptatum zzril delenit augue duis dolore te feugait. Non habent claritatem insitam est usus me lius quod ii legunt saepius claritas. Dolore eu feugiat nulla facilisis at: vero eros et accumsan et iusto odio dignissim."];
	CGSize textSize = [txtString sizeWithFont:[[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11] constrainedToSize:CGSizeMake(300.0, CGFLOAT_MAX) lineBreakMode:UILineBreakModeClip];
	
	UILabel *mainTxtLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 60, 300, textSize.height)] autorelease];
	mainTxtLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11];
	mainTxtLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
	mainTxtLabel.backgroundColor = [UIColor clearColor];
	mainTxtLabel.text = txtString;
	mainTxtLabel.numberOfLines = 0;
	[self.view addSubview:mainTxtLabel];
		
	/*
	UIButton *facebookBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	facebookBtn.frame = CGRectMake(54, 375, 98, 28);
	facebookBtn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
	[facebookBtn setBackgroundImage:[[UIImage imageNamed:@"genericButton_nonActive.png"] stretchableImageWithLeftCapWidth:17 topCapHeight:0] forState:UIControlStateNormal];
	[facebookBtn setBackgroundImage:[[UIImage imageNamed:@"genericButton_Active.png"] stretchableImageWithLeftCapWidth:17 topCapHeight:0] forState:UIControlStateHighlighted];
	[facebookBtn setTitleColor:[UIColor colorWithWhite:0.5 alpha:1.0] forState:UIControlStateNormal];
	[facebookBtn setTitle:@"Facebook" forState:UIControlStateNormal];
	[facebookBtn addTarget:self action:@selector(_goFacebook) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:facebookBtn]; 
	
	UIButton *twitterBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	twitterBtn.frame = CGRectMake(168, 375, 98, 28);
	twitterBtn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
	[twitterBtn setBackgroundImage:[[UIImage imageNamed:@"genericButton_nonActive.png"] stretchableImageWithLeftCapWidth:17 topCapHeight:0] forState:UIControlStateNormal];
	[twitterBtn setBackgroundImage:[[UIImage imageNamed:@"genericButton_Active.png"] stretchableImageWithLeftCapWidth:17 topCapHeight:0] forState:UIControlStateHighlighted];
	[twitterBtn setTitleColor:[UIColor colorWithWhite:0.5 alpha:1.0] forState:UIControlStateNormal];
	[twitterBtn setTitle:@"Twitter" forState:UIControlStateNormal];
	[twitterBtn addTarget:self action:@selector(_goTwitter) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:twitterBtn]; 
	*/
	
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
	[super dealloc];
}

#pragma mark - navigation
-(void)_goFacebook {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/diddit"]];
}

-(void)_goTwitter {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/#!/diddit"]];
}

@end
