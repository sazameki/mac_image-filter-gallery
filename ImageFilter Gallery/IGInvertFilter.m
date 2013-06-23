//
//  IGInvertFilter.m
//  ImageFilter Gallery
//
//  Created by numata on 2013/06/23.
//  Copyright (c) 2013 Sazameki and Satoshi Numata, Ph.D. All rights reserved.
//

#import "IGInvertFilter.h"


@implementation IGInvertFilter

+ (NSString *)displayName
{
    return @"Invert";
}

+ (NSString *)kernelSourceName
{
    return @"filterkernel_invert";
}

@end

