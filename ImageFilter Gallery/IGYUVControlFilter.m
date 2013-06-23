//
//  IGYUVControlFilter.m
//  ImageFilter Gallery
//
//  Created by numata on 2013/06/23.
//  Copyright (c) 2013 Sazameki and Satoshi Numata, Ph.D. All rights reserved.
//

#import "IGYUVControlFilter.h"


@implementation IGYUVControlFilter

+ (NSString *)displayName
{
    return @"YUV Control";
}

+ (NSString *)kernelSourceName
{
    return @"filterkernel_yuvcontrol";
}

- (NSArray *)argumentDescriptions
{
    return @[
             @{
                 @"inputU":
                     @{
                         kCIAttributeMin: @-0.5,
                         kCIAttributeMax: @0.5,
                         kCIAttributeDefault: @0.0,
                         }
                 },
             @{
                 @"inputV":
                     @{
                         kCIAttributeMin: @-0.5,
                         kCIAttributeMax: @0.5,
                         kCIAttributeDefault: @0.0,
                         }
                 },
             ];
}

- (NSArray *)argumentObjects
{
    return @[inputU, inputV];
}

@end

