//
//  RASLiturgy.m
//  Appostolic
//
//  Created by Robert Stein on 1/18/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "RASLiturgy.h"

static NSString *const RASLiturgyInvitatoryNamePrefix = @"Invitatory";
static NSString *const RASLiturgyOfficeOfReadingsNamePrefix = @"Office";
static NSString *const RASLiturgyMorningNamePrefix = @"Morning";
static NSString *const RASLiturgyMidmorningNamePrefix = @"Midmorning";
static NSString *const RASLiturgyMiddayNamePrefix = @"Midday";
static NSString *const RASLiturgyMidafternoonNamePrefix = @"Midafternoon";
static NSString *const RASLiturgyEveningNamePrefix = @"Evening";
static NSString *const RASLiturgyNightNamePrefix = @"Night";

static NSString *const RASLiturgyInvitatoryTimeOfDay = @"Dawn or 3am";
static NSString *const RASLiturgyOfficeOfReadingsTimeOfDay = @"Anytime	";
static NSString *const RASLiturgyMorningTimeOfDay = @"6am";
static NSString *const RASLiturgyMidmorningTimeOfDay = @"9am";
static NSString *const RASLiturgyMiddayTimeOfDay = @"12pm";
static NSString *const RASLiturgyMidafternoonTimeOfDay = @"3pm";
static NSString *const RASLiturgyEveningTimeOfDay = @"6pm";
static NSString *const RASLiturgyNightTimeOfDay = @"9pm";

@interface RASLiturgy ()

@property (nonatomic, assign) RASLiturgyType type;
@property (nonatomic, strong) NSString *timeOfDay;

@end

@implementation RASLiturgy

@synthesize name = _name;
@synthesize body = _body;
@synthesize type = _type;
@synthesize timeOfDay = _timeOfDay;

- (NSString *)timeOfDay {
	if (_timeOfDay == nil) {
		RASLiturgyType type = [self type];
		switch (type) {
			case RASLiturgyTypeInvitatory:
				_timeOfDay = RASLiturgyInvitatoryTimeOfDay;
				break;
			case RASLiturgyTypeOfficeOfReadings:
				_timeOfDay = RASLiturgyOfficeOfReadingsTimeOfDay;
				break;
			case RASLiturgyTypeMorningPrayer:
				_timeOfDay = RASLiturgyMorningTimeOfDay;
				break;
			case RASLiturgyTypeMidmorningPrayer:
				_timeOfDay = RASLiturgyMidmorningTimeOfDay;
				break;
			case RASLiturgyTypeMiddayPrayer:
				_timeOfDay = RASLiturgyMiddayTimeOfDay;
				break;
			case RASLiturgyTypeMidafternoonPrayer:
				_timeOfDay = RASLiturgyMidafternoonTimeOfDay;
				break;
			case RASLiturgyTypeEveningPrayer:
				_timeOfDay = RASLiturgyEveningTimeOfDay;
				break;
			case RASLiturgyTypeNightPrayer:
				_timeOfDay = RASLiturgyNightTimeOfDay;
				break;
			case RASLiturgyTypeInvalid:
				_timeOfDay = @"";
				break;
		}
	}
	return _timeOfDay;
}

- (RASLiturgyType)type {
	if (_type == RASLiturgyTypeInvalid) {
		if ([_name hasPrefix:RASLiturgyInvitatoryNamePrefix]) {
			_type = RASLiturgyTypeInvitatory;
		} else if ([_name hasPrefix:RASLiturgyOfficeOfReadingsNamePrefix]) {
			_type = RASLiturgyTypeOfficeOfReadings;
		} else if ([_name hasPrefix:RASLiturgyMorningNamePrefix]) {
			_type = RASLiturgyTypeMorningPrayer;
		} else if ([_name hasPrefix:RASLiturgyMidmorningNamePrefix]) {
			_type = RASLiturgyTypeMidmorningPrayer;
		} else if ([_name hasPrefix:RASLiturgyMiddayNamePrefix]) {
			_type = RASLiturgyTypeMiddayPrayer;
		} else if ([_name hasPrefix:RASLiturgyMidafternoonNamePrefix]) {
			_type = RASLiturgyTypeMidafternoonPrayer;
		} else if ([_name hasPrefix:RASLiturgyEveningNamePrefix]) {
			_type = RASLiturgyTypeEveningPrayer;
		} else if ([_name hasPrefix:RASLiturgyNightNamePrefix]) {
			_type = RASLiturgyTypeNightPrayer;
		} else {
			_type = RASLiturgyTypeInvalid;
		}
	}
	return _type;
}

+ (NSArray <RASLiturgy *> *)liturgyArrayBySortingTimeOfDay:(NSArray <RASLiturgy *> *)unsortedArray {
	NSArray *sortedArray;
	sortedArray = [unsortedArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
		RASLiturgyType first = [(RASLiturgy *)a type];
		RASLiturgyType second = [(RASLiturgy *)b type];
		return first > second;
	}];
	return sortedArray;
}

@end
