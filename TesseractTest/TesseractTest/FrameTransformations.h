//
//  FrameTransformations.h
//
//  Created by user on 20.04.12.
//  Copyright (c) 2012 Polecat. All rights reserved.
//

#ifndef InteriorPro_FrameTransformations_h
#define InteriorPro_FrameTransformations_h

#import <UIKit/UIKit.h>

void adjustViewHeight(UIView *view, CGFloat height);
void placeViewAboveView(UIView *viewToPlace, UIView *anchorView, CGFloat distanceBetweenViews);
void placeViewBelowView(UIView *viewToPlace, UIView *anchorView, CGFloat distanceBetweenViews);

void resizeViewToIncludeViewByHeight(UIView *viewToResize, UIView *viewToInclude, CGFloat bottomGap);

#endif
