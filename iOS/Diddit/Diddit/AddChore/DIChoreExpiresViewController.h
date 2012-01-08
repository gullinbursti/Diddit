//
//  DIChoreExpiresViewController.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.07.12.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DIChore.h"
#import "DIBasePushHeaderViewController.h"

@interface DIChoreExpiresViewController : DIBasePushHeaderViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	DIChore *_chore;
	UILabel *_daysLabel;
	
	UIPickerView *_pickerView;
	NSMutableArray *_daysArray;
	int _hours;
}

-(id)initWithChore:(DIChore *)chore;

@end
