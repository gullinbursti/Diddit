//
//  DIAppDelegate.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.13.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

//http://itunes.apple.com/us/app/id482769629?mt=8

#import <UIKit/UIKit.h>

#import "DIChoreListViewController.h"
#import "ASIFormDataRequest.h"

#import "DILoadOverlayView.h"

@interface DIAppDelegate : UIResponder <UIApplicationDelegate, ASIHTTPRequestDelegate> {
	
	DIChoreListViewController *_choreListViewController;
	ASIFormDataRequest *_userRequest;
	
	DILoadOverlayView *_loadOverlayView;
}

@property (strong, nonatomic) UIWindow *window;

+(DIAppDelegate *)sharedInstance;

+(void)setUserProfile:(NSDictionary *)userInfo;
+(NSDictionary *)profileForUser;

+(void)setDeviceToken:(NSString *)token;
+(NSString *)deviceToken;

+(void)setUserPoints:(int)points;
+(int)userPoints;

+(void)setUserTotalFinshed:(int)total;
+(int)userTotalFinished;

+(void)notificationsToggle:(BOOL)isOn;
+(BOOL)notificationsEnabled;

+(NSString *)md5:(NSString *)input;


+(UIFont *)diAdelleFontRegular;
+(UIFont *)diAdelleFontLight;
+(UIFont *)diAdelleFontSemibold;
+(UIFont *)diAdelleFontBold;
+(UIFont *)diAdelleFontBoldItalic;
+(UIFont *)diHelveticaNeueFontBold;

-(void)showSettingsScreen;

@end
