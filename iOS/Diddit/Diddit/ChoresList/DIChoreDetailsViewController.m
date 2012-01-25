//
//  DIChoreDetailsViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.14.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DIChoreDetailsViewController.h"

#import "DIAppDelegate.h"
#import "DINavTitleView.h"
#import "DINavBackBtnView.h"
#import "DIPinCodeViewController.h"

@implementation DIChoreDetailsViewController

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_finishChore:) name:@"FINISH_CHORE" object:nil];
		
		DINavBackBtnView *backBtnView = [[[DINavBackBtnView alloc] init] autorelease];
		[[backBtnView btn] addTarget:self action:@selector(_goBack) forControlEvents:UIControlEventTouchUpInside];		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backBtnView] autorelease];
	}
	
	return (self);
}

-(id)initWithChore:(DIChore *)chore {
	if ((self = [self init])) {
		_chore = chore;
		self.navigationItem.titleView = [[[DINavTitleView alloc] initWithTitle:@"chore details"] autorelease];		
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	[self.view setBackgroundColor:[UIColor colorWithRed:0.988235294117647 green:0.988235294117647 blue:0.713725490196078 alpha:1.0]];
	
	UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)] autorelease];
	headerView.backgroundColor = [UIColor colorWithRed:0.988235294117647 green:0.988235294117647 blue:0.713725490196078 alpha:1.0];
	[self.view addSubview:headerView];
	
	CGRect frame;
	
	_textSize = [_chore.info sizeWithFont:[[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12] constrainedToSize:CGSizeMake(300.0, CGFLOAT_MAX) lineBreakMode:UILineBreakModeClip];
	
	UITableView *tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 348.0) style:UITableViewStylePlain] autorelease];
	tableView.rowHeight = 325 + _textSize.height;
	tableView.backgroundColor = [UIColor clearColor];
	tableView.separatorColor = [UIColor clearColor];
	tableView.delegate = self;
	tableView.dataSource = self;
	[self.view addSubview:tableView];
	
	_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 362)];
	_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_scrollView.contentSize = CGSizeMake(320, 300 + _textSize.height);
	_scrollView.opaque = NO;
	_scrollView.scrollsToTop = NO;
	_scrollView.showsHorizontalScrollIndicator = NO;
	_scrollView.showsVerticalScrollIndicator = YES;
	_scrollView.alwaysBounceVertical = NO;
	//[self.view addSubview:_scrollView];
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]] autorelease];
	frame = bgImgView.frame;
	frame.origin.y = 48;
	bgImgView.frame = frame;
	[_scrollView addSubview:bgImgView];
	
	UILabel *expiresLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 16, 300, 24)] autorelease];
	expiresLabel.font = [[DIAppDelegate diAdelleFontSemibold] fontWithSize:16];
	expiresLabel.textColor = [UIColor colorWithRed:0.996 green:0.035 blue:0.220 alpha:1.0];
	expiresLabel.backgroundColor = [UIColor clearColor];
	expiresLabel.textAlignment =UITextAlignmentCenter;
	expiresLabel.text = [NSString stringWithFormat:@"expires on %@", _chore.disp_expires];
	[_scrollView addSubview:expiresLabel];
	
	
	UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 59, 320, 40)] autorelease];
	titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:20];
	titleLabel.textColor = [UIColor colorWithWhite:0.404 alpha:1.0];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	titleLabel.text = _chore.title;
	[_scrollView addSubview:titleLabel];
	
	UILabel *pointsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 88, 320, 40)] autorelease];
	pointsLabel.font = [[DIAppDelegate diAdelleFontRegular] fontWithSize:18];
	pointsLabel.textColor = [UIColor blackColor];
	pointsLabel.backgroundColor = [UIColor clearColor];
	pointsLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	pointsLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	pointsLabel.text = [NSString stringWithFormat:@"%@ didds", _chore.disp_points];
	[_scrollView addSubview:pointsLabel];

	_imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 134, 280, 174)];
	_imgView.backgroundColor = [UIColor colorWithRed:1.0 green:0.988235294117647 blue:0.874509803921569 alpha:1.0];
	_imgView.layer.borderColor = [[UIColor colorWithWhite:0.67 alpha:1.0] CGColor];
	_imgView.layer.borderWidth = 1.0;
	[_scrollView addSubview:_imgView];
	
	UIButton *imageButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	imageButton.frame = CGRectMake(20, 134, 280, 174);
	imageButton.backgroundColor = [UIColor clearColor];
	[imageButton addTarget:self action:@selector(_goActionSheet) forControlEvents:UIControlEventTouchUpInside];
	
//	if (![[NSUserDefaults standardUserDefaults] valueForKey:_chore.imgPath]) {
//		UIImageView *cameraImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(242.0, 140.0, 29, 29)] autorelease];
//		cameraImgView.image = [UIImage imageNamed:@"cameraIcon_lg.png"];
//		//[_imgView addSubview:cameraImgView];		
//		[imageButton addSubview:cameraImgView];
//	}
	
	[_scrollView addSubview:imageButton];
	//if ([[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"image1bw"]]) {
	//	NSData *imageData = [[NSUserDefaults standardUserDefaults] valueForKey:[NSString stringWithFormat:@"image1bw"]];
	//	_imgView.image = [UIImage imageWithData:imageData];
	//} 
	
	if ([[NSUserDefaults standardUserDefaults] valueForKey:_chore.imgPath]) {
		NSData *imageData = [[NSUserDefaults standardUserDefaults] valueForKey:_chore.imgPath];
		_imgView.image = [UIImage imageWithData:imageData];
		[imageData release];
	
	} else
		_imgView.image = [UIImage imageNamed:@"emptyChore.jpg"];
	
	
	CGSize txtSize = [_chore.info sizeWithFont:[[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12] constrainedToSize:CGSizeMake(300.0, CGFLOAT_MAX) lineBreakMode:UILineBreakModeClip];
	
	NSLog(@"TXTSIZE:[%@]", _chore.info);
	
	UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 320, 280, txtSize.height)] autorelease];
	infoLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	infoLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
	infoLabel.backgroundColor = [UIColor clearColor];
	infoLabel.numberOfLines = 0;
	infoLabel.text = _chore.info;
	[_scrollView addSubview:infoLabel];
	
	
	UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 344, 320, 72)] autorelease];
	footerView.backgroundColor = [UIColor colorWithRed:0.2706 green:0.7804 blue:0.4549 alpha:1.0];
	[self.view addSubview:footerView];
	
	_completeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_completeButton.frame = CGRectMake(0, 351, 320, 59);
	_completeButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
	_completeButton.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
	[_completeButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[_completeButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[_completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	_completeButton.titleLabel.shadowColor = [UIColor whiteColor];
	_completeButton.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	[_completeButton setTitle:@"approve chore" forState:UIControlStateNormal];
	[_completeButton addTarget:self action:@selector(_goComplete) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_completeButton];
	
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
	[_imgView release];
	[_completeButton release];
	[_scrollView release];
	[_updUserRequest release];
	[_chore release];
	
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

-(void)_goComplete {
	
	DIPinCodeViewController *pinCodeViewController = [[[DIPinCodeViewController alloc] initWithChore:_chore fromSettings:NO] autorelease];
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:pinCodeViewController] autorelease];
	//[self.navigationController presentViewController:navigationController animated:YES completion:nil];
	[self.navigationController presentModalViewController:navigationController animated:YES];
}


#pragma mark - notication handlers
-(void)_finishChore:(NSNotification *)notification {

	/*
	_updUserRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Users.php"]] retain];
	[_updUserRequest setPostValue:[NSString stringWithFormat:@"%d", 4] forKey:@"action"];
	[_updUserRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	[_updUserRequest setPostValue:[NSString stringWithFormat:@"%d", _chore.cost * 100] forKey:@"points"];
	[_updUserRequest setDelegate:self];
	[_updUserRequest startAsynchronous];
	*/
	/*
	ASIFormDataRequest *finishChoreRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Chores.php"]] retain];
	[finishChoreRequest setPostValue:[NSString stringWithFormat:@"%d", 6] forKey:@"action"];
	[finishChoreRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	[finishChoreRequest setPostValue:[NSString stringWithFormat:@"%d", _chore.chore_id] forKey:@"choreID"];
	[finishChoreRequest setDelegate:self];
	[finishChoreRequest startAsynchronous];
	*/
	[self.navigationController popViewControllerAnimated:YES];
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
		_imgView.image = resizedImg;
		
		NSData *imageData = UIImagePNGRepresentation(resizedImg); 
		[[NSUserDefaults standardUserDefaults] setObject:imageData forKey:_chore.imgPath];
		
	} else {
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
		NSLog(@"%f, %f", image.size.width, image.size.height);
		
		_imgView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
		
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
	
	if ([request isEqual:_updUserRequest]) {
		ASIFormDataRequest *finishChoreRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Chores.php"]] retain];
		[finishChoreRequest setPostValue:[NSString stringWithFormat:@"%d", 6] forKey:@"action"];
		[finishChoreRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
		[finishChoreRequest setPostValue:[NSString stringWithFormat:@"%d", _chore.chore_id] forKey:@"choreID"];
		[finishChoreRequest setDelegate:self];
		[finishChoreRequest startAsynchronous];
	
	} //else
		//[_loadOverlayView toggle:NO];
	
//	@autoreleasepool {
//		NSError *error = nil;
//		NSArray *parsedChores = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
//		
//		if (error != nil)
//			NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
//		
//		else {
//			NSMutableArray *choreList = [NSMutableArray array];
//			
//			for (NSDictionary *serverChore in parsedChores) {
//				DIChore *chore = [DIChore choreWithDictionary:serverChore];
//				
//				if (chore != nil)
//					[choreList addObject:chore];
//			}
//			
//		}
//	}
	
}


-(void)requestFailed:(ASIHTTPRequest *)request {
	//[_loadOverlayView toggle:NO];
}

@end
