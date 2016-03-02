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

static const CGFloat RASDetailViewControllerTitleFontSize = 20.f;
static const CGFloat RASDetailViewControllerSubtitleFontSize = 9.f;
static const CGFloat RASDetailViewControllerBodyFontSize = 12.f;

static const CGFloat RASDetailViewCellSpacing = 8.f;

@interface RASDetailViewController ()

@end

@implementation RASDetailViewController

@synthesize readings = _readings;
@synthesize liturgy = _liturgy;

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

/*- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIView *view = [self view];
	[view setBackgroundColor:[UIColor whiteColor]];
	
	if (_readings != nil) {
		UIView *lastReadingView = nil;
		for (RASReading *reading in _readings) {
			UIView *readingView = [[UIView alloc] initWithFrame:CGRectZero];
			[readingView setTranslatesAutoresizingMaskIntoConstraints:NO];
			
			UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
			UILabel *subtitle = [[UILabel alloc] initWithFrame:CGRectZero];
			UILabel *body = [[UILabel alloc] initWithFrame:CGRectZero];
			[title setTranslatesAutoresizingMaskIntoConstraints:NO];
			[subtitle setTranslatesAutoresizingMaskIntoConstraints:NO];
			[body setTranslatesAutoresizingMaskIntoConstraints:NO];
			
			NSData *bodyData = [[reading body] dataUsingEncoding:NSUTF8StringEncoding];
			NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:bodyData documentAttributes:NULL];
			
			[title setText:[reading name]];
			[subtitle setText:[reading passage]];
			[body setText:[attrString string]];
			
			[title setFont:[UIFont systemFontOfSize:RASDetailViewControllerTitleFontSize]];
			[subtitle setFont:[UIFont systemFontOfSize:RASDetailViewControllerSubtitleFontSize]];
			[body setFont:[UIFont systemFontOfSize:RASDetailViewControllerBodyFontSize]];
			[body setLineBreakMode:NSLineBreakByWordWrapping];
			[body setNumberOfLines:0];
			
			[readingView addSubview:title];
			[readingView addSubview:subtitle];
			[readingView addSubview:body];
			
			NSDictionary *views = NSDictionaryOfVariableBindings(title, subtitle, body);
			NSArray<NSLayoutConstraint *> *constraints = [[NSArray alloc] init];
			constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[title]-[subtitle]-[body]" options:NSLayoutFormatAlignAllLeading metrics:nil views:views]];
			constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[title]" options:0 metrics:nil views:views]];
			[readingView addConstraints:constraints];
			
			[view addSubview:readingView];
			if (lastReadingView != nil) {
				NSDictionary *readingViews = NSDictionaryOfVariableBindings(readingView, lastReadingView);
				NSArray<NSLayoutConstraint *> *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastReadingView]-[readingView]" options:0 metrics:nil views:readingViews];
				[view addConstraints:constraints];
			}
			lastReadingView = readingView;
			break;
		}
	} else if (_liturgy != nil) {
		UIView *liturgyView = [[UIView alloc] initWithFrame:CGRectZero];
		[liturgyView setTranslatesAutoresizingMaskIntoConstraints:NO];
		
		UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
		UILabel *body = [[UILabel alloc] initWithFrame:CGRectZero];
		[title setTranslatesAutoresizingMaskIntoConstraints:NO];
		[body setTranslatesAutoresizingMaskIntoConstraints:NO];
		
		[title setText:[_liturgy name]];
		NSData *bodyData = [[_liturgy body] dataUsingEncoding:NSUTF8StringEncoding];
		NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:bodyData documentAttributes:NULL];
		[body setText:[attrString string]];
		
		[title setFont:[UIFont systemFontOfSize:RASDetailViewControllerTitleFontSize]];
		[body setFont:[UIFont systemFontOfSize:RASDetailViewControllerBodyFontSize]];
		[body setLineBreakMode:NSLineBreakByWordWrapping];
		[body setNumberOfLines:0];
		
		[liturgyView addSubview:title];
		[liturgyView addSubview:body];
		
		NSDictionary *views = NSDictionaryOfVariableBindings(title, body);
		NSArray<NSLayoutConstraint *> *constraints = [[NSArray alloc] init];
		constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[title]-[body]" options:NSLayoutFormatAlignAllLeading metrics:nil views:views]];
		constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[title]" options:0 metrics:nil views:views]];
		[liturgyView addConstraints:constraints];
		
		[view addSubview:liturgyView];
	}
	
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
	[view addGestureRecognizer:tapRecognizer];
}*/

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
	}else {
		return 0;
	}
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return 1;
}

- (RASDetailViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
	/*RASFrontViewCell *cell;
	
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
				cell = [collectionView dequeueReusableCellWithReuseIdentifier:RASCollectionViewCellReuseIdentifierSmall forIndexPath:indexPath];
				[cell setTitle:@"Liturgy of the Hours" subtitle:@"Lord, open my lips. — And my mouth will proclaim your praise.\nAnt. Come, let us worship Christ the Lord, who for our sake endured temptation and suffering." leftFooter:@"" rightFooter:@""];
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
	return nil;*/
}

#pragma mark - UICollectionViewDelegateFlowLayout methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	return UIEdgeInsetsMake(10.f, 10.f, 10.f, 10.f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return RASDetailViewCellSpacing;
}

@end
