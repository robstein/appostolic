//
//  PreviewButton.h
//  Appostolic
//
//  Created by Robert Stein on 1/13/16.
//  Copyright © 2016 Rob Stein. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PreviewButtonHalf,
    PreviewButtonFull
} PreviewButtonStyle;

@interface PreviewButton : UIView

@property (nonatomic) PreviewButtonStyle previewStyle;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UILabel *bodyText;


@end
