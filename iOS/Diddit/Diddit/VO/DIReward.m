//
//  DIReward.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.07.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIReward.h"

@implementation DIReward

@synthesize dictionary;

@synthesize reward_id;
@synthesize title;
@synthesize info;
@synthesize points;
@synthesize cost;

+(DIReward *)rewardWithDictionary:(NSDictionary *)dictionary {
	
	DIReward *reward = [[DIReward alloc] init];
	reward.dictionary = dictionary;
	
	reward.reward_id = [[dictionary objectForKey:@"id"] intValue];
	reward.title = [dictionary objectForKey:@"name"];
	reward.info = [dictionary objectForKey:@"info"];
	reward.points = [[dictionary objectForKey:@"points"] intValue];
	reward.cost = [[dictionary objectForKey:@"price"] floatValue];

	return (reward);
}

-(NSString *)price {
	return ((self.cost > 0.0) ? [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithFloat:self.cost] numberStyle:NSNumberFormatterCurrencyStyle] : @"Free");
}

-(NSString *)disp_points {
	return ([NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:self.points] numberStyle:NSNumberFormatterDecimalStyle]);
}

- (void)dealloc {
	self.dictionary = nil;
	self.title = nil;
	self.info = nil;
	
	[super dealloc];
}

@end