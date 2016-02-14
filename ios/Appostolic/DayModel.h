//
//  DayModel.h
//  Appostolic
//
//  Created by Robert Stein on 1/18/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

@class Reading;
@class Liturgy;
@class Saint;

@interface DayModel : NSObject

@property (nonatomic, copy) NSString *dayID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lectionary;
@property (nonatomic, copy) NSArray <Reading *> *readings;
@property (nonatomic, copy) NSArray <Liturgy *> *liturgyOfTheHours;
@property (nonatomic, copy) NSArray <Saint *> *saints;

@end
