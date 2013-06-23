//
//  IGBinaryFilter.m
//  ImageFilter Gallery
//
//  Created by numata on 2013/06/23.
//  Copyright (c) 2013 Sazameki and Satoshi Numata, Ph.D. All rights reserved.
//

#import "IGBinaryFilter.h"


@implementation IGBinaryFilter

+ (NSString *)displayName
{
    return @"Binary";
}

+ (NSString *)kernelSourceName
{
    return @"filterkernel_binary";
}

- (NSArray *)argumentDescriptions
{
    return @[
        @{
            @"inputThreshold":
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
    return @[inputThreshold];
}

@end

