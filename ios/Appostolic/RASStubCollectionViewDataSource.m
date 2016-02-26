//
//  RASStubCollectionViewDataSource.m
//  Appostolic
//
//  Created by Robert Stein on 2/23/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "RASStubCollectionViewDataSource.h"
#import "RASCollectionViewCell.h"

@implementation RASStubCollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	RASCollectionViewCell *cell;
	
	if ([indexPath item] == 0) {
		cell = [collectionView dequeueReusableCellWithReuseIdentifier:RASCollectionViewCellReuseIdentifierLarge forIndexPath:indexPath];
	} else {
		cell = [collectionView dequeueReusableCellWithReuseIdentifier:RASCollectionViewCellReuseIdentifierSmall forIndexPath:indexPath];
	}
	

	// Configure the cell
	[cell setTitle:@"At Nevada Caucuses, Donald Trump's Rivals Hope to Break His Streak Let's Make This Title A Little Bit Longer" subtitle:@"It will be a test of Mr. Trump's blah blah blah yes and blah blah blah hey what's up hello seent your pretety a** since you walked in the door" leftFooter:@"The New York Times" rightFooter:@"Top Story"];
	if ([indexPath item] == 0) {
		[cell setImage:[UIImage imageNamed:@"Transfiguration of Christ"]];
	}
	

	return cell;
}

@end
