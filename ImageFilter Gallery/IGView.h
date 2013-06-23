//
//  IGView.h
//  ImageFilter Gallery
//
//  Created by numata on 2013/06/23.
//  Copyright (c) 2013年 Satoshi Numata. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class IGDocument;


@interface IGView : NSView

@property (readwrite, assign) IGDocument *document;

@end

