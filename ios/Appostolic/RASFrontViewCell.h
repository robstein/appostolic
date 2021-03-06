//
//  RASFrontViewCell.h
//  Appostolic
//
//  Created by Robert Stein on 2/23/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

extern NSString *const RASFrontViewCellReuseIdentifierSmall;
extern NSString *const RASFrontViewCellReuseIdentifierLarge;

@interface RASFrontViewCell : UICollectionViewCell

- (void)setTitle:(NSString *)title subtitle:(NSString *)subtitle leftFooter:(NSString *)leftText rightFooter:(NSString *)rightText;
- (void)setImage:(UIImage *)image;

- (CGRect)animateFrom;

@end
