//
//  RASDayModel.h
//  Appostolic
//
//  Created by Robert Stein on 1/18/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

@class RASReading;
@class RASLiturgy;
@class RASSaint;

@interface RASDayModel : NSObject

@property (nonatomic, copy) NSString *dayID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lectionary;
@property (nonatomic, copy) NSArray <RASReading *> *readings;
@property (nonatomic, copy) NSArray <RASLiturgy *> *liturgyOfTheHours;
@property (nonatomic, copy) NSArray <RASSaint *> *saints;

@end
