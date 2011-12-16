//
//  DIConfirmChoreViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.13.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DIConfirmChoreViewController.h"
#import "DIChore.h"

#import "DIPinCodeViewController.h"

@implementation DIConfirmChoreViewController


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
		headerLabel.text = @"Assign Chore";
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
	
	switch (_chore.chore_id) {
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
	
	_assignButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_assignButton.frame = CGRectMake(32, 375, 256, 32);
	//_assignButton.titleLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:12.0];
	_assignButton.titleEdgeInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
	[_assignButton setBackgroundImage:[[UIImage imageNamed:@"largeBlueButton.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[_assignButton setBackgroundImage:[[UIImage imageNamed:@"largeBlueButtonActive.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:7] forState:UIControlStateHighlighted];
	[_assignButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_assignButton setTitle:@"Assign It!" forState:UIControlStateNormal];
	[_assignButton addTarget:self action:@selector(_goAssign) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_assignButton];
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

#pragma mark - Notification handlers
-(void)_dismissMe:(NSNotification *)notification {
	NSLog(@"_dismissMe:");
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_CHORE" object:_chore];
	[self.navigationController popViewControllerAnimated:YES];
	
	//[self dismissViewControllerAnimated:YES completion:^(void) {
	//	[[NSNotificationCenter defaultCenter] postNotificationName:@"DISMISS_ADD_CHORE" object:chore];
	//}];
}


#pragma mark - navigation
- (void)_goBack {
	[self dismissViewControllerAnimated:YES completion:nil];	
}

- (void)_goAssign {	
	
	DIPinCodeViewController *pinCodeViewController = [[[DIPinCodeViewController alloc] initWithPin:@"0000" chore:_chore fromAdd:YES] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:pinCodeViewController] autorelease];
	//[self.navigationController presentViewController:navigationController animated:YES completion:nil];
	[self.navigationController presentModalViewController:navigationController animated:YES];
}

@end
