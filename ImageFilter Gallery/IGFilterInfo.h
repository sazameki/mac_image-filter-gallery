//
//  IGFilterInfo.h
//  ImageFilter Gallery
//
//  Created by numata on 2013/06/22.
//  Copyright (c) 2013 Sazameki and Satoshi Numata, Ph.D. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


@interface IGFilterInfo : NSObject

@property (readwrite) BOOL  enabled;

- (id)initWithFilterTag:(int)tag;

- (BOOL)hasFilter1;
- (NSString *)filterName;
- (NSString *)paramDisplayName;
- (float)minValue;
- (float)maxValue;
- (float)paramValue;
- (void)setParamValue:(float)value;

- (BOOL)hasFilter2;
- (NSString *)filterName2;
- (NSString *)paramDisplayName2;
- (float)minValue2;
- (float)maxValue2;
- (float)paramValue2;
- (void)setParamValue2:(float)value;

- (BOOL)hasFilter3;
- (NSString *)filterName3;
- (NSString *)paramDisplayName3;
- (float)minValue3;
- (float)maxValue3;
- (float)paramValue3;
- (void)setParamValue3:(float)value;

- (BOOL)hasFilter4;
- (NSString *)filterName4;
- (NSString *)paramDisplayName4;
- (float)minValue4;
- (float)maxValue4;
- (float)paramValue4;
- (void)setParamValue4:(float)value;

- (BOOL)setCenterPos:(NSPoint)pos;

- (CIImage *)filteredImageForImage:(CIImage *)image imageSize:(NSSize)imageSize;

@end

