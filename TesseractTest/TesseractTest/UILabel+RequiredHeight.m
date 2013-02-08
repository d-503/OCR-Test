//
//  UILabel+requiredHeight.m
//  TesseractTest
//
//  Created by Edward Khorkov on 08.02.13.
//  Copyright (c) 2013 Polecat. All rights reserved.
//

#import "UILabel+requiredHeight.h"

@implementation UILabel (RequiredHeight)

- (CGFloat)requiredHeight {
    return [self.text sizeWithFont:self.font
                 constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)
                     lineBreakMode:self.lineBreakMode].height;
}

- (void)resizeToRequireHeight {
    CGRect frame = self.frame;
    frame.size.height = [self requiredHeight];
    self.frame = frame;
}


@end
