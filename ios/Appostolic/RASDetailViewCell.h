//
//  RASDetailViewCell.h
//  Appostolic
//
//  Created by Robert Stein on 3/1/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

extern NSString *const RASDetailViewCellReuseIdentifier;

@interface RASDetailViewCell : UICollectionViewCell

// Can either be a RASReading or RASLiturgy
@property (nonatomic, copy) NSString *text;

@end
