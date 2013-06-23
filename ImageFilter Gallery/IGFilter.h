//
//  IGFilter.h
//  ImageFilter Gallery
//
//  Created by numata on 2013/06/23.
//  Copyright (c) 2013 Sazameki and Satoshi Numata, Ph.D. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>


@interface IGFilter : CIFilter {
    CIImage   *inputImage;
}

+ (void)registerFilter;

+ (NSString *)displayName;
+ (NSString *)kernelSourceName;
+ (NSArray *)argumentDescriptions;

- (NSArray *)argumentObjects;
- (CIKernel *)kernel;

@end

