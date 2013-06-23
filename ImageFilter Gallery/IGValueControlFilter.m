//
//  IGValueControlFilter.m
//  ImageFilter Gallery
//
//  Created by numata on 2013/06/24.
//  Copyright (c) 2013 Sazameki and Satoshi Numata, Ph.D. All rights reserved.
//

#import "IGValueControlFilter.h"


@implementation IGValueControlFilter

+ (NSString *)displayName
{
    return @"Value Control";
}

+ (NSString *)kernelSourceName
{
    return @"filterkernel_valuecontrol";
}

- (NSArray *)argumentDescriptions
{
    return @[
             @{
                 @"inputValue":
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
    return @[inputValue];
}

@end

