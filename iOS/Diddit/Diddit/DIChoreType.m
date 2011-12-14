//
//  DIChoreType.m
//  Diddit
//
//  Created by Matthew Holcombe on 12.13.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import "DIChoreType.h"

@implementation DIChoreType

@synthesize dictionary;
@synthesize type_id, freq_id, title, info, points, imgPath;

+(DIChoreType *)choreTypeWithDictionary:(NSDictionary *)dictionary {
	
	DIChoreType *choreType = [[DIChoreType alloc] init];
	choreType.dictionary = dictionary;
	
	choreType.type_id = [[dictionary objectForKey:@"type_id"] intValue];
	choreType.freq_id = [[dictionary objectForKey:@"freq)id"] intValue];
	choreType.title = [dictionary objectForKey:@"title"];
	choreType.info = [dictionary objectForKey:@"info"];
	choreType.points = [[dictionary objectForKey:@"points"] intValue];
	choreType.imgPath = [dictionary objectForKey:@"imgPath"];
	
	return (choreType);
}

@end
