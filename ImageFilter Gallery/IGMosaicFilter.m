//
//  IGMosaicFilter.m
//  ImageFilter Gallery
//
//  Created by numata on 2013/06/23.
//  Copyright (c) 2013 Sazameki and Satoshi Numata, Ph.D. All rights reserved.
//

#import "IGMosaicFilter.h"


@implementation IGMosaicFilter

+ (NSString *)displayName
{
    return @"Mosaic";
}

+ (NSString *)kernelSourceName
{
    return @"filterkernel_mosaic";
}

- (NSArray *)argumentDescriptions
{
    return @[
             @{
                 @"inputSize":
                     @{
                         kCIAttributeMin: @1.0,
                         kCIAttributeMax: @50.0,
                         kCIAttributeDefault: @5.0,
                         }
                 },
             ];
}

- (NSArray *)argumentObjects
{
    return @[inputSize];
}

@end
