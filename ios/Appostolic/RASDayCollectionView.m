//
//  RASDayCollectionView.m
//  Appostolic
//
//  Created by Robert Stein on 2/14/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "RASDayCollectionView.h"

@interface RASDayCollectionView () <UICollectionViewDataSource>

@end

@implementation RASDayCollectionView

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

@end
