//
//  DIApp.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.14.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DIApp : NSObject

+(DIApp *)appWithDictionary:(NSDictionary *)dictionary;
-(NSString *)disp_points;

@property (nonatomic, retain) NSDictionary *dictionary;
@property (nonatomic) int app_id;
@property (nonatomic) int type_id;
@property (nonatomic, retain) NSString *itunes_id;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *info;
@property (nonatomic) int points;
@property (nonatomic) int score;
@property (nonatomic, retain) NSString *ico_url;
@property (nonatomic, retain) NSString *img_url;
@property (nonatomic, retain) NSString *app_info;
@property (nonatomic, retain) NSDictionary *images;

@end
