//
//  RASFrontViewController.m
//  Appostolic
//
//  Created by Robert Stein on 2/19/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "RASFrontViewController.h"
#import "RASFrontViewCell.h"
#import "RASDetailViewController.h"
#import "RASTransitioningDelegate.h"
#import "RASDayModel.h"
#import "RASReading.h"
#import "RASLiturgy.h"
#import "RASUtils.h"
#import "UIViewController+RASTitleExtensions.h"

#import <DTCoreText/DTCoreText.h>

static NSString *const RASTabNameToday = @"Today";
static NSString *const RASTabImageNameToday = @"Home";


typedef NS_ENUM(NSInteger, RASCollectionSection) {
	RASCollectionSectionMain,
	RASCollectionSectionMax
};

static const CGFloat RASCollectionSmallCellHeight = 150.f;
static const CGFloat RASCollectionLargeCellHeight = 450.f;
static const CGFloat RASCollectionCellSpacing = 0.f;
static const NSTimeInterval RASSecondsInADay = 86400.f;

@interface RASFrontViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) RASDayModel *model;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) id<UICollectionViewDataSource> dataSource;

@end

@implementation RASFrontViewController

@synthesize model = _model;
@synthesize date = _date;
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

+ (RASFrontViewController *)defaultController {
	static RASFrontViewController *defaultInstance = nil;
	static dispatch_once_t once;
	dispatch_once(&once, ^{
		defaultInstance = [[RASFrontViewController alloc] initWithTitle:RASTabNameToday tabBarItemImage:[UIImage imageNamed:RASTabImageNameToday]];
	});
	return defaultInstance;
}

+ (UINavigationController *)defaultNavigationController {
	RASFrontViewController *defaultController = [self defaultController];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:defaultController];
	[navigationController setToolbarHidden:NO];
	
	UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:defaultController action:@selector(barButtonRewind:)];
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:defaultController action:@selector(barButtonFastForward:)];
	UIBarButtonItem *flexibleSpaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[defaultController setToolbarItems:[NSArray arrayWithObjects:leftButton, flexibleSpaceButton, rightButton, nil]];
	
	return navigationController;
}

- (void)barButtonRewind:(id)sender {
	NSDate *yesterday = [_date dateByAddingTimeInterval:0-RASSecondsInADay];
	[self setDate:yesterday];
	[self loadDay];
	[self updateTitle];
}

- (void)barButtonFastForward:(id)sender {
	NSDate *tomorrow = [_date dateByAddingTimeInterval:0+RASSecondsInADay];
	[self setDate:tomorrow];
	[self loadDay];
	[self updateTitle];
}

- (void)updateTitle {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setLocale:[NSLocale currentLocale]];
	[dateFormatter setDoesRelativeDateFormatting:YES];
	[self setTitle:[dateFormatter stringFromDate:_date]];
}

- (instancetype)init {
	if (self = [self initWithCollectionViewLayout:[RASFrontViewController defaultLayout]]) {
	}
	return self;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
	if (self = [super initWithCollectionViewLayout:layout]) {
		_date = [NSDate date];
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
	[collectionView registerClass:[RASFrontViewCell class] forCellWithReuseIdentifier:RASFrontViewCellReuseIdentifierSmall];
	[collectionView registerClass:[RASFrontViewCell class] forCellWithReuseIdentifier:RASFrontViewCellReuseIdentifierLarge];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// Load day
	[self loadDay];
}

- (void)loadDay {
	[RASDayModel loadForDay:_date];
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
			if ([[_model liturgyOfTheHours] count]) {
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

- (RASFrontViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	RASFrontViewCell *cell;
	
	RASCollectionSection collectionSection = (RASCollectionSection)[indexPath section];
	NSInteger row = [indexPath item];
	switch (collectionSection) {
		case RASCollectionSectionMain:
		{
			NSArray <RASReading *> *readings = [_model readings];
			if ([readings count] && row == 0)
			{
				cell = [collectionView dequeueReusableCellWithReuseIdentifier:RASFrontViewCellReuseIdentifierLarge forIndexPath:indexPath];
				NSString *subtitle = @"";
				for (RASReading *reading in readings) {
					if ([[reading name] isEqualToString:@"Gospel"]) {
						NSData *bodyData = [[reading body] dataUsingEncoding:NSUTF8StringEncoding];
						NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:bodyData documentAttributes:NULL];
						subtitle = [attrString string];
					}
				}
				[cell setTitle:[_model title] subtitle:subtitle leftFooter:nil rightFooter:[_model lectionary]];
				[cell setImage:[UIImage imageNamed:@"Transfiguration of Christ"]];
				return cell;
			} else if ([[_model liturgyOfTheHours] count] && row > 0) {
				cell = [collectionView dequeueReusableCellWithReuseIdentifier:RASFrontViewCellReuseIdentifierSmall forIndexPath:indexPath];
				[cell setTitle:@"Liturgy of the Hours" subtitle:@"Lord, open my lips. — And my mouth will proclaim your praise.\nAnt. Come, let us worship Christ the Lord, who for our sake endured temptation and suffering." leftFooter:@"" rightFooter:@""];
				[cell setImage:[UIImage imageNamed:@"divineoffice"]];
				return cell;
			} else {
				NotReached(@"CollectionView model is screwy and the cells are messed up.");
				cell = [collectionView dequeueReusableCellWithReuseIdentifier:RASFrontViewCellReuseIdentifierSmall forIndexPath:indexPath];
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

	RASDetailViewController *detailViewController;
	if ([readings count] && row == 0) {
		detailViewController = [[RASDetailViewController alloc] initWithReadings:readings];
	} else if ([[_model liturgyOfTheHours] count] && row > 0) {
		detailViewController = [[RASDetailViewController alloc] initWithLiturgy:[[_model liturgyOfTheHours] objectAtIndex:(row-1)]];
	}

	[[self navigationController] pushViewController:detailViewController animated:YES];
}

/* TODO When you implement action menus
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
