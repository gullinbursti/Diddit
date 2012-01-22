//
//  DIPhotoOverlayViewController.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.20.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIPhotoOverlayViewController.h"
#import "DIAppDelegate.h"

@implementation DIPhotoOverlayViewController

@synthesize delegate;
@synthesize imgPickerController = _imgPickerController;

#pragma mark - View lifecycle
-(id)init {
	if ((self = [super init])) {
		_imgPickerController = [[UIImagePickerController alloc] init];
		_imgPickerController.delegate = self;
	}
	
	return (self);
}

-(void)loadView {
	[super loadView];
	
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



-(void)startup {
}


-(void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType {
	
	_imgPickerController.sourceType = sourceType;
	
	_footerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 425, 320, 54)];
	_footerImgView.image = [UIImage imageNamed:@"cameraFooterBG.png"];
	[self.view addSubview:_footerImgView];
	
	_takePhotoBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_takePhotoBtn.frame = CGRectMake(0, 430, 155, 50);
	_takePhotoBtn.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
	_takePhotoBtn.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
	[_takePhotoBtn setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[_takePhotoBtn setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[_takePhotoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	_takePhotoBtn.titleLabel.shadowColor = [UIColor whiteColor];
	_takePhotoBtn.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	[_takePhotoBtn setTitle:@"take photo" forState:UIControlStateNormal];
	[_takePhotoBtn addTarget:self.delegate action:@selector(_goTakePhoto) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_takePhotoBtn];
	
	_cancelBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	_cancelBtn.frame = CGRectMake(165, 430, 155, 50);
	_cancelBtn.titleLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:22.0];
	_cancelBtn.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
	[_cancelBtn setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_nonActive.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	[_cancelBtn setBackgroundImage:[[UIImage imageNamed:@"subSectionButton_Active.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	_cancelBtn.titleLabel.shadowColor = [UIColor whiteColor];
	_cancelBtn.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
	[_cancelBtn setTitle:@"cancel" forState:UIControlStateNormal];
	[_cancelBtn addTarget:self.delegate action:@selector(_goCancel) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_cancelBtn];
	
	if (sourceType == UIImagePickerControllerSourceTypeCamera) {
		// user wants to use the camera interface
		_imgPickerController.showsCameraControls = NO;
		
		if ([[_imgPickerController.cameraOverlayView subviews] count] == 0) {
			// setup our custom overlay view for the camera
			// ensure that our custom view's frame fits within the parent frame
			CGRect overlayViewFrame = self.imgPickerController.cameraOverlayView.frame;
			CGRect newFrame = CGRectMake(0.0, CGRectGetHeight(overlayViewFrame) - self.view.frame.size.height - 10.0, CGRectGetWidth(overlayViewFrame), self.view.frame.size.height + 10.0);
			
			self.view.frame = newFrame;
			self.view.frame = CGRectMake(0, 0, 320, 480);
			[_imgPickerController.cameraOverlayView addSubview:self.view];
		}
	}
}


-(void)_finishAndUpdate {
	[self.delegate didFinishWithCamera];  // tell our delegate we are done with the camera
	
	// restore the state of our overlay toolbar buttons
	_cancelBtn.enabled = YES;
	_takePhotoBtn.enabled = YES;
}


-(void)_takePhoto {
	[_imgPickerController takePicture];
}

-(void)_goBack {
	[self.delegate didFinishWithCamera];
}


// this get called when an image has been chosen from the library or taken from the camera
//
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
	
	// give the taken picture to our delegate
	if (self.delegate)
		[self.delegate didTakePicture:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self.delegate didFinishWithCamera];    // tell our delegate we are finished with the picker
}



@end
