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
#import "RASDayCollectionView.h"

#import "RASDayModel.h"
#import "RASReading.h"
#import "RASLiturgy.h"
#import "RASSaint.h"

#import <RestKit/RKObjectMapping.h>
#import <RestKit/RKRelationshipMapping.h>
#import <RestKit/RKResponseDescriptor.h>
#import <RestKit/RKObjectRequestOperation.h>

NSString *const RASReadingsServerURLFormat = @"http://localhost:3000/%@";
NSString *const RASDayTabName = @"Today";
NSString *const RASDayTabImageName = @"Home";

typedef NS_ENUM(NSInteger, RASDayCollectionSection) {
	RASDayCollectionSectionReadings,
	RASDayCollectionSectionLiturgyOfTheHours,
	RASDayCollectionSectionSaints,
	RASDayCollectionSectionMax
};

@interface RASDayViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) RASDayModel *model;

@end

@implementation RASDayViewController

@synthesize model = _model;

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
	if (self = [super initWithCollectionViewLayout:layout]) {
		[self setTitle:RASDayTabName];
		[[self tabBarItem] setImage:[UIImage imageNamed:RASDayTabImageName]];
		
		RASDayCollectionView *collectionView = [[RASDayCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
		[collectionView setDelegate:self];
		[collectionView setDataSource:self];
		[self setCollectionView:collectionView];
	}
	return self;
}

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

#pragma mark - UICollectionViewDelegate methods

#pragma mark Managing the Selected Cells

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
	
}

#pragma mark Managing Cell Highlighting

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	
}

#pragma mark Tracking the Addition and Removal of Views

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
	
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
	
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
	
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
	
}

#pragma mark Handling Layout Changes

- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout {
	return nil;
}

- (CGPoint)collectionView:(UICollectionView *)collectionView targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset {
	return CGPointZero;
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath {
	return nil;
}

#pragma mark Managing Actions for Cells

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}

#pragma mark Managing Collection View Focus

- (BOOL)collectionView:(UICollectionView *)collectionView canFocusItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator {
	
}

- (NSIndexPath *)indexPathForPreferredFocusedViewInCollectionView:(UICollectionView *)collectionView {
	return nil;
}

#pragma mark - UICollectionViewDataSource methods

#pragma mark Getting Item and Section Metrics

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	if (collectionView == [self collectionView]) {
		NSInteger numberOfSections = [self numberOfSectionsInCollectionView:collectionView];
		if (numberOfSections == RASDayCollectionSectionMax) {
			RASDayCollectionSection daySection = (RASDayCollectionSection)section;
			switch (daySection) {
				case RASDayCollectionSectionReadings:
					return [[_model readings] count];
				case RASDayCollectionSectionLiturgyOfTheHours:
					return [[_model liturgyOfTheHours] count];
				case RASDayCollectionSectionSaints:
					return [[_model saints] count];
				case RASDayCollectionSectionMax:
					NSLog(@"This day has more than the proper number of sections. Failing.");
					return 0;
			}
		} else {
			NSLog(@"This day doesn't have the proper number of sections. Failing.");
		}
	}
	return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	if (collectionView == [self collectionView]) {
		NSInteger numberOfSections = 0;
		if ([[_model readings] count]) {
			numberOfSections += 1;
		}
		if ([[_model liturgyOfTheHours] count]) {
			numberOfSections += 1;
		}
		if ([[_model saints] count]) {
			numberOfSections += 1;
		}
		return numberOfSections;
	}
	return 0;
}

#pragma mark Getting Views for Items

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(nonnull NSString *)kind atIndexPath:(nonnull NSIndexPath *)indexPath {
	return nil;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
	return NO;
}

#pragma mark Reordering Items

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath {
	
}

@end
