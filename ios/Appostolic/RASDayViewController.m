//
//  RASDayViewController.m
//  Appostolic
//
//  Created by Robert Stein on 1/12/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "RASDayViewController.h"
#import "RASWideButton.h"
#import "RASSquareButton.h"
#import "RASDayModel.h"
#import "RASReading.h"
#import "RASLiturgy.h"
#import "RASSaint.h"
#import <RestKit/RKObjectMapping.h>
#import <RestKit/RKRelationshipMapping.h>
#import <RestKit/RKResponseDescriptor.h>
#import <RestKit/RKObjectRequestOperation.h>

NSString *const RASReadingsServerURLFormat = @"http://localhost:3000/%@";

@interface RASDayViewController ()

@property (nonatomic, strong) RASDayModel *model;

@end

@implementation RASDayViewController

@synthesize model = _model;


- (void)viewDidLoad {
    [super viewDidLoad];
	[self loadDay:[NSDate date]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modelLoaded:) name:@"ModelLoaded" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Load model with data

- (void)loadDay:(NSDate *)date {
	double millisecondsSince1970 = [date timeIntervalSince1970] * 1000;
	NSString *lastPathComponent = [NSString stringWithFormat:@"%.0f", millisecondsSince1970];
	NSString *urlString = [NSString stringWithFormat:RASReadingsServerURLFormat, lastPathComponent];
	NSURL *url = [NSURL URLWithString:urlString];
	
	RKObjectMapping *readingMapping = [RKObjectMapping mappingForClass:[RASReading class]];
	[readingMapping addAttributeMappingsFromDictionary:@{
														 @"name":  @"name",
														 @"passage":   @"passage",
														 @"body":  @"body"
														 }];
	
	RKObjectMapping *liturgyMapping = [RKObjectMapping mappingForClass:[RASLiturgy class]];
	[liturgyMapping addAttributeMappingsFromDictionary:@{
														 @"name":  @"name",
														 @"body":  @"body"
														 }];
	
	RKObjectMapping *saintMapping = [RKObjectMapping mappingForClass:[RASSaint class]];
	[saintMapping addAttributeMappingsFromDictionary:@{
													   @"name":  @"name",
													   @"body":  @"body"
													   }];
	
	RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[RASDayModel class]];
	[mapping addAttributeMappingsFromDictionary:@{
												  @"title": @"title",
												  @"lectionary":    @"lectionary",
												  @"text":  @"text"
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
		RASDayModel *model = [[result array] firstObject];
		NSLog(@"The day's data: %@", model);
		[[NSNotificationCenter defaultCenter] postNotificationName:@"ModelLoaded" object:model];
	} failure:^(RKObjectRequestOperation *operation, NSError *error) {
		NSLog(@"Shoot! %@", [error description]);
	}];
	[operation start];
}

- (void)modelLoaded:(NSNotification *)notification {
	_model = [notification object];
}

@end
