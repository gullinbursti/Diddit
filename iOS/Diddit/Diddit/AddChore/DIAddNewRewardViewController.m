//
//  DIAddNewRewardViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.31.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DIAddNewRewardViewController.h"
#import "DIPricePak.h"

#import "DINavTitleView.h"
#import "DINavLeftBtnView.h"

#import "DIDiddsPakView.h"
#import "DIAppDelegate.h"

@implementation DIAddNewRewardViewController

#pragma mark - View lifecycle
-(id)init {
	if((self = [super init])) {
		self.navigationItem.titleView = [[[DINavTitleView alloc] initWithTitle:@"give reward"] autorelease];
		
		DINavLeftBtnView *cancelBtnView = [[[DINavLeftBtnView alloc] initWithLabel:@"Cancel"] autorelease];
		[[cancelBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:cancelBtnView] autorelease];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_onPricePakSelected:) name:@"PRICE_PAK_SELECTED" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_goIAPComplete:) name:@"IAP_COMPLETED" object:nil];
		
		_type_id = 2;
		_pricePakViews = [[NSMutableArray alloc] init];
	}
	
	return (self);
}

-(id)initWithDevice:(DIDevice *)device {
	if ((self = [self init])) {
		_device = device;
		
		NSLog(@"GO ADD CHORE:[%@]", _device);
	}
	
	return (self);
}


-(void)loadView {
	[super loadView];
	
	CGRect frame;
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]] autorelease];
	[self.view addSubview:bgImgView];
	
	_holderView = [[UIView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:_holderView];
	
	UIImageView *avatarImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"parentAvatarBG.png"]] autorelease];
	frame = avatarImgView.frame;
	frame.origin.x = 25;
	frame.origin.y = 30;
	avatarImgView.frame = frame;
	[_holderView addSubview:avatarImgView];
	
	UIImageView *sillouteImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"parentAvatar.png"]] autorelease];
	frame = sillouteImgView.frame;
	frame.origin.x = 7;
	frame.origin.y = 7;
	sillouteImgView.frame = frame;
	[avatarImgView addSubview:sillouteImgView];
	
	UIButton *txtInputButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	txtInputButton.frame = CGRectMake(73, 30, 224, 124);
	[txtInputButton setBackgroundImage:[[UIImage imageNamed:@"commentField_BG.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[txtInputButton setBackgroundImage:[[UIImage imageNamed:@"commentField_BG.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[txtInputButton addTarget:self action:@selector(_goTextFields) forControlEvents:UIControlEventTouchUpInside];
	[_holderView addSubview:txtInputButton];
	
	_titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(95, 36, 300, 18)] autorelease];
	_titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	_titleLabel.textColor = [UIColor colorWithWhite:0.33 alpha:1.0];
	_titleLabel.backgroundColor = [UIColor clearColor];
	_titleLabel.shadowColor = [UIColor whiteColor];
	_titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	_titleLabel.text = @"give a title…";
	[_holderView addSubview:_titleLabel];
	
	_commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 66, 160, 20)];
	_commentLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	_commentLabel.textColor = [UIColor lightGrayColor];
	_commentLabel.backgroundColor = [UIColor clearColor];
	_commentLabel.text = @"Leave a note…";
	[_holderView addSubview:_commentLabel];
	
	UIImageView *dividerImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]] autorelease];
	frame = dividerImgView.frame;
	frame.origin.y = 173;
	dividerImgView.frame = frame;
	[_holderView addSubview:dividerImgView];
	
	UIButton *rewardButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	rewardButton.frame = CGRectMake(35, 196, 124, 34);
	rewardButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
	[rewardButton setBackgroundImage:[[UIImage imageNamed:@"greenCommonButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[rewardButton setBackgroundImage:[[UIImage imageNamed:@"greenCommonButton_active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[rewardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	rewardButton.titleLabel.shadowColor = [UIColor blackColor];
	rewardButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
	[rewardButton setTitle:@"Reward" forState:UIControlStateNormal];
	[rewardButton addTarget:self action:@selector(_goRewardType) forControlEvents:UIControlEventTouchUpInside];
	[_holderView addSubview:rewardButton];
	
	UIButton *choreButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	choreButton.frame = CGRectMake(165, 196, 124, 34);
	choreButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11.0];
	[choreButton setBackgroundImage:[[UIImage imageNamed:@"offButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[choreButton setBackgroundImage:[[UIImage imageNamed:@"offButton_nonActive@2x.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[choreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	choreButton.titleLabel.shadowColor = [UIColor blackColor];
	choreButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
	[choreButton setTitle:@"Chore" forState:UIControlStateNormal];
	[choreButton addTarget:self action:@selector(_goChoreType) forControlEvents:UIControlEventTouchUpInside];
	[_holderView addSubview:choreButton];
	
	UIButton *sendButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	sendButton.frame = CGRectMake(25, 337, 279, 59);
	[sendButton setBackgroundImage:[[UIImage imageNamed:@"largeButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[sendButton setBackgroundImage:[[UIImage imageNamed:@"largeButton_active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	sendButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:16];
	sendButton.titleLabel.shadowColor = [UIColor blackColor];
	sendButton.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	[sendButton setTitle:@"send" forState:UIControlStateNormal];
	[sendButton addTarget:self action:@selector(_goSend) forControlEvents:UIControlEventTouchUpInside];
	[_holderView addSubview:sendButton];
	
	
	_txtInputView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 280, 150)];
	_txtInputView.backgroundColor = [UIColor whiteColor];
	_txtInputView.layer.cornerRadius = 8.0;
	_txtInputView.clipsToBounds = YES;
	_txtInputView.layer.borderColor = [[UIColor colorWithWhite:0.67 alpha:1.0] CGColor];
	_txtInputView.layer.borderWidth = 1.0;
	_txtInputView.hidden = YES;
	[self.view addSubview:_txtInputView];
	
	_titleInputLabel = [[[UILabel alloc] initWithFrame:CGRectMake(95, 36, 300, 18)] autorelease];
	_titleInputLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	_titleInputLabel.textColor = [UIColor colorWithWhite:0.33 alpha:1.0];
	_titleInputLabel.backgroundColor = [UIColor clearColor];
	_titleInputLabel.shadowColor = [UIColor whiteColor];
	_titleInputLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	_titleInputLabel.text = @"give a title…";
	[_txtInputView addSubview:_titleInputLabel];
	
	_titleInputTxtField = [[[UITextField alloc] initWithFrame:CGRectMake(95, 36, 200, 64)] autorelease];
	[_titleInputTxtField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_titleInputTxtField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_titleInputTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_titleInputTxtField setBackgroundColor:[UIColor clearColor]];
	[_titleInputTxtField setReturnKeyType:UIReturnKeyDone];
	[_titleInputTxtField addTarget:self action:@selector(onTxtDoneEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
	_titleInputTxtField.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	_titleInputTxtField.keyboardType = UIKeyboardTypeDefault;
	_titleInputTxtField.delegate = self;
	_titleInputTxtField.text = @"";
	[_txtInputView addSubview:_titleInputTxtField];
	
	_commentInputLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 66, 160, 20)];
	_commentInputLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	_commentInputLabel.textColor = [UIColor lightGrayColor];
	_commentInputLabel.backgroundColor = [UIColor clearColor];
	_commentInputLabel.text = @"Leave a note…";
	[_txtInputView addSubview:_commentInputLabel];
	
	_commentInputTxtView = [[[UITextView alloc] initWithFrame:CGRectMake(90, 60, 300, 160)] autorelease];
	[_commentInputTxtView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[_commentInputTxtView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[_commentInputTxtView setAutocorrectionType:UITextAutocorrectionTypeNo];
	[_commentInputTxtView setBackgroundColor:[UIColor clearColor]];
	[_commentInputTxtView setTextColor:[UIColor colorWithWhite:0.67 alpha:1.0]];
	_commentInputTxtView.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	_commentInputTxtView.keyboardType = UIKeyboardTypeDefault;
	_commentInputTxtView.delegate = self;
	[_commentInputTxtView setReturnKeyType:UIReturnKeyDone];
	[_txtInputView addSubview:_commentInputTxtView];

	
	UIImageView *overlayImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]] autorelease];
	frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];
	
}

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	_loadOverlay = [[DILoadOverlay alloc] init];
	
	_iapPakRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kServerPath, @"InAppPurchases.php"]]] retain];
	[_iapPakRequest setPostValue:[NSString stringWithFormat:@"%d", 1] forKey:@"action"];
	[_iapPakRequest setDelegate:self];
	[_iapPakRequest startAsynchronous];
}


-(void)viewDidUnload {
    [super viewDidUnload];
}

-(void)dealloc {
	[super dealloc];
}


#pragma mark - Navigation
-(void)_goBack {
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)_goRewardType {
	_type_id = 2;
}

-(void)_goChoreType {
	_type_id = 1;
}

-(void)_goPricePak {
	
	int cnt = 0;
	for (DIDiddsPakView *diddsPakView in _pricePakViews) {
		if (diddsPakView.isSelected)
			NSLog(@"isSelected @[%d]", cnt);
		
		cnt++;
	}
}

-(void)_goTextFields {
	_holderView.hidden = YES;
	_txtInputView.hidden = NO;
	
	[_titleInputTxtField becomeFirstResponder];
}

-(void)onTxtDoneEditing:(id)sender {
	[sender resignFirstResponder];
	
	_titleLabel.text = _titleInputTxtField.text;
	_commentLabel.text = _commentInputTxtView.text;
	
	_holderView.hidden = NO;
	_txtInputView.hidden = YES;
}

#pragma mark - Notifications
-(void)_onPricePakSelected:(NSNotification *)notification {
	DIPricePak *pricePak = (DIPricePak *)[notification object];
	_pricePak = pricePak;
	
	for (DIDiddsPakView *diddsPakView in _pricePakViews) {
		if ([diddsPakView.pricePak isEqual:pricePak]) {
			//_iap_id = pricePak.iap_id;	
		}
	}
}

-(void)_goIAPComplete:(NSNotification *)notification {
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
	
	_loadOverlay = [[DILoadOverlay alloc] init];
	
	NSLog(@"-----------> SUMBIT CHORE <------------");
	NSLog(@"choreTitle:[%@]", _titleLabel.text);
	NSLog(@"choreInfo:[%@]", _commentLabel.text);
	NSLog(@"cost:[%f]", _pricePak.cost);
	NSLog(@"expires:[%@]", @"0000-00-00 00:00:00");
	NSLog(@"image:[%@]", @"");
	NSLog(@"type_id:[%d]", _type_id);
	NSLog(@"subIDs:[%d]", _device.device_id);
	NSLog(@"iapID:[%d]", _pricePak.iap_id);

	
	_addChoreDataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kServerPath, @"Rewards.php"]]] retain];
	[_addChoreDataRequest setPostValue:[NSString stringWithFormat:@"%d", 7] forKey:@"action"];
	[_addChoreDataRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	[_addChoreDataRequest setPostValue:_titleLabel.text forKey:@"choreTitle"];
	[_addChoreDataRequest setPostValue:_commentLabel.text forKey:@"choreInfo"];
	[_addChoreDataRequest setPostValue:[NSNumber numberWithFloat:_pricePak.cost] forKey:@"cost"];
	//[_addChoreDataRequest setPostValue:[dateFormat stringFromDate:_chore.expires] forKey:@"expires"];
	[_addChoreDataRequest setPostValue:@"0000-00-00 00:00:00" forKey:@"expires"];
	[_addChoreDataRequest setPostValue:@"" forKey:@"image"];
	[_addChoreDataRequest setPostValue:[NSString stringWithFormat:@"%d", _type_id] forKey:@"type_id"];
	[_addChoreDataRequest setPostValue:[NSString stringWithFormat:@"%d", _device.device_id] forKey:@"subIDs"];
	[_addChoreDataRequest setPostValue:[NSString stringWithFormat:@"%d", _pricePak.iap_id] forKey:@"iapID"];
	[_addChoreDataRequest setDelegate:self];
	[_addChoreDataRequest startAsynchronous];
	
	[dateFormat release];
}

-(void)_goSend {
	//_chore = [DIChore choreWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"0", @"id", _titleTxtField.text, @"title", _commentTxtView.text, @"info", @"", @"icoPath", @"00000000000000", @"imgPath", @"0000-00-00 00:00:00", @"expires", _points, @"points", _cost, @"cost", _iap_id, @"iap_id", _type_id, @"type_id", _device.device_id, @"subIDs", nil]];
	
		
	if (_pricePak.cost > 0.00) {
		
		//if ([SKPaymentQueue canMakePayments]) {
		NSLog(@"REQUEST PRODUCT[%@]", _pricePak.itunes_id);
		
		_loadOverlay = [[DILoadOverlay alloc] init];
		SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObjects:_pricePak.itunes_id, nil]];
		request.delegate = self;
		[request start];
		//}
	} else {
	  	[[NSNotificationCenter defaultCenter] postNotificationName:@"IAP_COMPLETED" object:nil];
	}
}

#pragma mark - TextField Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if ([textField.text length] == 0)
		_titleInputLabel.hidden = YES;
	
	return (YES);
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
	
	if ([textField.text length] == 0)
		_titleInputLabel.hidden = NO;
	
	[_titleInputTxtField resignFirstResponder];
}

#pragma mark - TextView Delegates
-(void)textViewDidBeginEditing:(UITextView *)textView {
	_commentInputLabel.hidden = YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView {
	
	if ([textView.text length] == 0)
		_commentInputLabel.hidden = NO;
	
	[_commentInputTxtView resignFirstResponder];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	
	if ([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];
		_holderView.hidden = NO;
		_txtInputView.hidden = YES;
		return (NO);
	}
	
	return (YES);
}

#pragma mark - ProductsRequest Delegates
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
	NSLog(@"\n\n-------PRODUCT REQUEST--------\nINVALID:[%@]\nVALID[%@]", response.invalidProductIdentifiers, response.products);
	
	[_loadOverlay remove];
	NSArray *myProduct = response.products;
	
	if ([response.invalidProductIdentifiers count] > 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App Store Error" message:@"Restart app to try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
	}
	
	for (int i=0; i<[myProduct count]; i++) {
		SKProduct *product = [myProduct objectAtIndex:i];
		NSLog(@"Name: %@ - Price: %f - INFO:[%@]", [product localizedTitle], [[product price] doubleValue], [product localizedDescription]);
		NSLog(@"Product identifier: %@", [product productIdentifier]);
		
		SKPayment *payRequest = [SKPayment paymentWithProduct:product];
		[[SKPaymentQueue defaultQueue] addPayment:payRequest];
		
		[request autorelease];
	}
}


#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	NSLog(@"[ChorePrice responseString]=\n%@\n\n", [request responseString]);
	
	if ([request isEqual:_iapPakRequest]) {
		@autoreleasepool {
			NSError *error = nil;
			NSArray *parsedPaks = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
			
			if (error != nil)
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
			
			else {
				NSMutableArray *iapList = [NSMutableArray array];
				
				for (NSDictionary *serverIAP in parsedPaks) {
					DIPricePak *pricePak = [DIPricePak pricePakWithDictionary:serverIAP];
					
					if (pricePak != nil)
						[iapList addObject:pricePak];
				}
				
				_iapPaks = [iapList retain];
				
				UIScrollView *iapScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(35.0, 250.0, self.view.bounds.size.width, 70.0)];
				iapScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
				iapScrollView.delegate = self;
				iapScrollView.opaque = NO;
				iapScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, iapScrollView.frame.size.height);
				iapScrollView.pagingEnabled = YES;
				iapScrollView.scrollsToTop = NO;
				iapScrollView.showsHorizontalScrollIndicator = NO;
				iapScrollView.showsVerticalScrollIndicator = NO;
				iapScrollView.alwaysBounceVertical = NO;
				[_holderView addSubview:iapScrollView];
				
				int cnt = 0;
				for (DIPricePak *pricePak in _iapPaks) {
					DIDiddsPakView *diddsPakView = [[[DIDiddsPakView alloc] initWithPricePak:pricePak] autorelease];
					CGRect frame = CGRectMake((cnt * 65), 0, 49, 49);
					diddsPakView.frame = frame;
					[[diddsPakView btn] addTarget:self action:@selector(_goPricePak) forControlEvents:UIControlEventTouchUpInside];
					
					[_pricePakViews addObject:diddsPakView];
					[iapScrollView addSubview:diddsPakView];
					
					cnt++;
				}
			}
		}
		
	} else if ([request isEqual:_addChoreDataRequest]) {
		@autoreleasepool {
			NSError *error = nil;
			NSDictionary *parsedChore = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
			
			if (error != nil)
				NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
			
			else {
				
				[self dismissViewControllerAnimated:YES completion:^(void) {
					[[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_CHORE" object:[DIChore choreWithDictionary:parsedChore]];
				}];
			}
		}
	}
	
	[_loadOverlay remove];
}

-(void)requestFailed:(ASIHTTPRequest *)request {
	[_loadOverlay remove];
}

@end
