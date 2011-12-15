//
//  DIChorePriceViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.14.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DIChorePriceViewController.h"

@implementation DIChorePriceViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_dismissMe:) name:@"DISMISS_CONFIRM_CHORE" object:nil];
		
		UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 195, 39)] autorelease];
		//headerLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:18.0];
		headerLabel.textAlignment = UITextAlignmentCenter;
		headerLabel.backgroundColor = [UIColor clearColor];
		headerLabel.textColor = [UIColor whiteColor];
		headerLabel.shadowColor = [UIColor colorWithWhite:0.25 alpha:1.0];
		headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		headerLabel.text = @"Purchase Chore";
		[headerLabel sizeToFit];
		self.navigationItem.titleView = headerLabel;
		
		/*
		 UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
		 backButton.frame = CGRectMake(0, 0, 60.0, 30);
		 [backButton setBackgroundImage:[[UIImage imageNamed:@"non_Active_headerButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:7] forState:UIControlStateNormal];
		 [backButton setBackgroundImage:[[UIImage imageNamed:@"active_headerButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:7] forState:UIControlStateHighlighted];
		 backButton.titleEdgeInsets = UIEdgeInsetsMake(-1.0, 1.0, 1.0, -1.0);
		 //backButton.titleLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:12.0];
		 [backButton setTitle:@"Back" forState:UIControlStateNormal];
		 [backButton addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		 self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
		 */
	}
	
	return (self);
}

-(id)initWithChore:(DIChore *)chore {
	if ((self = [self init])) {
		_chore = chore;	
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	[self.view setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
	
	NSString *imgName = [[NSString alloc] init];
	
	switch (_chore.type_id) {
		case 1:
			imgName = @"washcar.jpg";
			break;
			
		case 2:
			imgName = @"washdishes.jpg";
			break;
			
		case 3:
			imgName = @"cleanroom.jpg";
			break;
			
		case 4:
			imgName = @"mowlawn.jpg";
			break;
			
		case 5:
			imgName = @"taketrash.jpg";
			break;
			
		case 6:
			imgName = @"walkdog.jpg";
			break;
			
		default:
			imgName = @"mowlawn.jpg";
	}
	
	
	UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
	CGRect frame = bgImgView.frame;
	frame.origin.x = 32;
	frame.origin.y = 64;
	bgImgView.frame = frame;
	[self.view addSubview:bgImgView];
	
	_label = [[UILabel alloc] initWithFrame:CGRectMake(128, 300, 64, 16)];
	//_label.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:9.5];
	_label.backgroundColor = [UIColor clearColor];
	_label.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
	_label.lineBreakMode = UILineBreakModeTailTruncation;
	_label.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:_label];
	
	_slider = [[UISlider alloc] initWithFrame:CGRectMake(32, 320, 256, 32)];
	[_slider addTarget:self action:@selector(_goSliderChange:) forControlEvents:UIControlEventValueChanged];
	_slider.minimumValue = 1.0;
	_slider.maximumValue = 10.0;
	[self.view addSubview:_slider];
	
	_purchaseButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_purchaseButton.frame = CGRectMake(32, 375, 256, 32);
	//_purchaseButton.titleLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:12.0];
	_purchaseButton.titleEdgeInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
	[_purchaseButton setBackgroundImage:[[UIImage imageNamed:@"largeBlueButton.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[_purchaseButton setBackgroundImage:[[UIImage imageNamed:@"largeBlueButtonActive.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:7] forState:UIControlStateHighlighted];
	[_purchaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_purchaseButton setTitle:@"Purchase" forState:UIControlStateNormal];
	[_purchaseButton addTarget:self action:@selector(_goPurchase) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_purchaseButton];
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
- (void)_goPurchase {
	
	int price = (int)_slider.value;
	
	UIAlertView *purchaseAlert = [[UIAlertView alloc] initWithTitle:@"Coming Soon"
																		 message:[NSString stringWithFormat:@"In-App purchase for $%d", price]
																		delegate:self
															cancelButtonTitle:@"OK"
															otherButtonTitles:@"Cancel", nil];
	[purchaseAlert show];
	[purchaseAlert release];
}


#pragma mark - Event Handlers
-(void)_goSliderChange:(id)sender {
	_label.text = [NSString stringWithFormat:@"$%d", (int)_slider.value];
}


#pragma mark - AlertView Delegates
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSLog(@"clickedButtonAtIndex: [%d]", buttonIndex);
	
	if (buttonIndex == 0) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_CHORE" object:_chore];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"REMOVE_AVAIL_CHORE" object:_chore];
		
		[self.navigationController dismissViewControllerAnimated:YES completion:^(void) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"DISMISS_ADD_CHORE" object:_chore];
		}];
	}
}

@end