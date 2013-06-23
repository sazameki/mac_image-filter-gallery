//
//  IGGrayscaleFilter.m
//  ImageFilter Gallery
//
//  Created by numata on 2013/06/23.
//  Copyright (c) 2013 Sazameki and Satoshi Numata, Ph.D. All rights reserved.
//

#import "IGGrayscaleFilter.h"


@implementation IGGrayscaleFilter

+ (NSString *)displayName
{
    return @"Grayscale";
}

+ (NSString *)kernelSourceName
{
    return @"filterkernel_grayscale";
}

@end

