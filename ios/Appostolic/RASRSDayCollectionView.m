//
//  RASRSDayCollectionView.m
//  Appostolic
//
//  Created by Robert Stein on 2/14/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import "RASRSDayCollectionView.h"

@interface RASRSDayCollectionView () <UICollectionViewDataSource>

@end

@implementation RASRSDayCollectionView

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

@end
