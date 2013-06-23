//
//  IGNaiveGrayscaleFilter.m
//  ImageFilter Gallery
//
//  Created by numata on 2013/06/23.
//  Copyright (c) 2013 Sazameki and Satoshi Numata, Ph.D. All rights reserved.
//

#import "IGNaiveGrayscaleFilter.h"


@implementation IGNaiveGrayscaleFilter

+ (NSString *)displayName
{
    return @"Naive Grayscale";
}

+ (NSString *)kernelSourceName
{
    return @"filterkernel_grayscale_naive";
}

@end

