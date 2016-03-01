//
//  RASDayModel.m
//  Appostolic
//
//  Created by Robert Stein on 1/18/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "RASDayModel.h"
#import "RASReading.h"
#import "RASLiturgy.h"
#import "RASSaint.h"
#import "RASUtils.h"

#import <RestKit/RKObjectMapping.h>
#import <RestKit/RKRelationshipMapping.h>
#import <RestKit/RKResponseDescriptor.h>
#import <RestKit/RKObjectRequestOperation.h>

NSString * RASDayModelDidLoadNotification = @"RASDayModelDidLoadNotification";

@implementation RASDayModel

@synthesize dayID = _dayID;
@synthesize title = _title;
@synthesize lectionary = _lectionary;
@synthesize readings = _readings;
@synthesize liturgyOfTheHours = _liturgyOfTheHours;
@synthesize saints = _saints;

+ (void)loadForDay:(NSDate *)date {
	NSTimeInterval secondsSince1970 = [date timeIntervalSince1970];
	NSInteger secondsFromGMT = [[NSTimeZone localTimeZone] secondsFromGMT];
	NSTimeInterval localMillisecondsSince1970 = (secondsSince1970 + secondsFromGMT) * 1000;
	NSString *lastPathComponent = [NSString stringWithFormat:@"%.0f", localMillisecondsSince1970];
	NSString *urlString = URLWithServerQuery(lastPathComponent);
	NSURL *url = [NSURL URLWithString:urlString];
	
	RKObjectMapping *readingMapping = [RKObjectMapping mappingForClass:[RASReading class]];
	[readingMapping addAttributeMappingsFromDictionary:@{
														 @"name": @"name",
														 @"passage": @"passage",
														 @"body": @"body"
														 }];
	
	RKObjectMapping *liturgyMapping = [RKObjectMapping mappingForClass:[RASLiturgy class]];
	[liturgyMapping addAttributeMappingsFromDictionary:@{
														 @"name": @"name",
														 @"body": @"body"
														 }];
	
	RKObjectMapping *saintMapping = [RKObjectMapping mappingForClass:[RASSaint class]];
	[saintMapping addAttributeMappingsFromDictionary:@{
													   @"name": @"name",
													   @"body": @"body"
													   }];
	
	RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RASDayModel class]];
	[mapping addAttributeMappingsFromDictionary:@{
												  @"title": @"title",
												  @"lectionary": @"lectionary",
												  @"text": @"text"
												  }];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"readings"
																			toKeyPath:@"readings"
																		  withMapping:readingMapping]];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"liturgyOfTheHours"
																			toKeyPath:@"liturgyOfTheHours"
																		  withMapping:liturgyMapping]];
	[mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"saints"
																			toKeyPath:@"saints"
																		  withMapping:saintMapping]];
	
	RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:nil];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
	[operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
		
		RASDayModel *resultModel = [[result array] firstObject];
		[[NSNotificationCenter defaultCenter] postNotificationName:RASDayModelDidLoadNotification object:resultModel];
		
	} failure:^(RKObjectRequestOperation *operation, NSError *error) {
		NSLog(@"Error loading day from server: %@", [error description]);
	}];
	[operation start];
}

@end