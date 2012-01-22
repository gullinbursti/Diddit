//
//  DIPhotoOverlayViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.20.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

@protocol DIPhotoOverlayControllerDelegate;


@interface DIPhotoOverlayViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
	
	id <DIPhotoOverlayControllerDelegate> delegate;
	
	UIImagePickerController *_imgPickerController;
	UIImageView *_footerImgView;
	
	UIButton *_takePhotoBtn;
	UIButton *_useRollBtn;
	UIButton *_cancelBtn;
	
	 SystemSoundID tickSound;
}

-(void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType;
-(void)startup;

@property (nonatomic, assign) id <DIPhotoOverlayControllerDelegate> delegate;
@property (nonatomic, retain) UIImagePickerController *imgPickerController;


@end

@protocol DIPhotoOverlayControllerDelegate
-(void)didTakePicture:(UIImage *)picture;
-(void)didFinishWithCamera;
-(void)goCancel;
@end