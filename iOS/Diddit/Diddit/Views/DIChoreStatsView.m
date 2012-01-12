//
//  DIChoreStatsView.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.10.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIAppDelegate.h"

#import "DIChoreStatsView.h"

@implementation DIChoreStatsView


-(id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		UILabel *diddsLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 7, 60, 26)];
		diddsLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:10];
		diddsLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
		diddsLabel.backgroundColor = [UIColor clearColor];
		diddsLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
		diddsLabel.shadowOffset = CGSizeMake(1.0, 1.0);
		diddsLabel.text = @"DIDDS";
		[self addSubview:diddsLabel];
		
		UIButton *pointsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		pointsButton.frame = CGRectMake(43, 2, 59, 34);
		pointsButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10.0];
		//pointsButton.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
		[pointsButton setBackgroundImage:[[UIImage imageNamed:@"hudHeaderBG.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
		[pointsButton setBackgroundImage:[[UIImage imageNamed:@"hudHeaderBG.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateSelected];
		[pointsButton setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.0] forState:UIControlStateNormal];
		[pointsButton setTitle:[NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:[DIAppDelegate userPoints]] numberStyle:NSNumberFormatterDecimalStyle] forState:UIControlStateNormal];
		[self addSubview:pointsButton];
		
		UILabel *choresLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 7, 60, 26)];
		choresLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:10];
		choresLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
		choresLabel.backgroundColor = [UIColor clearColor];
		choresLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
		choresLabel.shadowOffset = CGSizeMake(1.0, 1.0);
		choresLabel.text = @"CHORES";
		[self addSubview:choresLabel];
		
		UIButton *finishedButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		finishedButton.frame = CGRectMake(160, 2, 38, 34);
		finishedButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10.0];
		[finishedButton setBackgroundImage:[[UIImage imageNamed:@"hudHeaderBG.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
		[finishedButton setBackgroundImage:[[UIImage imageNamed:@"hudHeaderBG.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateSelected];
		[finishedButton setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.0] forState:UIControlStateNormal];
		[finishedButton setTitle:[NSString stringWithFormat:@"%d", [DIAppDelegate userTotalFinished]] forState:UIControlStateNormal];
		[self addSubview:finishedButton];
	}
	
	return (self);
}

-(id)init {
	if ((self = [super init])) {
		UILabel *diddsLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 7, 60, 26)];
		diddsLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:10];
		diddsLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
		diddsLabel.backgroundColor = [UIColor clearColor];
		diddsLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
		diddsLabel.shadowOffset = CGSizeMake(1.0, 1.0);
		diddsLabel.text = @"DIDDS";
		[self addSubview:diddsLabel];
		
		UIButton *pointsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		pointsButton.frame = CGRectMake(43, 2, 59, 34);
		pointsButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10.0];
		//pointsButton.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
		[pointsButton setBackgroundImage:[[UIImage imageNamed:@"hudHeaderBG.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
		[pointsButton setBackgroundImage:[[UIImage imageNamed:@"hudHeaderBG.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateSelected];
		[pointsButton setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.0] forState:UIControlStateNormal];
		[pointsButton setTitle:[NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:[DIAppDelegate userPoints]] numberStyle:NSNumberFormatterDecimalStyle] forState:UIControlStateNormal];
		[self addSubview:pointsButton];
		
		UILabel *choresLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 7, 60, 26)];
		choresLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:10];
		choresLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
		choresLabel.backgroundColor = [UIColor clearColor];
		choresLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
		choresLabel.shadowOffset = CGSizeMake(1.0, 1.0);
		choresLabel.text = @"CHORES";
		[self addSubview:choresLabel];
		
		UIButton *finishedButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		finishedButton.frame = CGRectMake(160, 2, 38, 34);
		finishedButton.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10.0];
		[finishedButton setBackgroundImage:[[UIImage imageNamed:@"hudHeaderBG.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
		[finishedButton setBackgroundImage:[[UIImage imageNamed:@"hudHeaderBG.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateSelected];
		[finishedButton setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.0] forState:UIControlStateNormal];
		[finishedButton setTitle:[NSString stringWithFormat:@"%d", [DIAppDelegate userTotalFinished]] forState:UIControlStateNormal];
		[self addSubview:finishedButton];
		
	}
	
	return (self);
}


-(void)dealloc {
	[super dealloc];
}


@end
