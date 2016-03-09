//
//  RASDetailHeaderView.h
//  Appostolic
//
//  Created by Robert Stein on 3/8/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

extern NSString *const RASDetailHeaderViewReuseIdentifier;

@interface RASDetailHeaderView : UICollectionReusableView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
