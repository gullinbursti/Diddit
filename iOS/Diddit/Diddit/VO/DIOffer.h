//
//  DIOffer.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.08.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DIOffer : NSObject

+(DIOffer *)offerWithDictionary:(NSDictionary *)dictionary;
-(NSString *)disp_points;

@property (nonatomic, retain) NSDictionary *dictionary;
@property (nonatomic) int offer_id;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *app_name;
@property (nonatomic, retain) NSString *info;
@property (nonatomic) int points;
@property (nonatomic, retain) NSString *ico_url;
@property (nonatomic, retain) NSString *img_url;
@property (nonatomic, retain) NSString *video_url;
@property (nonatomic, retain) NSString *itunes_id;


@end
