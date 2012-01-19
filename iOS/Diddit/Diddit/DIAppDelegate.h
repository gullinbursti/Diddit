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

#import "DILoadOverlay.h"
#import "UAPushNotificationHandler.h"

@interface DIAppDelegate : UIResponder <UIApplicationDelegate, ASIHTTPRequestDelegate, UAPushNotificationDelegate> {
	
	DIChoreListViewController *_choreListViewController;
	ASIFormDataRequest *_userRequest;
	
	DILoadOverlay *_loadOverlay;
}

@property (strong, nonatomic) UIWindow *window;

+(DIAppDelegate *)sharedInstance;

+(BOOL)validateEmail:(NSString *)address;

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

+(NSString *)md5:(NSString *)input;


+(UIFont *)diAdelleFontRegular;
+(UIFont *)diAdelleFontLight;
+(UIFont *)diAdelleFontSemibold;
+(UIFont *)diAdelleFontBold;
+(UIFont *)diAdelleFontBoldItalic;
+(UIFont *)diHelveticaNeueFontBold;

@end
