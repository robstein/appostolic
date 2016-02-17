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
#import "RASDayCollectionViewCell.h"

#import "RASDayModel.h"
#import "RASReading.h"
#import "RASLiturgy.h"
#import "RASSaint.h"

#import "RASTextViewController.h"

#import <RestKit/RKObjectMapping.h>
#import <RestKit/RKRelationshipMapping.h>
#import <RestKit/RKResponseDescriptor.h>
#import <RestKit/RKObjectRequestOperation.h>

//NSString *const RASReadingsServerURLFormat = @"http://localhost:3000/%@";
NSString *const RASReadingsServerURLFormat = @"http://40.78.107.212:3000/%@";
NSString *const RASDayTabName = @"Today";
NSString *const RASDayTabImageName = @"Home";
NSString *const RASDayCollectionCellIdentifierReading = @"RASDayCollectionCellIdentifierReading";
NSString *const RASDayCollectionCellIdentifierLiturgy = @"RASDayCollectionCellIdentifierLiturgy";
NSString *const RASDayCollectionCellIdentifierSaint = @"RASDayCollectionCellIdentifierSaint";

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

- (instancetype)init {
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	[layout setScrollDirection:UICollectionViewScrollDirectionVertical];
	[layout setItemSize:CGSizeMake(175, 86)];
	[layout setHeaderReferenceSize:CGSizeMake(0, 100.f)];
	self = [self initWithCollectionViewLayout:layout];
	return self;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
	if (self = [super initWithCollectionViewLayout:layout]) {
		[self setTitle:RASDayTabName];
		[[self tabBarItem] setImage:[UIImage imageNamed:RASDayTabImageName]];
		
		UICollectionView *collectionView = [[RASDayCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
		[collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
		[collectionView setDelegate:self];
		[collectionView setDataSource:self];
		[collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:RASDayCollectionCellIdentifierReading];
		[collectionView registerClass:[UICollectionViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:RASDayCollectionCellIdentifierReading];
		
		[collectionView setBackgroundColor:[UIColor clearColor]];
		[collectionView setScrollEnabled:YES];
		
		[self setCollectionView:collectionView];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UICollectionView *collectionView = [self collectionView];
	if (collectionView != nil) {
		NSDictionary *subviews = NSDictionaryOfVariableBindings(collectionView);
		NSArray<NSLayoutConstraint *> *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[collectionView]|"
																								  options:0
																								  metrics:nil
																									views:subviews];
		[collectionView addConstraints:constraints];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self loadDay:[NSDate date]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modelLoaded:) name:@"ModelLoaded" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)displayController:(UIViewController *)childViewController {
	[self addChildViewController:childViewController];
	[[self view] addSubview:[childViewController view]];
	[childViewController didMoveToParentViewController:self];
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
	[[self collectionView] reloadData];
	[[self collectionView] setNeedsLayout];
}

- (void)viewWillLayoutSubviews {
	UICollectionView *collectionView = [self collectionView];
	CGRect screenBounds = [[UIScreen mainScreen] bounds];
	NSInteger numOfReadings = [[_model readings] count];
	NSInteger spacingWidth = 10;
	NSInteger cellWidth = 175;
	NSInteger cellHeight = 106;
	CGFloat width = numOfReadings*(cellWidth + (spacingWidth-1));
	CGFloat height = numOfReadings*(cellHeight + (spacingWidth-1));
	[collectionView setContentSize:CGSizeMake(screenBounds.size.width, height)];
	CGRect collectionViewFrame = [collectionView frame];
	[collectionView setFrame:CGRectMake(0, collectionViewFrame.origin.y, screenBounds.size.width, screenBounds.size.height)];
	
	id top = [self topLayoutGuide];
	NSDictionary *views = NSDictionaryOfVariableBindings(collectionView, top);
	NSArray <NSLayoutConstraint *> *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[top]-(0)-[collectionView]" options:0 metrics:nil views:views];
	[[self view] addConstraints:constraints];
}

#pragma mark - UICollectionViewDelegate methods

#pragma mark Managing the Selected Cells

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	RASDayCollectionSection collectionSection = [indexPath section];
	
	UICollectionViewCell *cell;
	switch (collectionSection) {
		case RASDayCollectionSectionReadings:
		{
			NSInteger index = [indexPath item];
			RASTextViewController *textViewController = [[RASTextViewController alloc] initWithReading:[[_model readings] objectAtIndex:index]];
			[self displayController:textViewController];
			break;
		}
	}
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

#pragma mark - UICollectionViewDataSource methods

#pragma mark Getting Item and Section Metrics

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	if (collectionView == [self collectionView]) {
		NSInteger numberOfSections = [self numberOfSectionsInCollectionView:collectionView];
		if (numberOfSections == 1/*TODO change this to MAX */) {
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
	RASDayCollectionSection collectionSection = [indexPath section];

	UICollectionViewCell *cell;
	switch (collectionSection) {
		case RASDayCollectionSectionReadings:
		{
			cell = [collectionView dequeueReusableCellWithReuseIdentifier:RASDayCollectionCellIdentifierReading forIndexPath:indexPath];
			NSInteger index = [indexPath item];
			RASReading *reading = [[_model readings] objectAtIndex:index];
			RASWideButton *button = [[RASWideButton alloc] initWithTitle:[reading name] subtitle:[reading passage] body:[reading body]];
			[button setTranslatesAutoresizingMaskIntoConstraints:NO];
			[[cell contentView] addSubview:button];
			break;
		}
		case RASDayCollectionSectionLiturgyOfTheHours:
		{
			cell = [collectionView dequeueReusableCellWithReuseIdentifier:RASDayCollectionCellIdentifierLiturgy forIndexPath:indexPath];
			break;
		}
		case RASDayCollectionSectionSaints:
		{
			cell = [collectionView dequeueReusableCellWithReuseIdentifier:RASDayCollectionCellIdentifierSaint forIndexPath:indexPath];
			break;
		}
		case RASDayCollectionSectionMax:
		{
			NSLog(@"Fail. This indexPath is invalid. We'll probably crash soon.");
			break;
		}
	}
	
	return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(nonnull NSIndexPath *)indexPath {
	RASDayCollectionSection collectionSection = [indexPath section];
	UICollectionReusableView *view;
	switch (collectionSection) {
		case RASDayCollectionSectionReadings:
		{
			view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:RASDayCollectionCellIdentifierReading forIndexPath:indexPath];
			UILabel *label = [[UILabel alloc] initWithFrame:[view frame]];
			[label setText:[_model title]];
			[view addSubview:label];
			break;
		}
		case RASDayCollectionSectionLiturgyOfTheHours:
		{
			view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:RASDayCollectionCellIdentifierLiturgy forIndexPath:indexPath];
			break;
		}
		case RASDayCollectionSectionSaints:
		{
			view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:RASDayCollectionCellIdentifierSaint forIndexPath:indexPath];
		}
		case RASDayCollectionSectionMax:
		{
			NSLog(@"Fail. This indexPath is invalid. We'll probably crash soon.");
			return nil;
		}
	}
	return view;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
	return NO;
}

@end
