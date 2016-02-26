//
//  RASCollectionViewController.m
//  Appostolic
//
//  Created by Robert Stein on 2/19/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "RASCollectionViewController.h"
#import "RASCollectionViewCell.h"
#import "RASDayModel.h"

#import "RASStubCollectionViewDataSource.h"

typedef NS_ENUM(NSInteger, RASCollectionSection) {
	RASCollectionSectionMain,
	RASCollectionSectionMax
};

static CGFloat const RASCollectionSmallCellHeight = 150.f;
static CGFloat const RASCollectionCellSpacing = 4.f;

@interface RASCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) RASDayModel *model;
@property (nonatomic, strong) id<UICollectionViewDataSource> dataSource;

@end

@implementation RASCollectionViewController

@synthesize model = _model;
@synthesize dataSource = _dataSource;

static NSString *const reuseIdentifierSmallCell = @"reuseIdentifierSmallCell";

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
		_dataSource = [[RASStubCollectionViewDataSource alloc] init];
	}
	return self;
}

- (void)loadView {
	[super loadView];
	
	UICollectionView *collectionView = [self collectionView];
	[collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[collectionView setDelegate:self];
	//[collectionView setDataSource:self];
	[collectionView setDataSource:_dataSource];
	[collectionView setBackgroundColor:[UIColor clearColor]];
}

// Do any additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UICollectionView *collectionView = [self collectionView];
	
    // Register cell classes
    [collectionView registerClass:[RASCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifierSmallCell];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// Load data model
	[_model loadDay:[NSDate date]];
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
	// TODO
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	if (collectionView == [self collectionView]) {
		NSInteger numberOfSections = 0;
		if ([[_model readings] count]) {
			numberOfSections += 1;
		}
		NSInteger liturgyCount = [[_model liturgyOfTheHours] count];
		if (liturgyCount) {
			numberOfSections += liturgyCount;
		}
		if ([[_model saints] count]) {
			numberOfSections += 1;
		}
		return numberOfSections;
	}
	NSLog(@"Error: expected collectionView is not consistent with actual collectionView. Failing.");
	return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	if (collectionView == [self collectionView]) {
		NSInteger numberOfSections = [self numberOfSectionsInCollectionView:collectionView];
		if (numberOfSections == RASCollectionSectionMax) {
			RASCollectionSection collectionSection = (RASCollectionSection)section;
			switch (collectionSection) {
				case RASCollectionSectionMain:
					return [[_model readings] count];
					break;
				case RASCollectionSectionMax:
					NSLog(@"Invalid section. Failing.");
					return 0;
					break;
			}
		} else {
			NSLog(@"Expected number of sections is not consistent with actual number. Failing.");
			return 0;
		}
	}
	NSLog(@"Error: expected collectionView is not consistent with actual collectionView. Failing.");
	return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierSmallCell forIndexPath:indexPath];
    // Configure the cell
    
    return cell;
}

#pragma mark - UICollectionViewDelegate methods

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

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
	return CGSizeMake([collectionView frame].size.width, RASCollectionSmallCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return RASCollectionCellSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return CGFLOAT_MIN;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
	return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
	return CGSizeZero;
}

@end
