//
//  RASDetailViewController.m
//  Appostolic
//
//  Created by Robert Stein on 2/28/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "RASDetailViewController.h"
#import "RASDetailViewCell.h"
#import "RASReading.h"
#import "RASLiturgy.h"
#import "RASUtils.h"
#import "RASColor.h"
#import <DTCoreText/DTCoreText.h>

static const CGFloat RASDetailViewHorizontalMargin = 20.f;
static const CGFloat RASDetailViewInterTopMargin = 30.f;

@interface RASDetailViewController ()

@end

@implementation RASDetailViewController

@synthesize readings = _readings;
@synthesize liturgy = _liturgy;

+ (UICollectionViewFlowLayout *)defaultLayout {
	static UICollectionViewFlowLayout *defaultInstance = nil;
	static dispatch_once_t once;
	dispatch_once(&once, ^{
		defaultInstance = [[UICollectionViewFlowLayout alloc] init];
		[defaultInstance setScrollDirection:UICollectionViewScrollDirectionVertical];
		
		CGSize mainScreenSize = [[UIScreen mainScreen] bounds].size;
		[defaultInstance setEstimatedItemSize:CGSizeMake(mainScreenSize.width, mainScreenSize.height/2)];
	});
	return defaultInstance;
}

- (instancetype)initWithReadings:(NSArray<RASReading *>*)readings {
	if (self = [self init]) {
		_readings = readings;
	}
	return self;
}

- (instancetype)initWithLiturgy:(RASLiturgy *)liturgy {
	if (self = [self init]) {
		_liturgy = liturgy;
	}
	return self;
}

- (instancetype)init {
	if (self = [self initWithCollectionViewLayout:[RASDetailViewController defaultLayout]]) {
	}
	return self;
}

- (void)loadView {
	[super loadView];
	
	UICollectionView *collectionView = [self collectionView];
	[collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[collectionView setDelegate:self];
	[collectionView setDataSource:self];
	
	UIView *background = [[UIView alloc] init];
	[collectionView setBackgroundView:background];

	CGRect collectionViewBounds = [collectionView bounds];
	CAGradientLayer *gradient = [CAGradientLayer layer];
	[gradient setBounds:collectionViewBounds];
	[gradient setAnchorPoint:CGPointZero];
	[gradient setColors:[RASColor goldColors]];
	[[[collectionView backgroundView] layer] insertSublayer:gradient atIndex:0];
}

// Do any additional setup after loading the view.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	UICollectionView *collectionView = [self collectionView];
	
	// Register cell classes
	[collectionView registerClass:[RASDetailViewCell class] forCellWithReuseIdentifier:RASDetailViewCellReuseIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	if (_readings != nil) {
		return [_readings count];
	} else if (_liturgy != nil) {
		return 1;
	} else {
		return 0;
	}
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return 1;
}

- (RASDetailViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	RASDetailViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:RASDetailViewCellReuseIdentifier forIndexPath:indexPath];
	if (_readings != nil) {
		RASReading *reading = [_readings objectAtIndex:[indexPath section]];
		NSString *name = [reading name];
		BOOL isPoetry = ([name hasPrefix:@"Responsorial"]) || ([name hasPrefix:@"Alleluia"]) || ([name hasPrefix:@"Verse"]);
		[cell setText:[reading body] isPoetry:isPoetry];
	} else if (_liturgy != nil) {
		[cell setText:[_liturgy body] isPoetry:YES];
	}
	return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return CGSizeMake([collectionView frame].size.width - (2 * RASDetailViewHorizontalMargin), [[UIScreen mainScreen] bounds].size.height/2);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	return UIEdgeInsetsMake(RASDetailViewInterTopMargin, RASDetailViewHorizontalMargin, 0.f, RASDetailViewHorizontalMargin);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
	return CGSizeZero;
}

@end
