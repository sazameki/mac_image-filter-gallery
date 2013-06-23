//
//  IGHueControlFilter.m
//  ImageFilter Gallery
//
//  Created by numata on 2013/06/23.
//  Copyright (c) 2013 Sazameki and Satoshi Numata, Ph.D. All rights reserved.
//

#import "IGHueControlFilter.h"


@implementation IGHueControlFilter

+ (NSString *)displayName
{
    return @"Hue Control";
}

+ (NSString *)kernelSourceName
{
    return @"filterkernel_huecontrol";
}

- (NSArray *)argumentDescriptions
{
    return @[
             @{
                 @"inputHue":
                     @{
                         kCIAttributeMin: @0.0,
                         kCIAttributeMax: @(M_PI*2),
                         kCIAttributeDefault: @0.0,
                         }
                 },
             ];
}

- (NSArray *)argumentObjects
{
    return @[inputHue];
}

@end

