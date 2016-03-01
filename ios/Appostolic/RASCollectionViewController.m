//
//  RASCollectionViewController.m
//  Appostolic
//
//  Created by Robert Stein on 2/19/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "RASCollectionViewController.h"
#import "RASCollectionViewCell.h"
#import "RASDetailViewController.h"
#import "RASTransitioningDelegate.h"
#import "RASDayModel.h"
#import "RASReading.h"
#import "RASLiturgy.h"
#import "RASUtils.h"

#import <DTCoreText/DTCoreText.h>


typedef NS_ENUM(NSInteger, RASCollectionSection) {
	RASCollectionSectionMain,
	RASCollectionSectionMax
};

static CGFloat const RASCollectionSmallCellHeight = 150.f;
static CGFloat const RASCollectionLargeCellHeight = 450.f;
static CGFloat const RASCollectionCellSpacing = 0.f;

@interface RASCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) RASDayModel *model;
@property (nonatomic, strong) id<UICollectionViewDataSource> dataSource;

@end

@implementation RASCollectionViewController

@synthesize model = _model;
@synthesize dataSource = _dataSource;

+ (UICollectionViewFlowLayout *)defaultLayout {
	static UICollectionViewFlowLayout *defaultInstance = nil;
	static dispatch_once_t once;
	dispatch_once(&once, ^{
		defaultInstance = [[UICollectionViewFlowLayout alloc] init];
		[defaultInstance setScrollDirection:UICollectionViewScrollDirectionVertical];
	});
	return defaultInstance;
}

- (instancetype)init {
	if (self = [self initWithCollectionViewLayout:[RASCollectionViewController defaultLayout]]) {
	}
	return self;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
	if (self = [super initWithCollectionViewLayout:layout]) {
		_dataSource = nil;
	}
	return self;
}

- (void)loadView {
	[super loadView];
	
	UICollectionView *collectionView = [self collectionView];
	[collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[collectionView setDelegate:self];
	[collectionView setDataSource:self];
	[collectionView setBackgroundColor:[UIColor clearColor]];
}

// Do any additional setup after loading the view.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	UICollectionView *collectionView = [self collectionView];
	
	// Register cell classes
	[collectionView registerClass:[RASCollectionViewCell class] forCellWithReuseIdentifier:RASCollectionViewCellReuseIdentifierSmall];
	[collectionView registerClass:[RASCollectionViewCell class] forCellWithReuseIdentifier:RASCollectionViewCellReuseIdentifierLarge];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// Load data model
	[RASDayModel loadForDay:[NSDate date]];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:RASDayModelDidLoadNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reload:(id)sender {
	_model = [sender object];
	[[self collectionView] reloadData];
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	if (_model != nil) {
		return 1;
	} else {
		return 0;
	}
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	RASCollectionSection collectionSection = (RASCollectionSection)section;
	switch (collectionSection) {
		case RASCollectionSectionMain:
		{
			NSInteger numberOfItems = 0;
			if ([[_model readings] count]) {
				numberOfItems += 1;
			}
			NSInteger liturgyCount = [[_model liturgyOfTheHours] count];
			if (liturgyCount) {
				numberOfItems += liturgyCount;
			}
			if ([[_model saints] count]) {
				numberOfItems += 1;
			}
			return numberOfItems;
			break;
		}
		case RASCollectionSectionMax:
		{
			NotReached(@"Invalid section. Failing.");
			return 0;
			break;
		}
	}
}

- (RASCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	RASCollectionViewCell *cell;
	
	RASCollectionSection collectionSection = (RASCollectionSection)[indexPath section];
	NSInteger row = [indexPath item];
	switch (collectionSection) {
		case RASCollectionSectionMain:
		{
			NSArray <RASReading *> *readings = [_model readings];
			if ([readings count] && row == 0)
			{
				cell = [collectionView dequeueReusableCellWithReuseIdentifier:RASCollectionViewCellReuseIdentifierLarge forIndexPath:indexPath];
				NSString *subtitle = @"";
				for (RASReading *reading in readings) {
					subtitle = [subtitle stringByAppendingString:[NSString stringWithFormat:@"%@; ", [reading passage]]];
				}
				[cell setTitle:[_model title] subtitle:subtitle leftFooter:nil rightFooter:[_model lectionary]];
				[cell setImage:[UIImage imageNamed:@"Transfiguration of Christ"]];
				return cell;
			} else if ([[_model liturgyOfTheHours] count] && row > 0) {
				RASLiturgy *liturgy = [[_model liturgyOfTheHours] objectAtIndex:(row-1)];
				NSData *bodyData = [[liturgy body] dataUsingEncoding:NSUTF8StringEncoding];
				NSAttributedString *attrBodyString = [[NSAttributedString alloc] initWithHTMLData:bodyData documentAttributes:NULL];
				cell = [collectionView dequeueReusableCellWithReuseIdentifier:RASCollectionViewCellReuseIdentifierSmall forIndexPath:indexPath];
				[cell setTitle:[liturgy name] subtitle:[attrBodyString string] leftFooter:@"" rightFooter:@""];
				[cell setImage:[UIImage imageNamed:@"divineoffice"]];
				return cell;
			} else {
				NotReached(@"CollectionView model is screwy and the cells are messed up.");
				cell = [collectionView dequeueReusableCellWithReuseIdentifier:RASCollectionViewCellReuseIdentifierSmall forIndexPath:indexPath];
				return cell;
			}
		}
		case RASCollectionSectionMax:
		{
			NotReached(@"Invalid section. Failing.");
			return nil;
		}
	}
	return nil;
}

#pragma mark - UICollectionViewDelegate methods

// animate the cell user tapped on
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row = [indexPath item];
	NSArray <RASReading *> *readings = [_model readings];

	CGRect frameToOpenFrom = [(RASCollectionViewCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath] animateFrom];
	UIView *viewToOpenFrom = [self collectionView:collectionView cellForItemAtIndexPath:indexPath];
	
	RASTransitioningDelegate *transitionDelegate = [[RASTransitioningDelegate alloc] init];
	[transitionDelegate setOpeningFrame:frameToOpenFrom];
	[transitionDelegate setOpeningView:viewToOpenFrom];
	
	RASDetailViewController *detailViewController;
	if ([readings count] && row == 0) {
		detailViewController = [[RASDetailViewController alloc] initWithReadings:readings];
	} else if ([[_model liturgyOfTheHours] count] && row > 0) {
		detailViewController = [[RASDetailViewController alloc] initWithLiturgy:[[_model liturgyOfTheHours] objectAtIndex:(row-1)]];
	}
	
	[detailViewController setTransitioningDelegate:transitionDelegate];
	[detailViewController setModalPresentationStyle:UIModalPresentationCustom];
	[self presentViewController:detailViewController animated:YES completion:nil];
}

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

#pragma mark - UICollectionViewDelegateFlowLayout methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	if ([indexPath item] == 0) {
		return CGSizeMake([collectionView frame].size.width, RASCollectionLargeCellHeight);
	} else {
		return CGSizeMake([collectionView frame].size.width, RASCollectionSmallCellHeight);
	}
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return RASCollectionCellSpacing;
}

@end
