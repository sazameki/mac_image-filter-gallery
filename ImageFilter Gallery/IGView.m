//
//  IGView.m
//  ImageFilter Gallery
//
//  Created by numata on 2013/06/23.
//  Copyright (c) 2013 Sazameki and Satoshi Numata, Ph.D. All rights reserved.
//

#import "IGView.h"
#import "IGDocument.h"


@implementation IGView

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
    return YES;
}

- (BOOL)isFlipped
{
    return YES;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    NSPoint pos = [self convertPoint:theEvent.locationInWindow fromView:nil];
    [self.document setCenterPos:pos];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint pos = [self convertPoint:theEvent.locationInWindow fromView:nil];
    [self.document setCenterPos:pos];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    NSPoint pos = [self convertPoint:theEvent.locationInWindow fromView:nil];
    [self.document setCenterPos:pos];
}

@end

