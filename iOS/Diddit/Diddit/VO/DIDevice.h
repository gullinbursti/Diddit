//
//  DIDevice.h
//  Diddit
//
//  Created by Matthew Holcombe on 01.28.12.
//  Copyright (c) 2012 Sparkle Mountain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIDevice : NSObject {
	
}

@property (nonatomic, retain) NSDictionary *dictionary;

@property (nonatomic) int device_id;
@property (nonatomic, retain) NSString *device_name;
@property (nonatomic, retain) NSString *uuid;
@property (nonatomic, retain) NSString *ua_id;
@property (nonatomic) int type_id;
@property (nonatomic, retain) NSString *os;
@property (nonatomic) BOOL isMaster;
@property (nonatomic) BOOL isLocked;



+(DIDevice *)deviceWithDictionary:(NSDictionary *)dictionary;
-(NSString *)locked;

@end
