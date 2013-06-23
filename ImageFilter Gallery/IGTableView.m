//
//  IGTableView.m
//  ImageFilter Gallery
//
//  Created by numata on 2013/06/23.
//  Copyright (c) 2013 Sazameki and Satoshi Numata, Ph.D. All rights reserved.
//

#import "IGTableView.h"


@implementation IGTableView

- (void)keyDown:(NSEvent *)theEvent
{
    NSString *str = theEvent.charactersIgnoringModifiers;
    if (str.length <= 0) {
        return;
    }
    unichar key = [str characterAtIndex:0];
    if (key == NSDeleteCharacter || key == NSBackspaceCharacter) {
        if ([self.delegate respondsToSelector:@selector(removeSelectedFilter)]) {
            [self.delegate performSelector:@selector(removeSelectedFilter)];
        }
        return;
    }
    [super keyDown:theEvent];
}

@end

