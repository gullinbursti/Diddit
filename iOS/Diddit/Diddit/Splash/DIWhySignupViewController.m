//
//  DIWhySignupViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.21.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIWhySignupViewController.h"
#import "DIAppDelegate.h"

@implementation DIWhySignupViewController

#pragma mark - View lifecycle
-(void)loadView {
	[super loadView];
	
	NSString *txtString = [NSString stringWithString:@"Claritas est etiam processus dynamicus qui sequitur mutationem. Decima et quinta decima typi qui.\n\nDecima et quinta decima eodem modo typi qui nunc nobis videntur parum clari fiant sollemnes in. Consectetuer adipiscing elit. Saepius claritas est etiam processus dynamicus qui sequitur mutationem consuetudium lectorum mirum est."];
	CGSize textSize = [txtString sizeWithFont:[[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11] constrainedToSize:CGSizeMake(300.0, CGFLOAT_MAX) lineBreakMode:UILineBreakModeClip];
	
	UILabel *mainTxtLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 60, 300, textSize.height)] autorelease];
	mainTxtLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11];
	mainTxtLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
	mainTxtLabel.backgroundColor = [UIColor clearColor];
	mainTxtLabel.text = txtString;
	mainTxtLabel.numberOfLines = 0;
	[self.view addSubview:mainTxtLabel];
	
	UIButton *linkBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	linkBtn.frame = CGRectMake(87, textSize.height + 85, 146, 32);
	linkBtn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
	[linkBtn setBackgroundImage:[[UIImage imageNamed:@"genericButton_nonActive.png"] stretchableImageWithLeftCapWidth:17 topCapHeight:0] forState:UIControlStateNormal];
	[linkBtn setBackgroundImage:[[UIImage imageNamed:@"genericButton_Active.png"] stretchableImageWithLeftCapWidth:17 topCapHeight:0] forState:UIControlStateHighlighted];
	[linkBtn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.0] forState:UIControlStateNormal];
	[linkBtn setTitle:@"Visit Get Satisfaction" forState:UIControlStateNormal];
	[linkBtn addTarget:self action:@selector(_goLink) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:linkBtn]; 
	 
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
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.getdiddit.com/"]];
}
@end
