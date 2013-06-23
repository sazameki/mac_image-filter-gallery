//
//  IGSplitFilter.m
//  ImageFilter Gallery
//
//  Created by numata on 2013/06/23.
//  Copyright (c) 2013 Sazameki and Satoshi Numata, Ph.D. All rights reserved.
//

#import "IGSplitFilter.h"


@implementation IGSplitFilter

+ (NSString *)displayName
{
    return @"Split";
}

+ (NSString *)kernelSourceName
{
    return @"filterkernel_split";
}

- (NSArray *)argumentDescriptions
{
    return @[
             @{
                 @"inputDivX":
                     @{
                         kCIAttributeMin: @2.0,
                         kCIAttributeMax: @8.0,
                         kCIAttributeDefault: @2,
                         }
                 },
             @{
                 @"inputDivY":
                     @{
                         kCIAttributeMin: @2.0,
                         kCIAttributeMax: @8.0,
                         kCIAttributeDefault: @2,
                         }
                 },
             ];
}

- (NSArray *)argumentObjects
{
    return @[inputDivX, inputDivY];
}

@end

