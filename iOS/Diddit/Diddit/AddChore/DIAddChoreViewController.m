//
//  DIAddChoreViewController.m
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DIAddChoreViewController.h"

#import "DIAppDelegate.h"
#import "DIMyChoresViewCell.h"
#import "DIChoreExpiresViewController.h"
#import "DIConfirmChoreViewController.h"

#import "DIChore.h"

@implementation DIAddChoreViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_dismissMe:) name:@"DISMISS_ADD_CHORE" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_removeAvailChore:) name:@"REMOVE_AVAIL_CHORE" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_addCustomChore:) name:@"ADD_CUSTOM_CHORE" object:nil];
		
		
		UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 195, 40)];
		
		UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(-10, 3, 195, 40)] autorelease];
		headerLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
		headerLabel.textAlignment = UITextAlignmentCenter;
		headerLabel.backgroundColor = [UIColor clearColor];
		headerLabel.textColor = [UIColor colorWithRed:0.184313725490196 green:0.537254901960784 blue:0.298039215686275 alpha:1.0];
		headerLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
		headerLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		headerLabel.text = @"add chore";
		
		[headerView addSubview:headerLabel];
		self.navigationItem.titleView = headerView;
		
		UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
		cancelButton.frame = CGRectMake(0, 0, 58.0, 34);
		[cancelButton setBackgroundImage:[[UIImage imageNamed:@"headerButton_nonActive.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
		[cancelButton setBackgroundImage:[[UIImage imageNamed:@"headerButton_Active.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateHighlighted];
		cancelButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.5];
		cancelButton.titleLabel.shadowColor = [UIColor blackColor];
		cancelButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		[cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
		[cancelButton addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:cancelButton] autorelease];
		
		
		UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
		nextButton.frame = CGRectMake(0, 0, 58.0, 34);
		[nextButton setBackgroundImage:[[UIImage imageNamed:@"headerButton_nonActive.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
		[nextButton setBackgroundImage:[[UIImage imageNamed:@"headerButton_Active.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateHighlighted];
		nextButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
		nextButton.titleLabel.shadowColor = [UIColor blackColor];
		nextButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		[nextButton setTitle:@"Next" forState:UIControlStateNormal];
		[nextButton addTarget:self action:@selector(_goNext) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:nextButton] autorelease];
	}
	
	return (self);
}



- (void)loadView {
	[super loadView];
	
	[self.view setBackgroundColor:[UIColor blackColor]];
	
	UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
	[self.view addSubview:bgImgView];
	
	
	UIImageView *dividerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]];
	CGRect frame = dividerImgView.frame;
	frame.origin.y = 68;
	dividerImgView.frame = frame;
	[self.view addSubview:dividerImgView];

	_titleTxtField = [[[UITextField alloc] initWithFrame:CGRectMake(10, 25, 200, 64)] autorelease];
	[_titleTxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_titleTxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_titleTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_titleTxtField setBackgroundColor:[UIColor clearColor]];
	_titleTxtField.font = [[DIAppDelegate diAdelleFontSemibold] fontWithSize:16];
	_titleTxtField.keyboardType = UIKeyboardTypeDefault;
	_titleTxtField.text = @"give your chore a title";
	//_titleTxtField.clearsOnBeginEditing = YES;
	[self.view addSubview:_titleTxtField];
	
	_infoTxtField = [[[UITextField alloc] initWithFrame:CGRectMake(10, 75, 200, 64)] autorelease];
	[_infoTxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_infoTxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_infoTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_infoTxtField setBackgroundColor:[UIColor clearColor]];
	[_infoTxtField setTextColor:[UIColor colorWithWhite:0.67 alpha:1.0]];
	_infoTxtField.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	_infoTxtField.keyboardType = UIKeyboardTypeDefault;
	_infoTxtField.text = @"additional note (optional)";
	_infoTxtField.clearsOnBeginEditing = YES;
	[self.view addSubview:_infoTxtField];
	
	[_titleTxtField becomeFirstResponder];
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

-(void)_goNext {
	
	DIChore *chore = [DIChore choreWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"0", @"id", _titleTxtField.text, @"title", _infoTxtField.text, @"info", @"", @"icoPath", @"", @"imgPath", @"0000-00-00 00:00:00", @"expires", @"0", @"points", @"0", @"cost", nil]];
	[self.navigationController pushViewController:[[[DIChoreExpiresViewController alloc] initWithChore:chore] autorelease] animated:YES];
	
	//NSLog(@"CHORE: [%@]", chore.title);
	
	/*
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
	 */
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
