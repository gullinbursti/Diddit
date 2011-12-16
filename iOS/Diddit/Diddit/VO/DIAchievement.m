//
//  DIAchievement.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.15.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import "DIAchievement.h"

@implementation DIAchievement

@synthesize dictionary;
@synthesize achievement_id, title, info, icoPath, imgPath;

+(DIAchievement *)achievementWithDictionary:(NSDictionary *)dictionary {
	DIAchievement *achievement = [[DIAchievement alloc] init];
	
	achievement.dictionary = dictionary;
	
	achievement.achievement_id = [[dictionary objectForKey:@"id"] intValue];
	achievement.title = [dictionary objectForKey:@"title"];
	achievement.info = [dictionary objectForKey:@"info"];
	achievement.icoPath = [dictionary objectForKey:@"icoPath"];
	achievement.imgPath = [dictionary objectForKey:@"imgPath"];
	
	return (achievement);
}

-(void)dealloc {
	
	self.dictionary = nil;
	self.title = nil;
	self.info = nil;
	self.icoPath = nil;
	self.imgPath = nil;
	
	[super dealloc];
}

@end
