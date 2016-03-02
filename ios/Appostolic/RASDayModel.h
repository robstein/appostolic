//
//  RASDayModel.h
//  Appostolic
//
//  Created by Robert Stein on 1/18/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

@class RASReading;
@class RASLiturgy;

extern NSString *RASDayModelDidLoadNotification;

@interface RASDayModel : NSObject

+ (void)loadForDay:(NSDate *)date;

@property (nonatomic, copy) NSString *dayID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lectionary;
@property (nonatomic, copy) NSArray <RASReading *> *readings;
@property (nonatomic, copy) NSArray <RASLiturgy *> *liturgyOfTheHours;

@end
