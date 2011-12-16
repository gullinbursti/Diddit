//
//  DIAchievement.h
//  Diddit
//
//  Created by Matthew Holcombe on 12.15.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DIAchievement : NSObject

+(DIAchievement *)achievementWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, retain) NSDictionary *dictionary;
@property (nonatomic) int achievement_id;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *info;
@property (nonatomic, retain) NSString *icoPath;
@property (nonatomic, retain) NSString *imgPath;

@end
