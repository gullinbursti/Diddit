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
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
	
	UIButton *thumbButton = [UIButton buttonWithType:UIButtonTypeCustom];
	thumbButton.frame = CGRectMake(10, 64, 58, 58);
	thumbButton.backgroundColor = [UIColor colorWithRed:1.0 green:0.988235294117647 blue:0.874509803921569 alpha:1.0];
	thumbButton.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0] CGColor];
	thumbButton.layer.borderWidth = 1.0;
	thumbButton.clipsToBounds = YES;
	thumbButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
	thumbButton.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
	thumbButton.imageEdgeInsets = UIEdgeInsetsMake(15.0, 12.0, -15.0, -12.0);
	[thumbButton setImage:[UIImage imageNamed:@"cameraIcon.png"] forState:UIControlStateNormal];
	[thumbButton addTarget:self action:@selector(_goCamera) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:thumbButton];
	
	
	UIImageView *choreImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choreThumb.png"]];
	CGRect frame = choreImgView.frame;
	frame.origin.x = 10;
	frame.origin.y = 55;
	choreImgView.frame = frame;
	[self.view addSubview:choreImgView];
	
	UILabel *choreTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 64, 200, 24)];
	choreTitleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:20];
	choreTitleLabel.textColor = [UIColor blackColor];
	choreTitleLabel.backgroundColor = [UIColor clearColor];
	choreTitleLabel.text = _chore.title;
	[self.view addSubview:choreTitleLabel];
	
	UILabel *choreInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 85, 200, 16)];
	choreInfoLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10];
	choreInfoLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
	choreInfoLabel.backgroundColor = [UIColor clearColor];
	choreInfoLabel.text = _chore.info;
	[self.view addSubview:choreInfoLabel];
	
	UIImageView *divider2ImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]];
	frame = divider2ImgView.frame;
	frame.origin.y = 143;
	divider2ImgView.frame = frame;
	[self.view addSubview:divider2ImgView];
	
	UILabel *rewardLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, 120, 16)];
	rewardLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10];
	rewardLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
	rewardLabel.backgroundColor = [UIColor clearColor];
	rewardLabel.text = @"Reward";
	[self.view addSubview:rewardLabel];
	
	_imgView = [[EGOImageView alloc] initWithFrame:CGRectMake(74, 164, 59, 59)];
	_imgView.imageURL = [NSURL URLWithString:_chore.icoPath];
	[self.view addSubview:_imgView];
	
	UIImageView *rewardImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"package.png"]];
	frame = rewardImgView.frame;
	frame.origin.x = 75;
	frame.origin.y = 158;
	rewardImgView.frame = frame;
	[self.view addSubview:rewardImgView];
	
	UILabel *rewardTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 172, 120, 20)];
	rewardTitleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:16];
	rewardTitleLabel.textColor = [UIColor blackColor];
	rewardTitleLabel.backgroundColor = [UIColor clearColor];
	rewardTitleLabel.text = [NSString stringWithFormat:@"%@ didds", _chore.disp_points];
	[self.view addSubview:rewardTitleLabel];
	
	UILabel *rewardPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 190, 100, 16)];
	rewardPriceLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10];
	rewardPriceLabel.textColor = [UIColor colorWithWhite:0.67 alpha:1.0];
	rewardPriceLabel.backgroundColor = [UIColor clearColor];
	rewardPriceLabel.text = _chore.price;
	[self.view addSubview:rewardPriceLabel];
	
	UIImageView *divider3ImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]];
	frame = divider3ImgView.frame;
	frame.origin.y = 251;
	divider3ImgView.frame = frame;
	[self.view addSubview:divider3ImgView];
	
	UILabel *xtraLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 260, 300, 40)];
	xtraLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	xtraLabel.textColor = [UIColor colorWithWhite:0.33 alpha:1.0];
	xtraLabel.backgroundColor = [UIColor clearColor];
	xtraLabel.numberOfLines = 0;
	xtraLabel.text = @"Claritas est etiam processus dynamicus qui sequitur et quinta decima mutationem. Decima typi qui.";
	[self.view addSubview:xtraLabel];
	
	UIImageView *calendarImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 300.0, 14, 14)] autorelease];
	calendarImgView.image = [UIImage imageNamed:@"cal_Icon.png"];
	[self.view addSubview:calendarImgView];
	
	UILabel *expiresLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 300, 200, 16)];
	expiresLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	expiresLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
	expiresLabel.backgroundColor = [UIColor clearColor];
	expiresLabel.text = [NSString stringWithFormat:@"Expires on %@", _chore.disp_expires];
	[self.view addSubview:expiresLabel];
	
	UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 348, 320, 72)];
	footerView.backgroundColor = [UIColor colorWithRed:0.2706 green:0.7804 blue:0.4549 alpha:1.0];
	[self.view addSubview:footerView];
	
	UIImageView *overlayImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]];
	frame = overlayImgView.frame;
	frame.origin.y = -44;
	overlayImgView.frame = frame;
	[self.view addSubview:overlayImgView];
		
	_submitButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_submitButton.frame = CGRectMake(0, 350, 320, 60);
	_submitButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
	_submitButton.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
	[_submitButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[_submitButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_submitButton setTitle:@"submit" forState:UIControlStateNormal];
	[_submitButton addTarget:self action:@selector(_goSubmit) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_submitButton];
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

#pragma mark - navigation
-(void)_goBack {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)_goCamera {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
		imagePicker.delegate = self;
		//imagePicker.allowsImageEditing = NO;
	
		[self presentModalViewController:imagePicker animated:YES];
	
	} else {
		UIAlertView *alertView;
		alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Camera not aviable." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	}
}

- (void)_goSubmit {
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
	
	ASIFormDataRequest *dataRequest = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://dev.gullinbursti.cc/projs/diddit/services/Chores.php"]] retain];
	[dataRequest setPostValue:[NSString stringWithFormat:@"%d", 7] forKey:@"action"];
	[dataRequest setPostValue:[[DIAppDelegate profileForUser] objectForKey:@"id"] forKey:@"userID"];
	[dataRequest setPostValue:_chore.title forKey:@"choreTitle"];
	[dataRequest setPostValue:_chore.info forKey:@"choreInfo"];
	[dataRequest setPostValue:[NSNumber numberWithFloat:_chore.cost] forKey:@"cost"];
	[dataRequest setPostValue:[dateFormat stringFromDate:_chore.expires] forKey:@"expires"];
	[dataRequest setDelegate:self];
	[dataRequest startAsynchronous];
	
	[dateFormat release];
}


#pragma mark - ImagePicker Delegates
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	
	UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
	[picker release];
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
	UIAlertView *alert;
	
	if (error)
		alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to save image to Photo Album." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	
	else 
		alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Image saved to Photo Album." delegate:nil cancelButtonTitle:@"Ok"  otherButtonTitles:nil];
	
	[alert show];
	[alert release];
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
}

-(void)requestFailed:(ASIHTTPRequest *)request {
}

@end
