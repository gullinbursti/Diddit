//
//  DIChoreDetailsViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.14.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import "DIChoreDetailsViewController.h"
#import "DIPinCodeViewController.h"

@implementation DIChoreDetailsViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_finishChore:) name:@"FINISH_CHORE" object:nil];
		
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
	
	_completeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_completeButton.frame = CGRectMake(32, 375, 256, 32);
	//_completeButton.titleLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:12.0];
	_completeButton.titleEdgeInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
	[_completeButton setBackgroundImage:[[UIImage imageNamed:@"largeBlueButton.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[_completeButton setBackgroundImage:[[UIImage imageNamed:@"largeBlueButtonActive.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:7] forState:UIControlStateHighlighted];
	[_completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_completeButton setTitle:@"DiddIt!" forState:UIControlStateNormal];
	[_completeButton addTarget:self action:@selector(_goComplete) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_completeButton];
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
- (void)_goBack {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)_goComplete {	
	
	DIPinCodeViewController *pinCodeViewController = [[[DIPinCodeViewController alloc] initWithPin:@"0000" chore:_chore fromAdd:NO] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:pinCodeViewController] autorelease];
	//[self.navigationController presentViewController:navigationController animated:YES completion:nil];
	[self.navigationController presentModalViewController:navigationController animated:YES];
}


#pragma mark - notication handlers
-(void)_finishChore:(NSNotification *)notification {
	[self.navigationController popViewControllerAnimated:YES];
}

@end
