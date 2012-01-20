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
	
	/*if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		_previewImageController = [[UIImagePickerController alloc] init];
		_previewImageController.sourceType =  UIImagePickerControllerSourceTypeCamera;
		_previewImageController.delegate = nil;
		_previewImageController.allowsEditing = NO;
		//[_choreImgView addSubview:_previewImageController.view];
	}*/
	
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

-(void)_goActionSheet {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"choose picture", @"take picture", nil];
	[actionSheet showInView:self.view];
	[actionSheet release];
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
