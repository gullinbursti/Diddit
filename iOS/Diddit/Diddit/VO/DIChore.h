//
//  DIChore.h
//  DidIt
//
//  Created by Matthew Holcombe on 12.12.11.
//  Copyright (c) 2011 Sparkle Mountain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DIChore : NSObject

+(DIChore *)choreWithDictionary:(NSDictionary *)dictionary;
-(NSString *)price;

@property (nonatomic, retain) NSDictionary *dictionary;
@property (nonatomic) int chore_id;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *info;
@property (nonatomic) int cost;
@property (nonatomic) int points;
@property (nonatomic, retain) NSString *icoPath;
@property (nonatomic, retain) NSString *imgPath;
@property (nonatomic) BOOL isFinished;
@property (nonatomic) BOOL isCustom;

@end
