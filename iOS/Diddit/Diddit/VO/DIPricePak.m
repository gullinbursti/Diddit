//
//  DIPricePak.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.07.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIPricePak.h"

@implementation DIPricePak

@synthesize dictionary;

@synthesize iap_id;
@synthesize title;
@synthesize info;
@synthesize points;
@synthesize cost;
@synthesize ico_url;
@synthesize itunes_id;

+(DIPricePak *)pricePakWithDictionary:(NSDictionary *)dictionary {
	
	DIPricePak *pricePak = [[DIPricePak alloc] init];
	pricePak.dictionary = dictionary;
	
	pricePak.iap_id = [[dictionary objectForKey:@"id"] intValue];
	pricePak.title = [dictionary objectForKey:@"name"];
	pricePak.info = [dictionary objectForKey:@"info"];
	pricePak.points = [[dictionary objectForKey:@"points"] intValue];
	pricePak.cost = [[dictionary objectForKey:@"price"] floatValue];
	pricePak.ico_url = [dictionary objectForKey:@"ico_url"];
	pricePak.itunes_id = [dictionary objectForKey:@"itunes_id"];

	return (pricePak);
}

-(NSString *)price {
	return ((self.cost > 0.0) ? [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithFloat:self.cost] numberStyle:NSNumberFormatterCurrencyStyle] : @"FREE");
}

-(NSString *)disp_points {
	return ([NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:self.points] numberStyle:NSNumberFormatterDecimalStyle]);
}

- (void)dealloc {
	self.dictionary = nil;
	self.title = nil;
	self.info = nil;
	self.ico_url = nil;
	self.itunes_id = nil;
	
	[super dealloc];
}

@end
