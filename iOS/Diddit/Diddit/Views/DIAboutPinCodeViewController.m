//
//  DIAboutPinCodeViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.07.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIAboutPinCodeViewController.h"
#import "DIAppDelegate.h"

@implementation DIAboutPinCodeViewController

#pragma mark - View lifecycle
-(void)loadView {
	[super loadView];
	
	UIImageView *overlayImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]] autorelease];
	CGRect frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];
	
	UIImageView *imgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"helpIcon.png"]] autorelease];
	frame = imgView.frame;
	frame.origin.x = 10;
	frame.origin.y = 66;
	imgView.frame = frame;
	[self.view addSubview:imgView];
	
	UILabel *mainTxtLabel = [[[UILabel alloc] initWithFrame:CGRectMake(86, 74, 224, 48)] autorelease];
	mainTxtLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11];
	mainTxtLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
	mainTxtLabel.backgroundColor = [UIColor clearColor];
	mainTxtLabel.text = @"Claritas est etiam processus dynamicus qui sequitur mutationem. Decima et quinta decima typi qui.";
	mainTxtLabel.numberOfLines = 0;
	[self.view addSubview:mainTxtLabel];
	
	UILabel *subTxtLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 140, 300, 190)] autorelease];
	subTxtLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11];
	subTxtLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
	subTxtLabel.backgroundColor = [UIColor clearColor];
	subTxtLabel.text = @"Decima et quinta decima eodem modo typi qui nunc nobis videntur parum clari fiant sollemnes in. Consectetuer adipiscing elit. Saepius claritas est etiam processus dynamicus qui sequitur mutationem consuetudium lectorum mirum est.\n\nLegentis in qui facit eorum claritatem Investigationes demonstraverunt lectores legere. Blandit praesent luptatum zzril delenit augue duis dolore te feugait. Non habent claritatem insitam est usus me lius quod ii legunt saepius claritas. Dolore eu feugiat nulla facilisis at: vero eros et accumsan et iusto odio dignissim.";
	subTxtLabel.numberOfLines = 0;
	[self.view addSubview:subTxtLabel];
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


@end
