//
//  DIAddPhotoViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.19.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIAddPhotoViewController.h"

#import "DINavRightBtnView.h"
#import "DIChorePriceViewController.h"

@implementation DIAddPhotoViewController


#pragma mark - View lifecycle
-(id)initWithChore:(DIChore *)chore {
	if ((self = [super initWithTitle:@"add chore" header:@"what type of chore is it?" backBtn:@"Back"])) {
		_chore = chore;
		_isCameraPic = NO;
		
		DINavRightBtnView *nextBtnView = [[[DINavRightBtnView alloc] initWithLabel:@"Next"] autorelease];
		[[nextBtnView btn] addTarget:self action:@selector(_goNext) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:nextBtnView] autorelease];
		
		_types = [[NSMutableArray alloc] initWithObjects:@"Take photo", @"Camera Roll", @"Laundry", @"Car Wash", nil];
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	
	_photoTypeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 48, self.view.bounds.size.width, self.view.bounds.size.height - 80) style:UITableViewStylePlain];
	_photoTypeTableView.rowHeight = 70;
	_photoTypeTableView.backgroundColor = [UIColor clearColor];
	_photoTypeTableView.separatorColor = [UIColor clearColor];
	_photoTypeTableView.delegate = self;
	_photoTypeTableView.dataSource = self;
	[self.view addSubview:_photoTypeTableView];
	
	_choreImgView = [[UIImageView alloc] initWithFrame:CGRectMake(58, 60, 206, 174)];
	_choreImgView.backgroundColor = [UIColor colorWithRed:1.0 green:0.988235294117647 blue:0.874509803921569 alpha:1.0];
	_choreImgView.layer.borderColor = [[UIColor colorWithWhite:0.67 alpha:1.0] CGColor];
	_choreImgView.layer.borderWidth = 1.0;
	_choreImgView.clipsToBounds = YES;
	//[self.view addSubview:_choreImgView];
	
	/*if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
	 _previewImageController = [[UIImagePickerController alloc] init];
	 _previewImageController.sourceType =  UIImagePickerControllerSourceTypeCamera;
	 _previewImageController.delegate = nil;
	 _previewImageController.allowsEditing = NO;
	 //[_choreImgView addSubview:_previewImageController.view];
	 }*/
	
	/*
	UIButton *cameraButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	cameraButton.frame = CGRectMake(0, 235, 320, 59);
	cameraButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
	cameraButton.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
	[cameraButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[cameraButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[cameraButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	cameraButton.titleLabel.shadowColor = [UIColor whiteColor];
	cameraButton.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	[cameraButton setTitle:@"camera" forState:UIControlStateNormal];
	[cameraButton addTarget:self action:@selector(_goCamera) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:cameraButton];
	
	UIButton *photoButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	photoButton.frame = CGRectMake(0, 300, 320, 59);
	photoButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
	photoButton.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
	[photoButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[photoButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[photoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	photoButton.titleLabel.shadowColor = [UIColor whiteColor];
	photoButton.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	[photoButton setTitle:@"album" forState:UIControlStateNormal];
	[photoButton addTarget:self action:@selector(_goAlbum) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:photoButton];
	 */
}

-(void)viewDidLoad {
	[super viewDidLoad];
}

-(void)viewDidUnload {
	[super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

-(void)dealloc {
	[super dealloc];
}


#pragma mark - Navigation
-(void)_goBack {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)_goNext {
	[self.navigationController pushViewController:[[[DIChorePriceViewController alloc] initWithChore:_chore] autorelease] animated:YES];
}

-(void)_goCamera {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		_isCameraPic = YES;
		
		//[_previewImageController.view removeFromSuperview];
		
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
}

-(void)_goAlbum {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		_isCameraPic = NO;
		
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
		imagePicker.delegate = self;
		imagePicker.allowsEditing = YES;
		//imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
		
		[self presentModalViewController:imagePicker animated:YES];
		
	} else {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Photo roll not available." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alertView release];
	}
}


#pragma mark - TableView Data Source Delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ([_types count]);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell = nil;
	cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	
	if (cell == nil) {			
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
		
		UIImageView *icoImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, 60, 60)] autorelease];
		//icoImgView.image = @"";
		icoImgView.layer.cornerRadius = 8.0;
		icoImgView.clipsToBounds = YES;
		icoImgView.backgroundColor = [UIColor colorWithRed:0.988 green:1.000 blue:0.714 alpha:1.0];
		icoImgView.layer.borderColor = [[UIColor colorWithWhite:0.67 alpha:1.0] CGColor];
		icoImgView.layer.borderWidth = 1.0;
		[cell addSubview:icoImgView];
		
		UILabel *appTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(76.0, 15.0, 180.0, 22)] autorelease];
		appTitleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12.0];
		appTitleLabel.backgroundColor = [UIColor clearColor];
		appTitleLabel.textColor = [UIColor colorWithRed:0.208 green:0.682 blue:0.369 alpha:1.0];
		appTitleLabel.text = @"Type";
		[cell addSubview:appTitleLabel];
		
		UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(76.0, 33.0, 300.0, 16)] autorelease];
		infoLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:14];
		infoLabel.textColor = [UIColor blackColor];
		infoLabel.backgroundColor = [UIColor clearColor];
		infoLabel.text = [_types objectAtIndex:indexPath.row];
		[cell addSubview:infoLabel];
		
		UIImageView *dividerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]];
		CGRect frame = dividerImgView.frame;
		frame.origin.x = -10;
		frame.origin.y = 80;
		dividerImgView.frame = frame;
		[cell addSubview:dividerImgView];
		
		//[cell addSubview:_sponsorshipImgView];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	}
		
	return (cell);
}

#pragma mark - TableView Delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	if (indexPath.row == 0) {
		[self _goCamera];
		
	} else if (indexPath.row == 1) {
		[self _goAlbum];
		
	} else {
		[self _goNext];
	}
	
	
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	/*
	 [UIView animateWithDuration:0.2 animations:^(void) {
	 cell.alpha = 0.5;
	 } completion:^(BOOL finished) {
	 [UIView animateWithDuration:0.15 animations:^(void) {
	 cell.alpha = 1.0;
	 
	 [self.navigationController pushViewController:[[[DIChoreDetailsViewController alloc] initWithChore:[_chores objectAtIndex:indexPath.row]] autorelease] animated:YES];	
	 [tableView deselectRowAtIndexPath:indexPath animated:YES];
	 }];
	 }];
	 */
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return (80);
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {	
	//	cell.textLabel.font = [[OJAppDelegate ojApplicationFontSemibold] fontWithSize:12.0];
	cell.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
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
		_choreImgView.image = resizedImg;
		
		NSData *imageData = UIImagePNGRepresentation(resizedImg); 
		[[NSUserDefaults standardUserDefaults] setObject:imageData forKey:_chore.imgPath];
		
	} else {
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
		NSLog(@"%f, %f", image.size.width, image.size.height);
		
		_choreImgView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
		
		NSData *imageData = UIImagePNGRepresentation(image); 
		[[NSUserDefaults standardUserDefaults] setObject:imageData forKey:_chore.imgPath];
	}
	
	[self _goNext];
	
	NSLog(@"IMG:[%@]", _chore.imgPath);
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
	
	if (_isCameraPic) {
		if (error) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to save image to Photo Album." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		
		//else
			//alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Image saved to Photo Album." delegate:nil cancelButtonTitle:@"Ok"  otherButtonTitles:nil];
	}
	
	
	
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissModalViewControllerAnimated:YES];
}


@end




/*

//
//  DIAddPhotoViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.19.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIAddPhotoViewController.h"

#import "DINavRightBtnView.h"
#import "DIChorePriceViewController.h"

#import "DIHowDiddsWorkViewController.h"

@implementation DIAddPhotoViewController


#pragma mark - View lifecycle
-(id)initWithChore:(DIChore *)chore {
	if ((self = [super initWithTitle:@"pick photo" header:@"choose a chore photo" backBtn:@"Back"])) {
		_chore = chore;
		_isCameraPic = NO;
		
		DINavRightBtnView *nextBtnView = [[[DINavRightBtnView alloc] initWithLabel:@"Next"] autorelease];
		[[nextBtnView btn] addTarget:self action:@selector(_goNext) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:nextBtnView] autorelease];
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	_choreImgView = [[UIImageView alloc] initWithFrame:CGRectMake(58, 60, 206, 174)];
	_choreImgView.backgroundColor = [UIColor colorWithRed:1.0 green:0.988235294117647 blue:0.874509803921569 alpha:1.0];
	_choreImgView.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0] CGColor];
	_choreImgView.layer.borderWidth = 1.0;
	_choreImgView.clipsToBounds = YES;
	[self.view addSubview:_choreImgView];
	
	
	_derpBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_derpBtn.frame = CGRectMake(0, 300, 155, 50);
	_derpBtn.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
	_derpBtn.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
	[_derpBtn setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[_derpBtn setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[_derpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	_derpBtn.titleLabel.shadowColor = [UIColor whiteColor];
	_derpBtn.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	[_derpBtn setTitle:@"take photo" forState:UIControlStateNormal];
	[_derpBtn addTarget:self action:@selector(_goModal) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_derpBtn];
}

-(void)viewDidLoad {
	[super viewDidLoad];
}

-(void)viewDidUnload {
	[super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

-(void)dealloc {
	[super dealloc];
}


#pragma mark - Presentation



#pragma mark - Navigation
-(void)_goBack {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)_goNext {
	[self.navigationController pushViewController:[[[DIChorePriceViewController alloc] initWithChore:_chore] autorelease] animated:YES];
}

-(void)_goTakePhoto {
	[_photoOverlayViewController.imgPickerController takePicture];
}

-(void)_goCancel {
	[self dismissModalViewControllerAnimated:YES];
}

-(void)_goModal {
	
	// w/ nav
	//DIHowDiddsWorkViewController *aboutPinCodeViewController = [[[DIHowDiddsWorkViewController alloc] initWithTitle:@"passcode" header:@"what is a passcode for?" closeLabel:@"Done"] autorelease];
	//UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:aboutPinCodeViewController] autorelease];
	//[self.navigationController presentModalViewController:navigationController animated:YES];
	
	// w/o nav
	//[self presentModalViewController:[[[DIHowDiddsWorkViewController alloc] init] autorelease] animated:YES];
	
	 if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		 
		 _photoOverlayViewController = [[[DIPhotoOverlayViewController alloc] init] autorelease];
		 _photoOverlayViewController.delegate = self;
		 //[_photoOverlayViewController startup];
		 
		 [_photoOverlayViewController setupImagePicker:UIImagePickerControllerSourceTypeCamera];
		 [self presentModalViewController:_photoOverlayViewController.imgPickerController animated:NO];
	 }
}

-(void)_goCamera {
	//[_imgPickerController dismissModalViewControllerAnimated:NO];
	

	 if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		_isCameraPic = YES;
		
		//[_previewImageController.view removeFromSuperview];
		
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
}

-(void)_goAlbum {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		_isCameraPic = NO;
		
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
		imagePicker.delegate = self;
		imagePicker.allowsEditing = YES;
		//imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
		
		[self presentModalViewController:imagePicker animated:YES];
		
	} else {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Photo roll not available." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alertView release];
	}
}

-(void)_goActionSheet {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"choose picture", @"take picture", nil];
	[actionSheet showInView:self.view];
	[actionSheet release];
}

#pragma mark - PhotoOverlay Delegates
// as a delegate we are being told a picture was taken
-(void)didTakePicture:(UIImage *)picture {
	_choreImgView.image = picture;
}

// as a delegate we are told to finished with the camera
-(void)didFinishWithCamera {
	[self dismissModalViewControllerAnimated:YES];
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
		_choreImgView.image = resizedImg;
		
		NSData *imageData = UIImagePNGRepresentation(resizedImg); 
		[[NSUserDefaults standardUserDefaults] setObject:imageData forKey:_chore.imgPath];
		
	} else {
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
		NSLog(@"%f, %f", image.size.width, image.size.height);
		
		_choreImgView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
		
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


@end
 
 
 
 */
