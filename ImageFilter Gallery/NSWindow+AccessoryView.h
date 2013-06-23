//
//  NSWindow+AccessoryView.h
//  ImageFilter Gallery
//
//  Created by numata on 2013/06/23.
//  Copyright (c) 2013 Sazameki and Satoshi Numata, Ph.D. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSWindow (AccessoryView)

-(void)addViewToTitleBar:(NSView*)view atXPosition:(CGFloat)x;
-(CGFloat)heightOfTitleBar;

@end

