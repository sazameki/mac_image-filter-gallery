//
//  IGFilter.m
//  ImageFilter Gallery
//
//  Created by numata on 2013/06/23.
//  Copyright (c) 2013 Sazameki and Satoshi Numata, Ph.D. All rights reserved.
//

#import "IGFilter.h"


static NSMutableDictionary *sKernelDict = nil;


@implementation IGFilter

+ (void)registerFilter
{
    if (!sKernelDict) {
        sKernelDict = @{}.mutableCopy;
    }

    NSString *className = NSStringFromClass(self);
    NSString *displayName = [self displayName];

    NSMutableDictionary *attrs = @{
        kCIAttributeFilterDisplayName: displayName,
        kCIAttributeFilterCategories: @[kCICategoryStillImage],
    }.mutableCopy;

    NSArray *argDescs = [self argumentDescriptions];
    if (argDescs) {
        for (NSDictionary *aDesc in argDescs) {
            [attrs addEntriesFromDictionary:aDesc];
        }
    }

    [CIFilter registerFilterName:className
                     constructor:(id<CIFilterConstructor>)self
                 classAttributes:attrs];
}

+ (NSString *)displayName
{
    return nil;
}

+ (NSString *)kernelSourceName
{
    return nil;
}

+ (NSArray *)argumentDescriptions
{
    return nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        CIKernel *kernel = sKernelDict[NSStringFromClass(self.class)];
        if (!kernel) {
            NSString *sourceName = [self.class kernelSourceName];
            NSURL *fileURL = [[NSBundle mainBundle] URLForResource:sourceName withExtension:@"txt"];
            NSError *error = nil;
            if (![fileURL checkResourceIsReachableAndReturnError:&error]) {
                NSLog(@"Cannot find filter kernel source file: %@.txt", sourceName);
                return nil;
            }

            NSString *sourceStr = [NSString stringWithContentsOfURL:fileURL
                                                           encoding:NSUTF8StringEncoding
                                                              error:&error];
            if (!sourceStr) {
                NSLog(@"Failed to load filter kernel source file: %@.txt", sourceName);
                return nil;
            }

            NSArray *kernels = [CIKernel kernelsWithString:sourceStr];
            if (kernels.count != 1) {
                NSLog(@"Failed to load filter kernel: %@.txt", sourceName);
            }
            sKernelDict[NSStringFromClass(self.class)] = kernels[0];
        }
    }
    return self;
}

+ (CIFilter *)filterWithName:(NSString *)name
{
    return [[self alloc] init];
}

- (CIKernel *)kernel
{
    return sKernelDict[NSStringFromClass(self.class)];
}

- (NSArray *)argumentObjects
{
    return nil;
}

- (CIImage *)outputImage
{
    CISampler *src = [CISampler samplerWithImage:inputImage];

    NSMutableArray *args = @[src].mutableCopy;
    NSArray *additionalArgs = self.argumentObjects;
    if (additionalArgs) {
        [args addObjectsFromArray:additionalArgs];
    }

    return [self apply:self.kernel arguments:args options:nil];
}

@end

