//
//  DIAppDelegate.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.13.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

//http://itunes.apple.com/us/app/id482769629?mt=8

#import <UIKit/UIKit.h>

#import "DIStartupViewController.h"
#import "DIMasterListViewController.h"
#import "DISubListViewController.h"
#import "ASIFormDataRequest.h"

#import "DILoadOverlay.h"
#import "UAPushNotificationHandler.h"

@interface DIAppDelegate : UIResponder <UIApplicationDelegate, ASIHTTPRequestDelegate, UAPushNotificationDelegate> {
	
	DIStartupViewController *_startupViewController;
	DIMasterListViewController *_masterListViewController;
	DISubListViewController *_subListViewController;
	
	ASIFormDataRequest *_userRequest;
	
	DILoadOverlay *_loadOverlay;
}

@property (strong, nonatomic) UIWindow *window;

#define kServerPath @"http://dev.gullinbursti.cc/projs/diddit/services"

+(DIAppDelegate *)sharedInstance;

+(BOOL)validateEmail:(NSString *)address;
+(NSString *)md5:(NSString *)input;
+(NSString *)rndChars:(int)len;

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

+(void)setCompletedOffers:(NSDictionary *)offers;
+(NSDictionary *)completedOffers;

+(NSString *)deviceUUID;
+(BOOL)isParentApp;
+(NSArray *)childDevices;

+(UIFont *)diAdelleFontRegular;
+(UIFont *)diAdelleFontLight;
+(UIFont *)diAdelleFontSemibold;
+(UIFont *)diAdelleFontBold;
+(UIFont *)diAdelleFontBoldItalic;
+(UIFont *)diHelveticaNeueFontBold;

+(UIFont *)diOpenSansFontRegular;
+(UIFont *)diOpenSansFontSemibold;
+(UIFont *)diOpenSansFontBold;


+(UIColor *)diColor333333;
+(UIColor *)diColor5D5D5D;
+(UIColor *)diColor666666;
+(UIColor *)diColor40AC61;

@end
