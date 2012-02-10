//
//  DISignupPhotoViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 02.09.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DISignupPhotoViewController.h"

#import "DIAppDelegate.h"

@implementation DISignupPhotoViewController

#pragma mark - View lifecycle
-(id)initWithType:(int)type withUsername:(NSString *)username {
	if ((self = [super init])) {
		_type = type;
		_username = username;
		_isCameraPic = NO;
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	UIImageView *bgImgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fue_background.jpg"]] autorelease];
	[self.view addSubview:bgImgView];
	
	UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 40, 280.0, 20)] autorelease];
	titleLabel.font = [[DIAppDelegate diAdelleFontSemibold] fontWithSize:16.0];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textColor = [DIAppDelegate diColor333333];
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.text = @"upload a photo";
	
	UIButton *photoButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	photoButton.frame = CGRectMake(115, 150, 99, 54.0);
	[photoButton setBackgroundImage:[[UIImage imageNamed:@"submitUserButton_nonActive.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
	[photoButton setBackgroundImage:[[UIImage imageNamed:@"submitUserButton_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateSelected];
	[photoButton addTarget:self action:@selector(_goActionSheet) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:photoButton];
	
	UIButton *skipButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	skipButton.frame = CGRectMake(115, 261, 99, 54.0);
	[skipButton setBackgroundImage:[[UIImage imageNamed:@"submitUserButton_nonActive.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
	[skipButton setBackgroundImage:[[UIImage imageNamed:@"submitUserButton_Active.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateSelected];
	skipButton.titleLabel.font = [[DIAppDelegate diOpenSansFontBold] fontWithSize:16.0];
	skipButton.titleLabel.shadowColor = [UIColor blackColor];
	skipButton.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
	skipButton.titleEdgeInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
	[skipButton setTitleColor:[DIAppDelegate diColor666666] forState:UIControlStateNormal];
	[skipButton setTitleColor:[DIAppDelegate diColor666666] forState:UIControlStateSelected];
	[skipButton setTitle:@"Skip this" forState:UIControlStateNormal];
	[skipButton addTarget:self action:@selector(_goNext) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:skipButton];
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

#pragma mark - Navigation
-(void)_goActionSheet {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"choose picture", @"take picture", nil];
	[actionSheet showInView:self.view];
	[actionSheet release];
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

-(void)_goNext {
	
	if (![DIAppDelegate deviceToken])
		[DIAppDelegate setDeviceToken:[NSString stringWithFormat:@"%064d", 0]];
	
	_loadOverlay = [[DILoadOverlay alloc] init];
	ASIFormDataRequest *signupDataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Users.php"]] retain];
	[signupDataRequest setPostValue:[NSString stringWithFormat:@"%d", 0] forKey:@"action"];
	[signupDataRequest setPostValue:[DIAppDelegate deviceUUID] forKey:@"uuID"];
	[signupDataRequest setPostValue:[UIDevice currentDevice].model forKey:@"model"];
	[signupDataRequest setPostValue:[UIDevice currentDevice].systemVersion forKey:@"os"];
	[signupDataRequest setPostValue:[DIAppDelegate deviceToken] forKey:@"uaID"];
	[signupDataRequest setPostValue:[UIDevice currentDevice].name forKey:@"deviceName"];
	[signupDataRequest setPostValue:_username forKey:@"username"];
	[signupDataRequest setPostValue:@"000" forKey:@"pin"];
	
	if (_type == 1 || _type == 2)
		[signupDataRequest setPostValue:@"Y" forKey:@"master"];
	
	else
		[signupDataRequest setPostValue:@"N" forKey:@"master"];
	
	[signupDataRequest setDelegate:self];
	[signupDataRequest startAsynchronous];
}


#pragma mark ActionSheet Delegates
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0:
			[self _goAlbum];
			break;
			
		case 1:
			[self _goCamera];
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
	_photoDate = [dateFormat stringFromDate:[NSDate date]];
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
		image = resizedImg;
		
		NSData *imageData = UIImagePNGRepresentation(resizedImg); 
		[[NSUserDefaults standardUserDefaults] setObject:imageData forKey:_photoDate];
		
	} else {
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
		NSLog(@"%f, %f", image.size.width, image.size.height);
		
		image = [info objectForKey:UIImagePickerControllerOriginalImage];
		
		NSData *imageData = UIImagePNGRepresentation(image); 
		[[NSUserDefaults standardUserDefaults] setObject:imageData forKey:_photoDate];
	}
	
	
	NSLog(@"IMG:[%@]", _photoDate);
	[self _goNext];
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


#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	
	NSLog(@"[_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
	@autoreleasepool {
		NSError *error = nil;
		NSDictionary *parsedUser = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
		
		if (error != nil)
			NSLog(@"Failed to parse job list JSON: %@", [error localizedFailureReason]);
		
		else {
			NSLog(@"NEW USER: %@", parsedUser);
			[DIAppDelegate setUserProfile:parsedUser];
		}
	}
	
	NSLog(@"USER ID:[%@]", [[DIAppDelegate profileForUser] objectForKey:@"id"]);
	
	[_loadOverlay remove];
	[self dismissViewControllerAnimated:YES completion:^(void) {
		
		if (_type == 1)
			[[NSNotificationCenter defaultCenter] postNotificationName:@"PRESENT_MASTER_LIST" object:nil];
		
		else
			[[NSNotificationCenter defaultCenter] postNotificationName:@"PRESENT_SUB_LIST" object:nil];
	}];
}


-(void)requestFailed:(ASIHTTPRequest *)request {
	[_loadOverlay remove];
	
	//[_delegates perform:@selector(jobList:didFailLoadWithError:) withObject:self withObject:request.error];
	//MBL_RELEASE_SAFELY(_jobListRequest);
}
@end
