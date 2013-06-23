//
//  NSMutableArray+Util.m
//  ImageFilter Gallery
//
//  Created by numata on 2013/06/23.
//  Copyright (c) 2013 Sazameki and Satoshi Numata, Ph.D. All rights reserved.
//

#import "NSMutableArray+Util.h"


@implementation NSMutableArray (Util)

- (NSInteger)moveObjectAtIndex:(NSInteger)from toIndex:(NSInteger)to
{
    if (from == to) {
        return -1;
    }

    id obj = self[from];
    id dummyObj = [NSNull null];

    [self insertObject:dummyObj atIndex:to];
    [self removeObject:obj];
    NSInteger dummyIndex = [self indexOfObject:dummyObj];
    [self replaceObjectAtIndex:dummyIndex
                    withObject:obj];

    return dummyIndex;
}

@end

