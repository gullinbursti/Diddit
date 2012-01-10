//
//  DIReward.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.07.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DIReward : NSObject

+(DIReward *)rewardWithDictionary:(NSDictionary *)dictionary;
-(NSString *)price;
-(NSString *)disp_points;

@property (nonatomic, retain) NSDictionary *dictionary;
@property (nonatomic) int reward_id;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *info;
@property (nonatomic, retain) NSString *ico_url;
@property (nonatomic) int points;
@property (nonatomic, ) float cost;

@end
