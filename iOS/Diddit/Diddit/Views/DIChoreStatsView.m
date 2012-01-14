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

@synthesize ptsBtn = _ptsBtn;
@synthesize totBtn = _totBtn;

-(id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		UILabel *diddsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(3, 7, 60, 26)] autorelease];
		diddsLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:10];
		diddsLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
		diddsLabel.backgroundColor = [UIColor clearColor];
		diddsLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
		diddsLabel.shadowOffset = CGSizeMake(1.0, 1.0);
		diddsLabel.text = @"DIDDS";
		[self addSubview:diddsLabel];
		
		_ptsBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		_ptsBtn.frame = CGRectMake(43, 2, 59, 34);
		_ptsBtn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10.0];
		//_ptsBtn.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
		[_ptsBtn setBackgroundImage:[[UIImage imageNamed:@"headerDiddsBG.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
		[_ptsBtn setBackgroundImage:[[UIImage imageNamed:@"headerDiddsBG.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateSelected];
		[_ptsBtn setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.0] forState:UIControlStateNormal];
		[_ptsBtn setTitle:[NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:[DIAppDelegate userPoints]] numberStyle:NSNumberFormatterDecimalStyle] forState:UIControlStateNormal];
		[_ptsBtn setEnabled:NO];
		[self addSubview:_ptsBtn];
		
		UILabel *choresLabel = [[[UILabel alloc] initWithFrame:CGRectMake(112, 7, 60, 26)] autorelease];
		choresLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:10];
		choresLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
		choresLabel.backgroundColor = [UIColor clearColor];
		choresLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
		choresLabel.shadowOffset = CGSizeMake(1.0, 1.0);
		choresLabel.text = @"CHORES";
		[self addSubview:choresLabel];
		
		_totBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		_totBtn.frame = CGRectMake(160, 2, 39, 34);
		_totBtn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10.0];
		[_totBtn setBackgroundImage:[[UIImage imageNamed:@"headerChoresBG.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
		[_totBtn setBackgroundImage:[[UIImage imageNamed:@"headerChoresBG.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateSelected];
		[_totBtn setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.0] forState:UIControlStateNormal];
		[_totBtn setTitle:[NSString stringWithFormat:@"%d", [DIAppDelegate userTotalFinished]] forState:UIControlStateNormal];
		[_totBtn setEnabled:NO];
		[self addSubview:_totBtn];
	}
	
	return (self);
}

-(id)init {
	if ((self = [super init])) {
		UILabel *diddsLabel = [[[UILabel alloc] initWithFrame:CGRectMake(3, 7, 60, 26)] autorelease];
		diddsLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:10];
		diddsLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
		diddsLabel.backgroundColor = [UIColor clearColor];
		diddsLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
		diddsLabel.shadowOffset = CGSizeMake(1.0, 1.0);
		diddsLabel.text = @"DIDDS";
		[self addSubview:diddsLabel];
		
		_ptsBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		_ptsBtn.frame = CGRectMake(43, 2, 59, 34);
		_ptsBtn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10.0];
		//_ptsBtn.titleEdgeInsets = UIEdgeInsetsMake(2, 0, -2, 0);
		[_ptsBtn setBackgroundImage:[[UIImage imageNamed:@"hudHeaderBG.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
		[_ptsBtn setBackgroundImage:[[UIImage imageNamed:@"hudHeaderBG.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateSelected];
		[_ptsBtn setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.0] forState:UIControlStateNormal];
		[_ptsBtn setTitle:[NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:[DIAppDelegate userPoints]] numberStyle:NSNumberFormatterDecimalStyle] forState:UIControlStateNormal];
		[self addSubview:_ptsBtn];
		
		UILabel *choresLabel = [[[UILabel alloc] initWithFrame:CGRectMake(112, 7, 60, 26)] autorelease];
		choresLabel.font = [[DIAppDelegate diAdelleFontBold] fontWithSize:10];
		choresLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
		choresLabel.backgroundColor = [UIColor clearColor];
		choresLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
		choresLabel.shadowOffset = CGSizeMake(1.0, 1.0);
		choresLabel.text = @"CHORES";
		[self addSubview:choresLabel];
		
		_totBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		_totBtn.frame = CGRectMake(160, 2, 38, 34);
		_totBtn.titleLabel.font = [[DIAppDelegate diHelveticaNeueFontBold] fontWithSize:10.0];
		[_totBtn setBackgroundImage:[[UIImage imageNamed:@"hudHeaderBG.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateNormal];
		[_totBtn setBackgroundImage:[[UIImage imageNamed:@"hudHeaderBG.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0] forState:UIControlStateSelected];
		[_totBtn setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.0] forState:UIControlStateNormal];
		[_totBtn setTitle:[NSString stringWithFormat:@"%d", [DIAppDelegate userTotalFinished]] forState:UIControlStateNormal];
		[self addSubview:_totBtn];
		
	}
	
	return (self);
}


-(void)dealloc {
	[_ptsBtn release];
	[_totBtn release];
	
	[super dealloc];
}


@end
