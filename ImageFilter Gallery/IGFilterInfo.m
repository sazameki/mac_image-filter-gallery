//
//  IGFilterInfo.m
//  ImageFilter Gallery
//
//  Created by numata on 2013/06/22.
//  Copyright (c) 2013 Sazameki and Satoshi Numata, Ph.D. All rights reserved.
//

#import "IGFilterInfo.h"


NSArray *filterInfos;


@implementation IGFilterInfo {
    NSDictionary *filterParamInfo;
    float   paramValue;
    float   paramValue2;
    float   paramValue3;
    float   paramValue4;
    CIFilter    *ciFilterObj;
    CIFilter    *ciFilterObj2;
    CIFilter    *ciFilterObj3;
}

+ (void)initialize
{
    filterInfos = @[
        @{ @"tag":@100, @"display":@"色相・彩度・明度",
           @"filter":@"CIHueAdjust", @"name":@"inputAngle", @"param-display":@"色相",
           @"min":@0.0f, @"max":@(M_PI*2), @"default":@0.0f,
           @"filter2":@"CIColorControls", @"name2":@"inputSaturation", @"param-display2":@"彩度",
           @"min2":@0.0f, @"max2":@3.0f, @"default2":@1.0f,
           @"filter3":@"CIColorControls", @"name3":@"inputBrightness", @"param-display3":@"明度",
           @"min3":@-1.0f, @"max3":@1.0f, @"default3":@0.0f,
        },

        @{ @"tag":@101, @"display":@"ガンマ・露出・コントラスト",
           @"filter":@"CIGammaAdjust", @"name":@"inputPower", @"param-display":@"ガンマ値",
           @"min":@0.1f, @"max":@3.0f, @"default":@1.0f,
           @"filter2":@"CIExposureAdjust", @"name2":@"inputEV", @"param-display2":@"露出EV",
           @"min2":@-5.0f, @"max2":@5.0f, @"default2":@0.0f,
           @"filter3":@"CIColorControls", @"name3":@"inputContrast", @"param-display3":@"コントラスト",
           @"min3":@0.25f, @"max3":@4.0f, @"default3":@1.0f,
        },

        @{ @"tag":@200, @"display":@"ガウスぼかし",
           @"filter":@"CIGaussianBlur", @"name":@"inputRadius", @"param-display":@"ぼかし半径",
           @"min":@0.0f, @"max":@100.0f, @"default":@2.5f
        },

        @{ @"tag":@201, @"display":@"移動ぼかし",
           @"filter":@"CIMotionBlur", @"name":@"inputRadius", @"param-display":@"ぼかし半径",
           @"min":@0.0f, @"max":@100.0f, @"default":@2.5f,
           @"filter2":@"", @"name2":@"inputAngle", @"param-display2":@"ぼかし角度",
           @"min2":@0.0f, @"max2":@(M_PI*2), @"default2":@0.0f,
        },

        @{ @"tag":@300, @"display":@"グレースケール（単純平均）",
           @"filter":@"IGNaiveGrayscaleFilter",
        },
        @{ @"tag":@301, @"display":@"グレースケール（RGB特性考慮）",
           @"filter":@"IGGrayscaleFilter",
        },
        @{ @"tag":@302, @"display":@"白黒二値化",
           @"filter":@"IGBinaryFilter", @"name":@"inputThreshold", @"param-display":@"しきい値",
           @"min":@0.0f, @"max":@1.0f, @"default":@0.5f,
        },
        @{ @"tag":@303, @"display":@"色調反転",
           @"filter":@"IGInvertFilter",
           },
        @{ @"tag":@304, @"display":@"ポスタライズ",
           @"filter":@"CIColorPosterize", @"name":@"inputLevels", @"param-display":@"レベル",
           @"min":@0.0f, @"max":@30.0f, @"default":@6.0f
           },

        @{ @"tag":@400, @"display":@"画面4分割",
           @"filter":@"IGSplitFilter", @"name":@"inputDivX", @"param-display":@"X方向の分割",
           @"min":@2.0f, @"max":@8.0f, @"default":@2.0f,
           @"filter2":@"", @"name2":@"inputDivY", @"param-display2":@"Y方向の分割",
           @"min2":@2.0f, @"max2":@8.0f, @"default2":@2.0f,
        },
        @{ @"tag":@401, @"display":@"モザイク",
           @"filter":@"IGMosaicFilter", @"name":@"inputSize", @"param-display":@"サイズ",
           @"min":@1.0f, @"max":@50.0f, @"default":@5.0f,
           },
        @{ @"tag":@402, @"display":@"色相の統一",
           @"filter":@"IGHueControlFilter", @"name":@"inputHue", @"param-display":@"色相",
           @"min":@0.0f, @"max":@(M_PI*2), @"default":@0.0f,
           },
        @{ @"tag":@700, @"display":@"彩度の統一",
           @"filter":@"IGSatControlFilter", @"name":@"inputSat", @"param-display":@"彩度",
           @"min":@0.0f, @"max":@1.0f, @"default":@0.5f,
           },
        @{ @"tag":@701, @"display":@"明度の統一",
           @"filter":@"IGValueControlFilter", @"name":@"inputValue", @"param-display":@"明度",
           @"min":@0.0f, @"max":@1.0f, @"default":@1.0f,
           },
        @{ @"tag":@702, @"display":@"白を透明に（黒）",
           @"filter":@"IGWhite2TransparentFilter",
           },
        @{ @"tag":@703, @"display":@"白を透明に（RGB保存）",
           @"filter":@"IGWhite2TransparentFilter2",
           },
        @{ @"tag":@403, @"display":@"YUVコントロール",
           @"filter":@"IGYUVControlFilter", @"name":@"inputU", @"param-display":@"U",
           @"min":@-0.5f, @"max":@0.5f, @"default":@0.0f,
           @"filter2":@"", @"name2":@"inputV", @"param-display2":@"V",
           @"min2":@-0.5f, @"max2":@0.5f, @"default2":@0.0f,
           },
        @{ @"tag":@404, @"display":@"反転（水平方向）",
           @"filter":@"IGFlipHFilter",
           },
        @{ @"tag":@405, @"display":@"反転（垂直方向）",
           @"filter":@"IGFlipVFilter",
           },

        @{ @"tag":@500, @"display":@"エッジ検出",
           @"filter":@"CIEdges", @"name":@"inputIntensity", @"param-display":@"画像ブレンド",
           @"min":@0.0f, @"max":@10.0f, @"default":@1.0f,
           },
        @{ @"tag":@501, @"display":@"ブルーム",
           @"filter":@"CIBloom", @"name":@"inputRadius", @"param-display":@"半径",
           @"min":@0.0f, @"max":@100.0f, @"default":@1.5f,
           @"filter2":@"", @"name2":@"inputIntensity", @"param-display2":@"画像ブレンド",
           @"min2":@0.0f, @"max2":@1.0f, @"default2":@0.65f,
           },
        @{ @"tag":@502, @"display":@"クリスタル化",
           @"filter":@"CICrystallize", @"name":@"inputRadius", @"param-display":@"半径",
           @"min":@1.0f, @"max":@50.0f, @"default":@10.0f,
           },
        @{ @"tag":@503, @"display":@"アンシャープマスク",
           @"filter":@"CIUnsharpMask", @"name":@"inputRadius", @"param-display":@"半径",
           @"min":@0.0f, @"max":@100.0f, @"default":@2.5f,
           @"filter2":@"", @"name2":@"inputIntensity", @"param-display2":@"画像ブレンド",
           @"min2":@0.0f, @"max2":@1.0f, @"default2":@0.5f,
           },
        @{ @"tag":@504, @"display":@"バンプ歪み",
           @"filter":@"CIBumpDistortion", @"name":@"inputRadius", @"param-display":@"半径",
           @"min":@0.0f, @"max":@500.0f, @"default":@100.0f,
           @"filter2":@"", @"name2":@"_inputCenterX", @"param-display2":@"中心X",
           @"min2":@0.0f, @"max2":@2000.0f, @"default2":@50.0f,
           @"filter3":@"", @"name3":@"_inputCenterY", @"param-display3":@"中心Y",
           @"min3":@0.0f, @"max3":@2000.0f, @"default3":@50.0f,
           @"filter4":@"", @"name4":@"inputScale", @"param-display4":@"スケール",
           @"min4":@-10.0f, @"max4":@10.0f, @"default4":@-0.5f,
           },
        @{ @"tag":@505, @"display":@"らせん歪み",
           @"filter":@"CITwirlDistortion", @"name":@"inputRadius", @"param-display":@"半径",
           @"min":@0.0f, @"max":@500.0f, @"default":@300.0f,
           @"filter2":@"", @"name2":@"_inputCenterX", @"param-display2":@"中心X",
           @"min2":@0.0f, @"max2":@2000.0f, @"default2":@150.0f,
           @"filter3":@"", @"name3":@"_inputCenterY", @"param-display3":@"中心Y",
           @"min3":@0.0f, @"max3":@2000.0f, @"default3":@150.0f,
           @"filter4":@"", @"name4":@"inputAngle", @"param-display4":@"角度",
           @"min4":@(M_PI*(-4.0)), @"max4":@(M_PI*4.0), @"default4":@(M_PI),
           },
        @{ @"tag":@506, @"display":@"うず巻き歪み",
           @"filter":@"CIVortexDistortion", @"name":@"inputRadius", @"param-display":@"半径",
           @"min":@0.0f, @"max":@500.0f, @"default":@300.0f,
           @"filter2":@"", @"name2":@"_inputCenterX", @"param-display2":@"中心X",
           @"min2":@0.0f, @"max2":@2000.0f, @"default2":@150.0f,
           @"filter3":@"", @"name3":@"_inputCenterY", @"param-display3":@"中心Y",
           @"min3":@0.0f, @"max3":@2000.0f, @"default3":@150.0f,
           @"filter4":@"", @"name4":@"inputAngle", @"param-display4":@"角度",
           @"min4":@(M_PI*(-4.0)), @"max4":@(M_PI*4.0), @"default4":@(M_PI),
           },
        @{ @"tag":@507, @"display":@"つまみ歪み",
           @"filter":@"CIPinchDistortion", @"name":@"inputRadius", @"param-display":@"半径",
           @"min":@0.0f, @"max":@500.0f, @"default":@100.0f,
           @"filter2":@"", @"name2":@"_inputCenterX", @"param-display2":@"中心X",
           @"min2":@0.0f, @"max2":@2000.0f, @"default2":@50.0f,
           @"filter3":@"", @"name3":@"_inputCenterY", @"param-display3":@"中心Y",
           @"min3":@0.0f, @"max3":@2000.0f, @"default3":@50.0f,
           @"filter4":@"", @"name4":@"inputScale", @"param-display4":@"スケール",
           @"min4":@-10.0f, @"max4":@2.0f, @"default4":@-0.5f,
           },
        @{ @"tag":@508, @"display":@"回転",
           @"filter":@"CIStraightenFilter", @"name":@"inputAngle", @"param-display":@"角度",
           @"min":@(-M_PI), @"max":@(M_PI), @"default":@0.0f,
           },
        @{ @"tag":@509, @"display":@"穴歪み",
           @"filter":@"CIHoleDistortion", @"name":@"inputRadius", @"param-display":@"半径",
           @"min":@0.1f, @"max":@500.0f, @"default":@150.0f,
           @"filter2":@"", @"name2":@"_inputCenterX", @"param-display2":@"中心X",
           @"min2":@0.0f, @"max2":@2000.0f, @"default2":@50.0f,
           @"filter3":@"", @"name3":@"_inputCenterY", @"param-display3":@"中心Y",
           @"min3":@0.0f, @"max3":@2000.0f, @"default3":@50.0f,
           },

        @{ @"tag":@600, @"display":@"スケッチ",
           @"filter":@"CILineOverlay", @"name":@"inputEdgeIntensity", @"param-display":@"エッジ強度",
           @"min":@0.0f, @"max":@20.0f, @"default":@1.0f,
           @"filter2":@"", @"name2":@"inputThreshold", @"param-display2":@"しきい値",
           @"min2":@0.0f, @"max2":@1.0f, @"default2":@0.1f,
           @"filter3":@"", @"name3":@"inputContrast", @"param-display3":@"コントラスト",
           @"min3":@0.25f, @"max3":@200.0f, @"default3":@50.0f,
           },
        @{ @"tag":@601, @"display":@"点描",
           @"filter":@"CIPointillize", @"name":@"inputRadius", @"param-display":@"半径",
           @"min":@1.0f, @"max":@100.0f, @"default":@20.0f,
           },
        @{ @"tag":@602, @"display":@"カーブ",
           @"filter":@"CICircularWrap", @"name":@"inputRadius", @"param-display":@"半径",
           @"min":@1.0f, @"max":@600.0f, @"default":@150.0f,
           @"filter2":@"", @"name2":@"_inputCenterX", @"param-display2":@"中心X",
           @"min2":@0.0f, @"max2":@2000.0f, @"default2":@50.0f,
           @"filter3":@"", @"name3":@"_inputCenterY", @"param-display3":@"中心Y",
           @"min3":@-1000.0f, @"max3":@2000.0f, @"default3":@50.0f,
           @"filter4":@"", @"name4":@"inputAngle", @"param-display4":@"角度",
           @"min4":@(-M_PI), @"max4":@(M_PI), @"default4":@0.0f,
           },
        @{ @"tag":@603, @"display":@"コミック",
           @"filter":@"CIComicEffect",
           },
        @{ @"tag":@604, @"display":@"ズームぼかし",
           @"filter":@"CIZoomBlur", @"name":@"inputAmount", @"param-display":@"ぼかし量",
           @"min":@1.0f, @"max":@200.0f, @"default":@10.0f,
           @"filter2":@"", @"name2":@"_inputCenterX", @"param-display2":@"中心X",
           @"min2":@0.0f, @"max2":@2000.0f, @"default2":@50.0f,
           @"filter3":@"", @"name3":@"_inputCenterY", @"param-display3":@"中心Y",
           @"min3":@0.0f, @"max3":@2000.0f, @"default3":@50.0f,
           },
        ];
}

- (id)initWithFilterTag:(int)tag
{
    self = [super init];
    if (self) {
        self.enabled = YES;

        for (NSDictionary *paramInfo in filterInfos) {
            if (tag == [paramInfo[@"tag"] intValue]) {
                filterParamInfo = paramInfo;
                break;
            }
        }
        if (filterParamInfo) {
            if (self.hasFilter1) {
                paramValue = [filterParamInfo[@"default"] floatValue];
            }
            if (self.hasFilter2) {
                paramValue2 = [filterParamInfo[@"default2"] floatValue];
            }
            if (self.hasFilter3) {
                paramValue3 = [filterParamInfo[@"default3"] floatValue];
            }
            if (self.hasFilter4) {
                paramValue4 = [filterParamInfo[@"default4"] floatValue];
            }
        } else {
            NSLog(@"Unknown filter tag: %d", tag);
            return nil;
        }
    }
    return self;
}

- (void)setParamValue:(id)value forKey:(NSString *)key forFilter:(CIFilter *)filter
{
    if ([key hasPrefix:@"_"]) {
        if ([key isEqualToString:@"_inputCenterX"]) {
            CIVector *vec = [filter valueForKey:@"inputCenter"];
            CIVector *vec2 = [CIVector vectorWithX:[value floatValue] Y:vec.Y];
            [filter setValue:vec2 forKey:@"inputCenter"];
        } else if ([key isEqualToString:@"_inputCenterY"]) {
            CIVector *vec = [filter valueForKey:@"inputCenter"];
            CIVector *vec2 = [CIVector vectorWithX:vec.X Y:[value floatValue]];
            [filter setValue:vec2 forKey:@"inputCenter"];
        }
    } else {
        [filter setValue:value forKey:key];
    }
}

- (CIFilter *)ciFilter
{
    if (!ciFilterObj) {
        ciFilterObj = [CIFilter filterWithName:filterParamInfo[@"filter"]];
        [ciFilterObj setDefaults];
    }
    if (!ciFilterObj) {
        NSLog(@"Cannot make a CIFilter: %@", filterParamInfo[@"filter"]);
    } else {
        if (filterParamInfo[@"name"]) {
            [self setParamValue:@(paramValue) forKey:filterParamInfo[@"name"] forFilter:ciFilterObj];
        }

        if (filterParamInfo[@"filter2"] && [filterParamInfo[@"filter2"] length] == 0) {
            [self setParamValue:@(paramValue2) forKey:filterParamInfo[@"name2"] forFilter:ciFilterObj];
        }

        if (filterParamInfo[@"filter3"] && [filterParamInfo[@"filter3"] length] == 0) {
            [self setParamValue:@(paramValue3) forKey:filterParamInfo[@"name3"] forFilter:ciFilterObj];
        }

        if (filterParamInfo[@"filter4"] && [filterParamInfo[@"filter4"] length] == 0) {
            [self setParamValue:@(paramValue4) forKey:filterParamInfo[@"name4"] forFilter:ciFilterObj];
        }
    }
    return ciFilterObj;
}

- (CIFilter *)ciFilter2
{
    if (self.hasFilter2 && !ciFilterObj2) {
        ciFilterObj2 = [CIFilter filterWithName:filterParamInfo[@"filter2"]];
        [ciFilterObj2 setDefaults];
    }
    if (!ciFilterObj2) {
        NSLog(@"Cannot make a CIFilter: %@", filterParamInfo[@"filter2"]);
    } else {
        [self setParamValue:@(paramValue2) forKey:filterParamInfo[@"name2"] forFilter:ciFilterObj2];
    }
    return ciFilterObj2;
}

- (CIFilter *)ciFilter3
{
    if (self.hasFilter3 && !ciFilterObj3) {
        ciFilterObj3 = [CIFilter filterWithName:filterParamInfo[@"filter3"]];
        [ciFilterObj3 setDefaults];
    }
    if (!ciFilterObj3) {
        NSLog(@"Cannot make a CIFilter: %@", filterParamInfo[@"filter3"]);
    } else {
        [self setParamValue:@(paramValue3) forKey:filterParamInfo[@"name3"] forFilter:ciFilterObj3];
    }
    return ciFilterObj3;
}

- (NSString *)filterName
{
    return filterParamInfo[@"display"];
}

- (NSString *)paramDisplayName
{
    return filterParamInfo[@"param-display"];
}

- (float)minValue
{
    return [filterParamInfo[@"min"] floatValue];
}

- (float)maxValue
{
    return [filterParamInfo[@"max"] floatValue];
}

- (float)paramValue
{
    return paramValue;
}

- (void)setParamValue:(float)value
{
    paramValue = value;
}

- (CIImage *)filteredImageForImage:(CIImage *)image imageSize:(NSSize)imageSize
{
    CIImage *ret = image;

    CIFilter *cropFilter = [CIFilter filterWithName:@"CICrop"];
    [cropFilter setDefaults];
    [cropFilter setValue:[CIVector vectorWithX:0 Y:0 Z:imageSize.width W:imageSize.height]
                  forKey:@"inputRectangle"];

    if (filterParamInfo[@"filter"]) {
        CIFilter *filter = self.ciFilter;
        //NSLog(@"attrs: %@", filter.attributes);
        [filter setValue:ret forKey:@"inputImage"];
        ret = [filter valueForKey:@"outputImage"];

        [cropFilter setValue:ret forKey:@"inputImage"];
        ret = [cropFilter valueForKey:@"outputImage"];
    }

    if (self.hasFilter2 && [filterParamInfo[@"filter2"] length] > 0) {
        CIFilter *filter = self.ciFilter2;
        [filter setValue:ret forKey:@"inputImage"];
        ret = [filter valueForKey:@"outputImage"];

        [cropFilter setValue:ret forKey:@"inputImage"];
        ret = [cropFilter valueForKey:@"outputImage"];
    }

    if (self.hasFilter3 && [filterParamInfo[@"filter3"] length] > 0) {
        CIFilter *filter = self.ciFilter3;
        [filter setValue:ret forKey:@"inputImage"];
        ret = [filter valueForKey:@"outputImage"];

        [cropFilter setValue:ret forKey:@"inputImage"];
        ret = [cropFilter valueForKey:@"outputImage"];
    }

    return ret;
}

- (BOOL)hasFilter1
{
    return (filterParamInfo[@"filter"] != nil) && (filterParamInfo[@"name"] != nil);
}

- (BOOL)hasFilter2
{
    return (filterParamInfo[@"filter2"] != nil);
}

- (BOOL)hasFilter3
{
    return (filterParamInfo[@"filter3"] != nil);
}

- (BOOL)hasFilter4
{
    return (filterParamInfo[@"filter4"] != nil);
}

- (NSString *)filterName2
{
    return filterParamInfo[@"display2"];
}

- (NSString *)paramDisplayName2
{
    return filterParamInfo[@"param-display2"];
}

- (float)minValue2
{
    return [filterParamInfo[@"min2"] floatValue];
}

- (float)maxValue2
{
    return [filterParamInfo[@"max2"] floatValue];
}

- (float)paramValue2
{
    return paramValue2;
}

- (void)setParamValue2:(float)value
{
    paramValue2 = value;
}

- (NSString *)filterName3
{
    return filterParamInfo[@"display3"];
}

- (NSString *)paramDisplayName3
{
    return filterParamInfo[@"param-display3"];
}

- (float)minValue3
{
    return [filterParamInfo[@"min3"] floatValue];
}

- (float)maxValue3
{
    return [filterParamInfo[@"max3"] floatValue];
}

- (float)paramValue3
{
    return paramValue3;
}

- (void)setParamValue3:(float)value
{
    paramValue3 = value;
}

- (NSString *)filterName4
{
    return filterParamInfo[@"display4"];
}

- (NSString *)paramDisplayName4
{
    return filterParamInfo[@"param-display4"];
}

- (float)minValue4
{
    return [filterParamInfo[@"min4"] floatValue];
}

- (float)maxValue4
{
    return [filterParamInfo[@"max4"] floatValue];
}

- (float)paramValue4
{
    return paramValue4;
}

- (void)setParamValue4:(float)value
{
    paramValue4 = value;
}

- (BOOL)setCenterPos:(NSPoint)pos
{
    BOOL hasSet = NO;

    if ([filterParamInfo[@"name"] isEqualToString:@"_inputCenterX"]) {
        [self setParamValue:pos.x];
        hasSet = YES;
    } else if ([filterParamInfo[@"name2"] isEqualToString:@"_inputCenterX"]) {
        [self setParamValue2:pos.x];
        hasSet = YES;
    } else if ([filterParamInfo[@"name3"] isEqualToString:@"_inputCenterX"]) {
        [self setParamValue3:pos.x];
        hasSet = YES;
    }

    if ([filterParamInfo[@"name"] isEqualToString:@"_inputCenterY"]) {
        [self setParamValue:pos.y];
        hasSet = YES;
    } else if ([filterParamInfo[@"name2"] isEqualToString:@"_inputCenterY"]) {
        [self setParamValue2:pos.y];
        hasSet = YES;
    } else if ([filterParamInfo[@"name3"] isEqualToString:@"_inputCenterY"]) {
        [self setParamValue3:pos.y];
        hasSet = YES;
    }

    return hasSet;
}

@end

