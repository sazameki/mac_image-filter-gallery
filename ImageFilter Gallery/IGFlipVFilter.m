//
//  IGFlipVFilter.m
//  ImageFilter Gallery
//
//  Created by numata on 2013/06/23.
//  Copyright (c) 2013 Sazameki and Satoshi Numata, Ph.D. All rights reserved.
//

#import "IGFlipVFilter.h"


@implementation IGFlipVFilter

+ (NSString *)displayName
{
    return @"Flip Vertically";
}

+ (NSString *)kernelSourceName
{
    return @"filterkernel_flip_v";
}

@end

