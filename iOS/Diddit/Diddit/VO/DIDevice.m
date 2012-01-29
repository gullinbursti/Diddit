//
//  DIDevice.m
//  Diddit
//
//  Created by Matthew Holcombe on 01.28.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import "DIDevice.h"

@implementation DIDevice

@synthesize dictionary;
@synthesize device_id, device_name, os, type_id, isLocked, isMaster, ua_id, uuid;

+(DIDevice *)deviceWithDictionary:(NSDictionary *)dictionary {
	DIDevice *device = [[DIDevice alloc] init];
	
	device.dictionary = dictionary;
	
	device.device_id = [[dictionary objectForKey:@"id"] intValue];
	device.uuid = [dictionary objectForKey:@"uuid"];
	device.ua_id = [dictionary objectForKey:@"ua_id"];
	device.type_id = [[dictionary objectForKey:@"type_id"] intValue];
	device.os = [dictionary objectForKey:@"os"];
	device.device_name = [dictionary objectForKey:@"name"];
	device.isMaster = (BOOL)([[dictionary objectForKey:@"master"] isEqual:@"Y"]);
	device.isLocked = (BOOL)([[dictionary objectForKey:@"locked"] isEqual:@"Y"]);
	
	return (device);
}

-(NSString *)locked {
	return ((self.isLocked) ? @"LOCKED" : @"UNLOCKED");
}

-(void)dealloc {
	
	self.dictionary = nil;
	self.uuid = nil;
	self.ua_id = nil;
	self.os = nil;
	self.device_name = nil;
	
	[super dealloc];
}

@end
