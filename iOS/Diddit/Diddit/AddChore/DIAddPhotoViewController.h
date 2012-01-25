//
//  DIAddPhotoViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.19.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "DIBasePushHeaderViewController.h"
#import "DIAppDelegate.h"
#import "DIChore.h"

@interface DIAddPhotoViewController : DIBasePushHeaderViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate> {
	BOOL _isCameraPic;
	DIChore *_chore;
	UIImageView *_choreImgView;
	UIImagePickerController *_previewImageController;
	
	UITableView *_photoTypeTableView;
	NSMutableArray *_types;
}

-(id)initWithChore:(DIChore *)chore;

@end


/*


//
//  DIAddPhotoViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.19.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "DIBasePushHeaderViewController.h"
#import "DIAppDelegate.h"
#import "DIChore.h"

#import "DIPhotoOverlayViewController.h"

@interface DIAddPhotoViewController : DIBasePushHeaderViewController <DIPhotoOverlayControllerDelegate> {
	BOOL _isCameraPic;
	DIChore *_chore;
	UIImageView *_choreImgView;
	UIImagePickerController *_imgPickerController;
	UIImageView *_footerImgView;
	
	UIButton *_derpBtn;
	
	DIPhotoOverlayViewController *_photoOverlayViewController;
}

-(id)initWithChore:(DIChore *)chore;

@end


*/