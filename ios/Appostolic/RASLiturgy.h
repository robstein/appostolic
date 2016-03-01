//
//  RASLiturgy.h
//  Appostolic
//
//  Created by Robert Stein on 1/18/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

typedef NS_ENUM(NSInteger, RASLiturgyType) {
	RASLiturgyTypeInvitatory,
	RASLiturgyTypeOfficeOfReadings,
	RASLiturgyTypeMorningPrayer,
	RASLiturgyTypeMidmorningPrayer,
	RASLiturgyTypeMiddayPrayer,
	RASLiturgyTypeMidafternoonPrayer,
	RASLiturgyTypeEveningPrayer,
	RASLiturgyTypeNightPrayer
};

@interface RASLiturgy : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *body;

@end
