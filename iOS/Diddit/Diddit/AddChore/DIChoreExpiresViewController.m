//
//  DIChoreExpiresViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.07.12.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import "DIChoreExpiresViewController.h"
#import "DIAppDelegate.h"
#import "DIChore.h"

@implementation DIChoreExpiresViewController


#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		
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
		
		UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
		backButton.frame = CGRectMake(0, 0, 58.0, 34);
		[backButton setBackgroundImage:[[UIImage imageNamed:@"headerBackButton_nonActive.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
		[backButton setBackgroundImage:[[UIImage imageNamed:@"headerBackButton_Active.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateHighlighted];
		backButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.5];
		backButton.titleLabel.shadowColor = [UIColor blackColor];
		backButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
		backButton.titleEdgeInsets = UIEdgeInsetsMake(1, 4, -1, -4);
		[backButton setTitle:@"Back" forState:UIControlStateNormal];
		[backButton addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
		
		
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
	
		_hours = 0;
		
		_daysArray = [[NSMutableArray alloc] init];
		[_daysArray addObject:@"24 hours"];
		[_daysArray addObject:@"2 days"];
		[_daysArray addObject:@"3 days"];
		[_daysArray addObject:@"4 days"];
		[_daysArray addObject:@"5 days"];
		[_daysArray addObject:@"6 days"];
		[_daysArray addObject:@"7 days"];
	}
	
	return (self);
}

-(id)initWithChore:(DIChore *)chore {
	if ((self = [self init])) {
		_chore = chore;
	}
	
	return (self);
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	[self.view setBackgroundColor:[UIColor colorWithRed:0.988235294117647 green:0.988235294117647 blue:0.713725490196078 alpha:1.0]];
	
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 20)];
	titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:16];
	titleLabel.textColor = [UIColor colorWithWhite:0.67 alpha:1.0];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.text = @"when should the chore be done?";
	titleLabel.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:titleLabel];
	
	CGRect frame;
	
	UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
	frame = bgImgView.frame;
	frame.origin.y = 48;
	bgImgView.frame = frame;
	[self.view addSubview:bgImgView];
	
	UIImageView *dividerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]];
	frame = dividerImgView.frame;
	frame.origin.y = 48;
	dividerImgView.frame = frame;
	[self.view addSubview:dividerImgView];
	
	
	UILabel *inLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 80, 70, 20)];
	inLabel.font = [[DIAppDelegate diAdelleFontBoldItalic] fontWithSize:16];
	inLabel.textColor = [UIColor colorWithWhite:0.75 alpha:1.0];
	inLabel.backgroundColor = [UIColor clearColor];
	inLabel.text = @"in…";
	[self.view addSubview:inLabel];
	
	
	_daysLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 80)];
	_daysLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:70];
	_daysLabel.textColor = [UIColor blackColor];
	_daysLabel.backgroundColor = [UIColor clearColor];
	_daysLabel.textAlignment = UITextAlignmentCenter;
	_daysLabel.text = @"";
	[self.view addSubview:_daysLabel];
	
	_pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 235, 320, 216)];
	_pickerView.dataSource = self;
	_pickerView.delegate = self;
	[self.view addSubview:_pickerView];
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
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)_goNext {
	
	NSDate *now = [NSDate date];
	NSDateComponents *dc = [[NSDateComponents alloc] init];
	[dc setHour:_hours];
	
	_chore.expires = [[NSCalendar currentCalendar] dateByAddingComponents:dc toDate:now options:0];
	[dc release];
	
	NSLog(@"EXPIRES: [%@]", _chore.disp_expires);
}

#pragma mark - PickerView Data Source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return (1);
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return ([_daysArray count]);
}



#pragma mark - PickerView Delegates

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return ([_daysArray objectAtIndex:row]);
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	_daysLabel.text = [_daysArray objectAtIndex:row];
	_hours = (int)((row + 1) * 24);
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
