//
//  DailyReadings.h
//  Appostolic
//
//  Created by Robert Stein on 1/13/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyReadings : NSObject

- (instancetype)initForDate:(NSDate *)date;

@property (nonatomic, copy) NSString *readingTitle;
@property (nonatomic, copy) NSString *firstReading;
@property (nonatomic, copy) NSString *responsorialPsalm;
@property (nonatomic, copy) NSString *secondReading;
@property (nonatomic, copy) NSString *alleluia;
@property (nonatomic, copy) NSString *verseBeforeTheGospel; // for lent
@property (nonatomic, copy) NSString *gospel;

@property (nonatomic, copy) NSDictionary *readings; // there are some corner cases on palm sunday, wednesday of holy week. plenty of holy week has multiple readings available. Easter sunday has some interesting stuff too. Christmas Mass has -vigil.cfm -midnight.cfm etc etc

@end
