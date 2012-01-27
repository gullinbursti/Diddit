//
//  DIChoreExpiresViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.07.12.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import "DIChoreExpiresViewController.h"
#import "DIAppDelegate.h"
#import "DINavRightBtnView.h"
#import "DIChore.h"
#import "DIAddPhotoViewController.h"

@implementation DIChoreExpiresViewController


#pragma mark - View lifecycle
-(id)init {
	if ((self = [super initWithTitle:@"add chore" header:@"when should the chore be done?" backBtn:@"Back"])) {
		
		DINavRightBtnView *nextBtnView = [[[DINavRightBtnView alloc] initWithLabel:@"Next"] autorelease];
		[[nextBtnView btn] addTarget:self action:@selector(_goNext) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:nextBtnView] autorelease];
	
		_hours = 0;
		
		_daysArray = [[NSMutableArray alloc] init];
		[_daysArray addObject:@"immediately"];
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
	
	UILabel *inLabel = [[[UILabel alloc] initWithFrame:CGRectMake(30, 75, 70, 20)] autorelease];
	inLabel.font = [[DIAppDelegate diAdelleFontBoldItalic] fontWithSize:16];
	inLabel.textColor = [UIColor blackColor];
	inLabel.backgroundColor = [UIColor clearColor];
	inLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	inLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	inLabel.text = @"in…";
	[self.view addSubview:inLabel];
	
	
	_daysLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 87, 320, 80)];
	_daysLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:64];
	_daysLabel.textColor = [UIColor blackColor];
	_daysLabel.backgroundColor = [UIColor clearColor];
	_daysLabel.textAlignment = UITextAlignmentCenter;
	_daysLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	_daysLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	_daysLabel.text = @"";
	[self.view addSubview:_daysLabel];
	
	_pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 201, 320, 216)];
	_pickerView.dataSource = self;
	_pickerView.delegate = self;
	_pickerView.showsSelectionIndicator = YES;
	[_pickerView selectRow:0 inComponent:0 animated:YES];
	[self.view addSubview:_pickerView];
	
	_daysLabel.text = [_daysArray objectAtIndex:[_pickerView selectedRowInComponent:0]];
	
	UIImageView *overlayImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]] autorelease];
	CGRect frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}

-(void)dealloc {
	[_chore release];
	[_daysLabel release];
	[_pickerView release];
	[_daysArray release];
	
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
	
	[self.navigationController pushViewController:[[[DIAddPhotoViewController alloc] initWithChore:_chore] autorelease] animated:YES];
	
	
	//NSLog(@"EXPIRES: [%@]", _chore.disp_expires);
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
	_hours = (int)(row * 24);
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
