//
//  DIAddCustomChoreViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.15.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import "DIAddCustomChoreViewController.h"
#import "DIAppDelegate.h"
#import "DIChore.h"

@implementation DIAddCustomChoreViewController


#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		
		UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 195, 39)] autorelease];
		//headerLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:18.0];
		headerLabel.textAlignment = UITextAlignmentCenter;
		headerLabel.backgroundColor = [UIColor clearColor];
		headerLabel.textColor = [UIColor whiteColor];
		headerLabel.shadowColor = [UIColor colorWithWhite:0.25 alpha:1.0];
		headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		headerLabel.text = @"Add Custom Chore";
		[headerLabel sizeToFit];
		self.navigationItem.titleView = headerLabel;
		
		UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
		backButton.frame = CGRectMake(0, 0, 60.0, 30);
		[backButton setBackgroundImage:[[UIImage imageNamed:@"non_Active_headerButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:7] forState:UIControlStateNormal];
		[backButton setBackgroundImage:[[UIImage imageNamed:@"active_headerButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:7] forState:UIControlStateHighlighted];
		backButton.titleEdgeInsets = UIEdgeInsetsMake(-1.0, 1.0, 1.0, -1.0);
		//backButton.titleLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:12.0];
		[backButton setTitle:@"Back" forState:UIControlStateNormal];
		[backButton addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
	}
	
	return (self);
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	[self.view setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:1.0]];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 70, 20)];
	//titleLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12];
	titleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.text = @"Title:";
	[self.view addSubview:titleLabel];
	
	_titleTxtField = [[[UITextField alloc] initWithFrame:CGRectMake(100, 20, 200, 64)] autorelease];
	[_titleTxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_titleTxtField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
	[_titleTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_titleTxtField setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
	_titleTxtField.keyboardType = UIKeyboardTypeDefault;
	[_titleTxtField becomeFirstResponder];
	[self.view addSubview:_titleTxtField];
	
	UILabel *icoLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 50, 70, 20)];
	//icoLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12];
	icoLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
	icoLabel.backgroundColor = [UIColor clearColor];
	icoLabel.text = @"Icon:";
	[self.view addSubview:icoLabel];
	
	_icoTxtField = [[[UITextField alloc] initWithFrame:CGRectMake(100, 50, 200, 64)] autorelease];
	[_icoTxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_icoTxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_icoTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_icoTxtField setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
	_icoTxtField.keyboardType = UIKeyboardTypeURL;
	[self.view addSubview:_icoTxtField];
	
	UILabel *imgLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 80, 70, 20)];
	//imgLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12];
	imgLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
	imgLabel.backgroundColor = [UIColor clearColor];
	imgLabel.text = @"Image:";
	[self.view addSubview:imgLabel];
	
	_imgTxtField = [[[UITextField alloc] initWithFrame:CGRectMake(100, 80, 200, 64)] autorelease];
	[_imgTxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_imgTxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_imgTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_imgTxtField setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
	_imgTxtField.keyboardType = UIKeyboardTypeURL;
	[self.view addSubview:_imgTxtField];
	
	
	UIButton *submitButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	submitButton.frame = CGRectMake(32, 128, 256, 32);
	//submitButton.titleLabel.font = [[OJAppDelegate ojApplicationFontBold] fontWithSize:12.0];
	submitButton.titleEdgeInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
	[submitButton setBackgroundImage:[[UIImage imageNamed:@"largeBlueButton.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
	[submitButton setBackgroundImage:[[UIImage imageNamed:@"largeBlueButtonActive.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:7] forState:UIControlStateHighlighted];
	[submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[submitButton setTitle:@"Submit" forState:UIControlStateNormal];
	[submitButton addTarget:self action:@selector(_goSubmit) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:submitButton];
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}

-(void)dealloc {
	[super dealloc];
}

#pragma mark - Navigation
-(void)_goBack {
	[self dismissViewControllerAnimated:YES completion:nil];	
}

-(void)_goSubmit {
	
	if ([_titleTxtField.text length] > 0) {
		ASIFormDataRequest *dataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Chores.php"]] retain];
		[dataRequest setPostValue:[NSString stringWithFormat:@"%d", 7] forKey:@"action"];
		[dataRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
		[dataRequest setPostValue:_titleTxtField.text forKey:@"choreTitle"];
		[dataRequest setPostValue:@"" forKey:@"choreInfo"];
		[dataRequest setPostValue:_icoTxtField.text forKey:@"icoURL"];
		[dataRequest setPostValue:_imgTxtField.text forKey:@"imgURL"];
		[dataRequest setDelegate:self];
		[dataRequest startAsynchronous];
	}
}



#pragma mark - ASI Delegates
- (void)requestFinished:(ASIHTTPRequest *)request { 	
	NSLog(@"[_asiFormRequest responseString]=\n%@\n\n", [request responseString]);

	@autoreleasepool {
		NSError *error = nil;
		NSDictionary *parsedChore = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
		
		if (error != nil)
			NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
		
		else {
			DIChore *chore = [DIChore choreWithDictionary:parsedChore];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_CUSTOM_CHORE" object:chore];
		}
	}
	
	[self _goBack];
} 

@end
