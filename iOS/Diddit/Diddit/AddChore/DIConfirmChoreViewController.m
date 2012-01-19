//
//  DIConfirmChoreViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.13.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DIConfirmChoreViewController.h"


#import "DIAppDelegate.h"
#import "DIChore.h"

#import "DIPinCodeViewController.h"

@implementation DIConfirmChoreViewController


#pragma mark - View lifecycle
-(id)initWithChore:(DIChore *)chore {
	if ((self = [super initWithTitle:@"add chore" header:@"review, approve, and submit" backBtn:@"Back"])) {
		_chore = chore;	
		_isCameraPic = NO;
		
		if ([SKPaymentQueue canMakePayments] && _chore.cost > 0.00)
			[self requestProductData];
		
		else
			NSLog(@"NO CAN BUY!");
	}
	
	return (self);
}

-(void)requestProductData {
	//NSMutableArray *idList = [[NSMutableArray alloc] init];  
	
	NSLog(@"productID:[%@]", _chore.itunes_id);
	SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObjects:_chore.itunes_id, nil]];
	
	//for (int i=0; i<=0; i++) { //9
	//	NSString *productIdent = [NSString stringWithFormat:@"com.getdiddit.consumable.%03d99", i];
	//	[idList addObject:productIdent];
	//	NSLog(@"PRODUCT: [%@]", productIdent);
	//}	
	//SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:idList]];  
	
	//NSSet *prodIDs = [NSSet setWithObjects:@"com.getdiddit.consumable.00099", nil];
	//SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:prodIDs];
	request.delegate = self;
	[request start];
}


-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
	NSLog(@"\n\n-------PRODUCT REQUEST--------\nINVALID:[%@]\nVALID[%@]", response.invalidProductIdentifiers, response.products);
	
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


-(void)loadView {
	[super loadBaseView];
	
	[self.view setBackgroundColor:[UIColor colorWithRed:0.988235294117647 green:0.988235294117647 blue:0.713725490196078 alpha:1.0]];
	CGRect frame;
	
	_textSize = [_chore.info sizeWithFont:[[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12] constrainedToSize:CGSizeMake(300.0, CGFLOAT_MAX) lineBreakMode:UILineBreakModeClip];
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]] autorelease];
	[self.view addSubview:bgImgView];
	
	UITableView *tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 348.0) style:UITableViewStylePlain] autorelease];
	tableView.rowHeight = 305 + _textSize.height;
	tableView.backgroundColor = [UIColor clearColor];
	tableView.separatorColor = [UIColor clearColor];
	tableView.delegate = self;
	tableView.dataSource = self;
	[self.view addSubview:tableView];
	
	_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 292.0)];
	_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_scrollView.contentSize = CGSizeMake(320, 310 + _textSize.height);
	_scrollView.opaque = NO;
	_scrollView.scrollsToTop = NO;
	_scrollView.showsHorizontalScrollIndicator = NO;
	_scrollView.showsVerticalScrollIndicator = YES;
	_scrollView.alwaysBounceVertical = NO;
	//[self.view addSubview:_scrollView];
	
	UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)] autorelease];
	headerView.backgroundColor = [UIColor colorWithRed:0.988235294117647 green:0.988235294117647 blue:0.713725490196078 alpha:1.0];
	[_scrollView addSubview:headerView];
	
	UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 20)] autorelease];
	titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:16];
	titleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	titleLabel.text = _headerTxt;
	titleLabel.textAlignment = UITextAlignmentCenter;
	[_scrollView addSubview:titleLabel];
	
	UIImageView *dividerImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]] autorelease];
	frame = dividerImgView.frame;
	frame.origin.y = 48;
	dividerImgView.frame = frame;
	[_scrollView addSubview:dividerImgView];
	
	_choreThumbBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_choreThumbBtn.frame = CGRectMake(10, 64, 58, 58);
	_choreThumbBtn.backgroundColor = [UIColor colorWithRed:1.0 green:0.988235294117647 blue:0.874509803921569 alpha:1.0];
	_choreThumbBtn.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0] CGColor];
	_choreThumbBtn.layer.borderWidth = 1.0;
	_choreThumbBtn.clipsToBounds = YES;
	_choreThumbBtn.imageEdgeInsets = UIEdgeInsetsMake(15.0, 12.0, -15.0, -12.0);
	[_choreThumbBtn setImage:[UIImage imageNamed:@"cameraIcon.png"] forState:UIControlStateNormal];
	[_choreThumbBtn addTarget:self action:@selector(_goActionSheet) forControlEvents:UIControlEventTouchUpInside];
	[_scrollView addSubview:_choreThumbBtn];
	
	
	UIImageView *choreImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choreThumb.png"]] autorelease];
	frame = choreImgView.frame;
	frame.origin.x = 10;
	frame.origin.y = 55;
	choreImgView.frame = frame;
	[_scrollView addSubview:choreImgView];
	
	UILabel *choreTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(78, 83, 200, 24)] autorelease];
	choreTitleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:20];
	choreTitleLabel.textColor = [UIColor blackColor];
	choreTitleLabel.backgroundColor = [UIColor clearColor];
	choreTitleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	choreTitleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	choreTitleLabel.text = _chore.title;
	[_scrollView addSubview:choreTitleLabel];
	
	UIImageView *divider2ImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]] autorelease];
	frame = divider2ImgView.frame;
	frame.origin.y = 143;
	divider2ImgView.frame = frame;
	[_scrollView addSubview:divider2ImgView];
	
	UILabel *rewardLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 150, 120, 16)] autorelease];
	rewardLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	rewardLabel.textColor = [UIColor colorWithWhite:0.33 alpha:1.0];
	rewardLabel.backgroundColor = [UIColor clearColor];
	rewardLabel.text = @"Reward";
	[_scrollView addSubview:rewardLabel];
	
	_imgView = [[EGOImageView alloc] initWithFrame:CGRectMake(74, 164, 59, 59)];
	_imgView.imageURL = [NSURL URLWithString:_chore.icoPath];
	[_scrollView addSubview:_imgView];
	
	UILabel *rewardTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(144, 172, 120, 20)] autorelease];
	rewardTitleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:16];
	rewardTitleLabel.textColor = [UIColor blackColor];
	rewardTitleLabel.backgroundColor = [UIColor clearColor];
	rewardTitleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	rewardTitleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	rewardTitleLabel.text = [NSString stringWithFormat:@"%@ didds", _chore.disp_points];
	[_scrollView addSubview:rewardTitleLabel];
	
	UILabel *rewardPriceLabel = [[[UILabel alloc] initWithFrame:CGRectMake(144, 190, 100, 16)] autorelease];
	rewardPriceLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11];
	rewardPriceLabel.textColor = [UIColor colorWithWhite:0.67 alpha:1.0];
	rewardPriceLabel.backgroundColor = [UIColor clearColor];
	rewardPriceLabel.text = _chore.price;
	[_scrollView addSubview:rewardPriceLabel];
	
	UIImageView *divider3ImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerDivider.png"]] autorelease];
	frame = divider3ImgView.frame;
	frame.origin.y = 251;
	divider3ImgView.frame = frame;
	[_scrollView addSubview:divider3ImgView];
	
	UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 267, 300, _textSize.height)] autorelease];
	infoLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	infoLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
	infoLabel.backgroundColor = [UIColor clearColor];
	infoLabel.numberOfLines = 0;
	infoLabel.text = _chore.info;
	[_scrollView addSubview:infoLabel];
	
	if (_textSize.height == 0)
		_textSize.height = -10;
	
	UIImageView *calendarImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 282.0 + _textSize.height, 14, 14)] autorelease];
	calendarImgView.image = [UIImage imageNamed:@"cal_Icon.png"];
	[_scrollView addSubview:calendarImgView];
	
	UILabel *expiresLabel = [[[UILabel alloc] initWithFrame:CGRectMake(32, 282 + _textSize.height, 200, 16)] autorelease];
	expiresLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	expiresLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
	expiresLabel.backgroundColor = [UIColor clearColor];
	expiresLabel.text = [NSString stringWithFormat:@"Expires on %@", _chore.disp_expires];
	[_scrollView addSubview:expiresLabel];
	
	UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 348, 320, 72)] autorelease];
	footerView.backgroundColor = [UIColor colorWithRed:0.2706 green:0.7804 blue:0.4549 alpha:1.0];
	[self.view addSubview:footerView];
			
	_submitButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_submitButton.frame = CGRectMake(0, 352, 320, 59);
	_submitButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
	_submitButton.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
	[_submitButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[_submitButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_submitButton setTitle:@"submit" forState:UIControlStateNormal];
	[_submitButton addTarget:self action:@selector(_goSubmit) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_submitButton];
	
	UIImageView *overlayImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]] autorelease];
	frame = overlayImgView.frame;
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
	//[_chore autorelease];
	[_submitButton release];
	[_imgView release];
	[_choreThumbBtn release];
	[_scrollView release];
	
	[_loadOverlay release];
	
	[super dealloc];
}

#pragma mark - navigation
-(void)_goBack {
	[self.navigationController popViewControllerAnimated:YES];
}


-(void)_goActionSheet {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"choose picture", @"take picture", nil];
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)_goSubmit {
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
	
	_loadOverlay = [[DILoadOverlay alloc] init];
	
	ASIFormDataRequest *dataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Chores.php"]] retain];
	[dataRequest setPostValue:[NSString stringWithFormat:@"%d", 7] forKey:@"action"];
	[dataRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	[dataRequest setPostValue:_chore.title forKey:@"choreTitle"];
	[dataRequest setPostValue:_chore.info forKey:@"choreInfo"];
	[dataRequest setPostValue:[NSNumber numberWithFloat:_chore.cost] forKey:@"cost"];
	[dataRequest setPostValue:[dateFormat stringFromDate:_chore.expires] forKey:@"expires"];
	[dataRequest setPostValue:_chore.imgPath forKey:@"image"];
	[dataRequest setDelegate:self];
	[dataRequest startAsynchronous];
	
	[dateFormat release];
}


#pragma mark - TableView Data Source Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return (1);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
		UITableViewCell *cell = nil;
		cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
		
		if (cell == nil) {			
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			[cell addSubview:_scrollView];
		}
		
		return (cell);		
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];		
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return (310 + _textSize.height);
}


#pragma mark - ActionSheet Delegates
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	switch(buttonIndex) {
		case 0:
			if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
				_isCameraPic = NO;
				
				UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
				imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
				imagePicker.delegate = self;
				imagePicker.allowsEditing = YES;
				//imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
				
				[self presentModalViewController:imagePicker animated:YES];
				
			} else {
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Camera not aviable." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
				[alertView release];
			}
			
			break;
			
		case 1:
			if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
				_isCameraPic = YES;
				
				UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
				imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
				imagePicker.delegate = self;
				imagePicker.allowsEditing = YES;
				//imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
				
				[self presentModalViewController:imagePicker animated:YES];
				
			} else {
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Camera not aviable." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
				[alertView release];
			}
			
			break;
	}
}


#pragma mark - ImagePicker Delegates
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	//[picker release];
	NSLog(@"info:[%@]", info);
	
	//NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	[self dismissModalViewControllerAnimated:YES];
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyyMMddHHmmss"];
	_chore.imgPath = [dateFormat stringFromDate:[NSDate date]];
	[dateFormat release];
	
	if (_isCameraPic) {
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
		//CGRect imageRect = CGRectMake(0.0, 0.0, 206.0, 174.0);
		CGRect imageRect = CGRectMake(0.0, 0.0, 174.0, 206.0);
		
		NSLog(@"%f, %f", image.size.width, image.size.height);
		
		UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, [UIScreen mainScreen].scale);
		[image drawInRect:imageRect];
		UIImage *resizedImg = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		UIImageWriteToSavedPhotosAlbum(resizedImg, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
		
		[_choreThumbBtn setImage:resizedImg forState:UIControlStateNormal];
		_choreThumbBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
	
		NSData *imageData = UIImagePNGRepresentation(resizedImg); 
		[[NSUserDefaults standardUserDefaults] setObject:imageData forKey:_chore.imgPath];
	
	} else {
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
		NSLog(@"%f, %f", image.size.width, image.size.height);
		
		[_choreThumbBtn setImage:[info objectForKey:UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
		_choreThumbBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
		
		NSData *imageData = UIImagePNGRepresentation(image); 
		[[NSUserDefaults standardUserDefaults] setObject:imageData forKey:_chore.imgPath];
	}
	
	NSLog(@"IMG:[%@]", _chore.imgPath);
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
	UIAlertView *alert;
	
	if (_isCameraPic) {
		if (error)
			alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to save image to Photo Album." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	
		else
			alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Image saved to Photo Album." delegate:nil cancelButtonTitle:@"Ok"  otherButtonTitles:nil];
	}
	
	[alert show];
	[alert release];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	NSLog(@"[_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
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
	
	[_loadOverlay remove];
}

-(void)requestFailed:(ASIHTTPRequest *)request {
	[_loadOverlay remove];
}

@end
