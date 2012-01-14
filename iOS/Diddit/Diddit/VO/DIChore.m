//
//  DIChore.m
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import "DIChore.h"

@implementation DIChore

@synthesize dictionary;
@synthesize chore_id;
@synthesize title;
@synthesize info;
@synthesize points;
@synthesize cost;
@synthesize icoPath;
@synthesize imgPath;
@synthesize isFinished;
@synthesize expires;


+(DIChore *)choreWithDictionary:(NSDictionary *)dictionary {
	
	DIChore *chore = [[DIChore alloc] init];
	chore.dictionary = dictionary;
	
	chore.chore_id = [[dictionary objectForKey:@"id"] intValue];
	chore.title = [dictionary objectForKey:@"title"];
	chore.info = [dictionary objectForKey:@"info"];
	chore.points = [[dictionary objectForKey:@"points"] intValue];
	chore.cost = [[dictionary objectForKey:@"price"] floatValue];
	chore.icoPath = [dictionary objectForKey:@"icoPath"];
	chore.imgPath = [dictionary objectForKey:@"imgPath"];
	chore.isFinished = (BOOL)([[dictionary objectForKey:@"finished"] isEqual:@"Y"]);
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	chore.expires = [dateFormat dateFromString:[dictionary objectForKey:@"expires"]];
	[dateFormat release];
	
	return (chore);
}

-(NSString *)price {
	return (([[NSNumber numberWithFloat:self.cost] integerValue] >= 0.0) ? [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithFloat:self.cost] numberStyle:NSNumberFormatterCurrencyStyle] : @"Free");
}

-(NSString *)disp_points {
	return ([NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:self.points] numberStyle:NSNumberFormatterDecimalStyle]);
}

-(NSString *)disp_expires {
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"M/d/YY"];
	
	NSString *dateString = [dateFormat stringFromDate:self.expires];  
	[dateFormat release];
	
	return (dateString);
}


- (void)dealloc {
	self.dictionary = nil;
	self.title = nil;
	self.info = nil;
	self.icoPath = nil;
	self.imgPath = nil;
	
	[super dealloc];
}

@end
