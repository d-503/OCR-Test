//
//  FrameTrasformations.m
//
//  Created by user on 20.04.12.
//  Copyright (c) 2012 Polecat. All rights reserved.
//

#import "FrameTransformations.h"

void adjustViewHeight(UIView *view, CGFloat height)
{
    view.frame = CGRectMake(view.frame.origin.x,
                            view.frame.origin.y,
                            view.frame.size.width,
                            height);
}

void placeViewAboveView(UIView *viewToPlace, UIView *anchorView, CGFloat distanceBetweenViews)
{
    viewToPlace.frame = CGRectMake(viewToPlace.frame.origin.x,
                                anchorView.frame.origin.y - distanceBetweenViews - viewToPlace.frame.size.height,
                                viewToPlace.frame.size.width,
                                viewToPlace.frame.size.height);
}

void placeViewBelowView(UIView *viewToPlace, UIView *anchorView, CGFloat distanceBetweenViews)
{
    viewToPlace.frame = CGRectMake(viewToPlace.frame.origin.x,
                                   anchorView.frame.origin.y + anchorView.frame.size.height + distanceBetweenViews,
                                   viewToPlace.frame.size.width,
                                   viewToPlace.frame.size.height);
}

void resizeViewToIncludeViewByHeight(UIView *viewToResize, UIView *viewToInclude, CGFloat bottomGap)
{
    viewToResize.frame = CGRectMake(viewToResize.frame.origin.x,
                                    viewToResize.frame.origin.y,
                                    viewToResize.frame.size.width,
                                    viewToInclude.frame.origin.y + viewToInclude.frame.size.height + bottomGap);
}
