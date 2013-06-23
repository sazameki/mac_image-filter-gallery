//
//  IGAppDelegate.h
//  ImageFilter Gallery
//
//  Created by numata on 2013/06/23.
//  Copyright (c) 2013 Sazameki and Satoshi Numata, Ph.D. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IGAppDelegate : NSObject

- (IBAction)newFromClipboard:(id)sender;
- (IBAction)newCameraImage:(id)sender;

@end


extern BOOL gHasCameraImage;


