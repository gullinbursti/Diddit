//
//  DIAddChoreTitleViewController.h
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIChore.h"

@interface DIAddChoreTitleViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate> {
	
	UITextField *_titleTxtField;
	UITextView *_infoTxtView;
	
	UILabel *_titleLbl;
	UILabel *_infoLbl;
	
	DIChore *_chore;
}

-(id)initWithChore:(DIChore *)chore;

@end
