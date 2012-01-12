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
	[super loadBaseView];
	
	[self.view setBackgroundColor:[UIColor colorWithRed:0.988235294117647 green:0.988235294117647 blue:0.713725490196078 alpha:1.0]];
	CGRect frame;
	
	CGSize textSize = [_chore.info sizeWithFont:[[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12] constrainedToSize:CGSizeMake(300.0, CGFLOAT_MAX) lineBreakMode:UILineBreakModeClip];
	
	UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
	[self.view addSubview:bgImgView];
	
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 392)];
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	scrollView.contentSize = CGSizeMake(320, 300 + textSize.height);
	scrollView.opaque = NO;
	scrollView.scrollsToTop = NO;
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = YES;
	scrollView.alwaysBounceVertical = NO;
	[self.view addSubview:scrollView];
	
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
	headerView.backgroundColor = [UIColor colorWithRed:0.988235294117647 green:0.988235294117647 blue:0.713725490196078 alpha:1.0];
	[scrollView addSubview:headerView];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 20)];
	titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:16];
	titleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	titleLabel.text = _headerTxt;
	titleLabel.textAlignment = UITextAlignmentCenter;
	[scrollView addSubview:titleLabel];
	
	UIImageView *dividerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]];
	frame = dividerImgView.frame;
	frame.origin.y = 48;
	dividerImgView.frame = frame;
	[scrollView addSubview:dividerImgView];
	
	_choreThumbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	_choreThumbBtn.frame = CGRectMake(10, 64, 58, 58);
	_choreThumbBtn.backgroundColor = [UIColor colorWithRed:1.0 green:0.988235294117647 blue:0.874509803921569 alpha:1.0];
	_choreThumbBtn.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0] CGColor];
	_choreThumbBtn.layer.borderWidth = 1.0;
	_choreThumbBtn.clipsToBounds = YES;
	_choreThumbBtn.imageEdgeInsets = UIEdgeInsetsMake(15.0, 12.0, -15.0, -12.0);
	[_choreThumbBtn setImage:[UIImage imageNamed:@"cameraIcon.png"] forState:UIControlStateNormal];
	[_choreThumbBtn addTarget:self action:@selector(_goCamera) forControlEvents:UIControlEventTouchUpInside];
	[scrollView addSubview:_choreThumbBtn];
	
	
	UIImageView *choreImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choreThumb.png"]];
	frame = choreImgView.frame;
	frame.origin.x = 10;
	frame.origin.y = 55;
	choreImgView.frame = frame;
	[scrollView addSubview:choreImgView];
	
	UILabel *choreTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 83, 200, 24)];
	choreTitleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:20];
	choreTitleLabel.textColor = [UIColor blackColor];
	choreTitleLabel.backgroundColor = [UIColor clearColor];
	choreTitleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	choreTitleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	choreTitleLabel.text = _chore.title;
	[scrollView addSubview:choreTitleLabel];
	
	UIImageView *divider2ImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]];
	frame = divider2ImgView.frame;
	frame.origin.y = 143;
	divider2ImgView.frame = frame;
	[scrollView addSubview:divider2ImgView];
	
	UILabel *rewardLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, 120, 16)];
	rewardLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	rewardLabel.textColor = [UIColor colorWithWhite:0.33 alpha:1.0];
	rewardLabel.backgroundColor = [UIColor clearColor];
	rewardLabel.text = @"Reward";
	[scrollView addSubview:rewardLabel];
	
	_imgView = [[EGOImageView alloc] initWithFrame:CGRectMake(74, 164, 59, 59)];
	_imgView.imageURL = [NSURL URLWithString:_chore.icoPath];
	[scrollView addSubview:_imgView];
	
	UILabel *rewardTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(144, 172, 120, 20)];
	rewardTitleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:16];
	rewardTitleLabel.textColor = [UIColor blackColor];
	rewardTitleLabel.backgroundColor = [UIColor clearColor];
	rewardTitleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	rewardTitleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	rewardTitleLabel.text = [NSString stringWithFormat:@"%@ didds", _chore.disp_points];
	[scrollView addSubview:rewardTitleLabel];
	
	UILabel *rewardPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(144, 190, 100, 16)];
	rewardPriceLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:11];
	rewardPriceLabel.textColor = [UIColor colorWithWhite:0.67 alpha:1.0];
	rewardPriceLabel.backgroundColor = [UIColor clearColor];
	rewardPriceLabel.text = _chore.price;
	[scrollView addSubview:rewardPriceLabel];
	
	UIImageView *divider3ImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainListDivider.png"]];
	frame = divider3ImgView.frame;
	frame.origin.y = 251;
	divider3ImgView.frame = frame;
	[scrollView addSubview:divider3ImgView];
	
	UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 267, 300, textSize.height)];
	infoLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	infoLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
	infoLabel.backgroundColor = [UIColor clearColor];
	infoLabel.numberOfLines = 0;
	infoLabel.text = _chore.info;
	[scrollView addSubview:infoLabel];
	
	if (textSize.height == 0)
		textSize.height = -10;
	
	UIImageView *calendarImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 282.0 + textSize.height, 14, 14)] autorelease];
	calendarImgView.image = [UIImage imageNamed:@"cal_Icon.png"];
	[scrollView addSubview:calendarImgView];
	
	UILabel *expiresLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 282 + textSize.height, 200, 16)];
	expiresLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:12];
	expiresLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
	expiresLabel.backgroundColor = [UIColor clearColor];
	expiresLabel.text = [NSString stringWithFormat:@"Expires on %@", _chore.disp_expires];
	[scrollView addSubview:expiresLabel];
	
	UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 348, 320, 72)];
	footerView.backgroundColor = [UIColor colorWithRed:0.2706 green:0.7804 blue:0.4549 alpha:1.0];
	[self.view addSubview:footerView];
			
	_submitButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_submitButton.frame = CGRectMake(0, 352, 320, 60);
	_submitButton.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
	_submitButton.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
	[_submitButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[_submitButton setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_submitButton setTitle:@"submit" forState:UIControlStateNormal];
	[_submitButton addTarget:self action:@selector(_goSubmit) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_submitButton];
	
	UIImageView *overlayImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"overlay.png"]];
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
		imagePicker.allowsEditing = YES;
		//imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
	
		[self presentModalViewController:imagePicker animated:YES];
	
	} else {
		UIAlertView *alertView;
		alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Camera not aviable." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	}
}

- (void)_goSubmit {
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
	
	_loadOverlayView = [[DILoadOverlayView alloc] init];
	[_loadOverlayView toggle:YES];
	
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
	
	//[picker release];
	NSLog(@"info:[%@]", info);
	
	//NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	[self dismissModalViewControllerAnimated:YES];
	
	//if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
		[_choreThumbBtn setImage:image forState:UIControlStateNormal];
		_choreThumbBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
	
		UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
		
	//if (newMedia)
	//UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
	
	//} else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
	//}
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

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark - ASI Delegates
-(void)requestFinished:(ASIHTTPRequest *)request { 
	//NSLog(@"[_asiFormRequest responseString]=\n%@\n\n", [request responseString]);
	
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
	
	[_loadOverlayView toggle:NO];
}

-(void)requestFailed:(ASIHTTPRequest *)request {
	[_loadOverlayView toggle:NO];
}

@end
