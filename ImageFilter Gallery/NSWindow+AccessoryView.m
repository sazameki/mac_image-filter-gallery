//
//  NSWindow+AccessoryView.m
//  ImageFilter Gallery
//
//  Created by numata on 2013/06/23.
//  Copyright (c) 2013 Sazameki and Satoshi Numata, Ph.D. All rights reserved.
//

#import "NSWindow+AccessoryView.h"


@implementation NSWindow (AccessoryView)

-(void)addViewToTitleBar:(NSView *)view atXPosition:(CGFloat)x
{
    view.frame = NSMakeRect(x, [[self contentView] frame].size.height,
                                 view.frame.size.width, [self heightOfTitleBar]);

    NSUInteger mask = 0;
    if (x > self.frame.size.width / 2.0) {
        mask |= NSViewMinXMargin;
    } else {
        mask |= NSViewMaxXMargin;
    }
    [view setAutoresizingMask:mask | NSViewMinYMargin];

    [[[self contentView] superview] addSubview:view];
}

-(CGFloat)heightOfTitleBar
{
    NSRect outerFrame = [[[self contentView] superview] frame];
    NSRect innerFrame = [[self contentView] frame];
    return outerFrame.size.height - innerFrame.size.height;
}

@end

