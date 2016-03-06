//
//  RASSecondViewController.m
//  Appostolic
//
//  Created by Robert Stein on 3/6/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "RASSecondViewController.h"
#import "RASDetailViewController.h"
#import "RASLiturgy.h"
#import "RASFrontViewCell.h"

#import <DTCoreText/DTCoreText.h>

static const CGFloat RASCollectionSmallCellHeight = 150.f;
static const CGFloat RASCollectionLargeCellHeight = 450.f;
static const CGFloat RASCollectionCellSpacing = 0.f;

@interface RASSecondViewController ()

@end

@implementation RASSecondViewController

@synthesize liturgies = _liturgies;

+ (UICollectionViewFlowLayout *)defaultLayout {
	static UICollectionViewFlowLayout *defaultInstance = nil;
	static dispatch_once_t once;
	dispatch_once(&once, ^{
		defaultInstance = [[UICollectionViewFlowLayout alloc] init];
		[defaultInstance setScrollDirection:UICollectionViewScrollDirectionVertical];
	});
	return defaultInstance;
}

+ (RASSecondViewController *)defaultController {
	static RASSecondViewController *defaultInstance = nil;
	static dispatch_once_t once;
	dispatch_once(&once, ^{
		defaultInstance = [[RASSecondViewController alloc] init];
	});
	return defaultInstance;
}

- (instancetype)initWithLiturgies:(NSArray<RASLiturgy *>*)liturgies {
	if (self = [self init]) {
		_liturgies = [RASLiturgy liturgyArrayBySortingTimeOfDay:liturgies];
	}
	return self;
}

- (instancetype)init {
	if (self = [self initWithCollectionViewLayout:[RASSecondViewController defaultLayout]]) {
	}
	return self;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
	if (self = [super initWithCollectionViewLayout:layout]) {
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
	[collectionView registerClass:[RASFrontViewCell class] forCellWithReuseIdentifier:RASFrontViewCellReuseIdentifierSmall];
	[collectionView registerClass:[RASFrontViewCell class] forCellWithReuseIdentifier:RASFrontViewCellReuseIdentifierLarge];
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	if (_liturgies != nil) {
		return 1;
	}
	return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [_liturgies count];
}

- (RASFrontViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row = [indexPath item];
	RASLiturgy *liturgy = [_liturgies objectAtIndex:row];
	RASFrontViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RASFrontViewCellReuseIdentifierSmall forIndexPath:indexPath];
	
	NSData *bodyData = [[liturgy body] dataUsingEncoding:NSUTF8StringEncoding];
	NSAttributedString *bodyAttrString = [[NSAttributedString alloc] initWithHTMLData:bodyData documentAttributes:NULL];
	
	[cell setTitle:[liturgy name] subtitle:[bodyAttrString string] leftFooter:@"" rightFooter:[liturgy timeOfDay]];
	[cell setImage:[UIImage imageNamed:@"divineoffice"]];
	return cell;
}

#pragma mark - UICollectionViewDelegate methods

// animate the cell user tapped on
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row = [indexPath item];
	RASLiturgy *liturgy = [_liturgies objectAtIndex:row];
	RASDetailViewController *detailViewController = [[RASDetailViewController alloc] initWithLiturgy:liturgy];
	[[self navigationController] pushViewController:detailViewController animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return CGSizeMake([collectionView frame].size.width, RASCollectionSmallCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return RASCollectionCellSpacing;
}

@end
