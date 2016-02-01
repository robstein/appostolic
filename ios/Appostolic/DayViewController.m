//
//  DayViewController.m
//  Appostolic
//
//  Created by Robert Stein on 1/12/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "DayViewController.h"
#import "WideButton.h"
#import "SquareButton.h"
#import "DayModel.h"
#import "Reading.h"
#import "Liturgy.h"
#import "Saint.h"
#import <RestKit/RKObjectMapping.h>
#import <RestKit/RKRelationshipMapping.h>
#import <RestKit/RKResponseDescriptor.h>
#import <RestKit/RKObjectRequestOperation.h>

NSString *const ReadingsServerURLFormat = @"http://localhost:3000/%@";

@interface DayViewController ()

@property (nonatomic, strong) DayModel *model;
@property (nonatomic, strong) UICollectionViewController *collectionViewController;

@end

@implementation DayViewController

@synthesize model = _model;
@synthesize collectionViewController = _collectionViewController;

- (UICollectionViewController *)collectionViewController {
	if (_collectionViewController == nil) {
		UICollectionViewLayout *viewLayout = [[UICollectionViewFlowLayout alloc] init];
		_collectionViewController = [[UICollectionViewController alloc] initWithCollectionViewLayout:viewLayout];
	}
	return _collectionViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self loadDay:[NSDate date]];
	

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modelLoaded:) name:@"ModelLoaded" object:nil];
}

- (void)viewDidLayoutSubviews {
    //[[self readings] setContentSize:CGSizeMake(4*175+(4-1)*15+27.5, 86)];
    //[[self liturgyOfTheHours] setContentSize:CGSizeMake(10*80+(10-1)*15+27.5, 80)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Load model with data

- (void)loadDay:(NSDate *)date {
	double millisecondsSince1970 = [date timeIntervalSince1970] * 1000;
	NSString *lastPathComponent = [NSString stringWithFormat:@"%.0f", millisecondsSince1970];
	NSString *urlString = [NSString stringWithFormat:ReadingsServerURLFormat, lastPathComponent];
	NSURL *url = [NSURL URLWithString:urlString];
	
	RKObjectMapping *readingMapping = [RKObjectMapping mappingForClass:[Reading class]];
	[readingMapping addAttributeMappingsFromDictionary:@{
														 @"name":  @"name",
														 @"passage":   @"passage",
														 @"body":  @"body"
														 }];
	
	RKObjectMapping *liturgyMapping = [RKObjectMapping mappingForClass:[Liturgy class]];
	[liturgyMapping addAttributeMappingsFromDictionary:@{
														 @"name":  @"name",
														 @"body":  @"body"
														 }];
	
	RKObjectMapping *saintMapping = [RKObjectMapping mappingForClass:[Saint class]];
	[saintMapping addAttributeMappingsFromDictionary:@{
													   @"name":  @"name",
													   @"body":  @"body"
													   }];
	
	RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[DayModel class]];
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
		DayModel *model = [[result array] firstObject];
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
