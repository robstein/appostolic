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
#import <DTCoreText/DTCoreText.h>

static const CGFloat RASDetailViewCellSpacing = 8.f;

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
		[defaultInstance setEstimatedItemSize:CGSizeMake(mainScreenSize.width, mainScreenSize.height)];
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
	[collectionView setBackgroundColor:[UIColor grayColor]];
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
		[cell setText:[[_readings objectAtIndex:[indexPath section]] body]];
	} else if (_liturgy != nil) {
		[cell setText:[_liturgy body]];
	}
	return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return CGSizeMake([collectionView frame].size.width, 40.f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return RASDetailViewCellSpacing;
}

@end
