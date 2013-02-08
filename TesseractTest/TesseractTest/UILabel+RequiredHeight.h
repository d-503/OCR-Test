//
//  UILabel+requiredHeight.h
//  TesseractTest
//
//  Created by Edward Khorkov on 08.02.13.
//  Copyright (c) 2013 Polecat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (RequiredHeight)

- (CGFloat)requiredHeight;

- (void)resizeToRequireHeight;

@end
