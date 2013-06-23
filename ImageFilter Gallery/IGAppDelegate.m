//
//  IGAppDelegate.m
//  ImageFilter Gallery
//
//  Created by numata on 2013/06/23.
//  Copyright (c) 2013 Sazameki and Satoshi Numata, Ph.D. All rights reserved.
//

#import "IGAppDelegate.h"
#import "IGDocument.h"


BOOL gHasCameraImage = NO;


@implementation IGAppDelegate

- (IBAction)newCameraImage:(id)sender
{
    if (gHasCameraImage) {
        NSBeep();
        return;
    }
    NSDocumentController* docController = [NSDocumentController sharedDocumentController];
    NSError *error = nil;
    IGDocument *document = [docController makeUntitledDocumentOfType:@"PNG Image" error:&error];
    document.isCameraDocument = YES;
    [docController addDocument:document];
    [document makeWindowControllers];
    [document showWindows];

    gHasCameraImage = YES;
}

@end

