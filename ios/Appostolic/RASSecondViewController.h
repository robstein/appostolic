//
//  RASSecondViewController.h
//  Appostolic
//
//  Created by Robert Stein on 3/6/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

@class RASLiturgy;

@interface RASSecondViewController : UICollectionViewController

@property (nonatomic, strong) NSArray <RASLiturgy *> *liturgies;

- (instancetype)initWithLiturgies:(NSArray<RASLiturgy *>*)liturgies;

@end
