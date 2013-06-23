//
//  SZMKFlippedClipView.m
//  ImageFilter Gallery
//
//  Created by numata on 2013/06/22.
//  Copyright (c) 2013 Sazameki and Satoshi Numata, Ph.D. All rights reserved.
//

#import "SZMKFlippedClipView.h"


@implementation SZMKFlippedClipView

+ (void)setupClipView:(NSClipView *)clipView
{
    NSClipView *newClipView = [[SZMKFlippedClipView alloc] initWithFrame:clipView.frame];
    newClipView.drawsBackground = clipView.drawsBackground;
    newClipView.backgroundColor = clipView.backgroundColor;
    newClipView.documentView = clipView.documentView;
    newClipView.translatesAutoresizingMaskIntoConstraints = NO;

    NSScrollView *scrollView = (NSScrollView *)clipView.superview;
    scrollView.contentView = newClipView;
}

- (BOOL)isFlipped
{
    return YES;
}

@end

