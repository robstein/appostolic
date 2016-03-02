//
//  RASDetailViewController.h
//  Appostolic
//
//  Created by Robert Stein on 2/28/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

@class RASReading;
@class RASLiturgy;

@interface RASDetailViewController : UICollectionViewController

- (instancetype)initWithReadings:(NSArray<RASReading *>*)readings;
- (instancetype)initWithLiturgy:(RASLiturgy *)liturgy;

@property (nonatomic, strong) NSArray<RASReading *>* readings;
@property (nonatomic, strong) RASLiturgy *liturgy;

@end
