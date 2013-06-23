//
//  IGSatControlFilter.m
//  ImageFilter Gallery
//
//  Created by numata on 2013/06/24.
//  Copyright (c) 2013 Sazameki and Satoshi Numata, Ph.D. All rights reserved.
//

#import "IGSatControlFilter.h"


@implementation IGSatControlFilter

+ (NSString *)displayName
{
    return @"Saturation Control";
}

+ (NSString *)kernelSourceName
{
    return @"filterkernel_satcontrol";
}

- (NSArray *)argumentDescriptions
{
    return @[
             @{
                 @"inputSat":
                     @{
                         kCIAttributeMin: @0.0,
                         kCIAttributeMax: @1.0,
                         kCIAttributeDefault: @0.5,
                         }
                 },
             ];
}

- (NSArray *)argumentObjects
{
    return @[inputSat];
}

@end

