//
//  IGDocument.h
//  ImageFilter Gallery
//
//  Created by numata on 2013/06/22.
//  Copyright (c) 2013 Sazameki and Satoshi Numata, Ph.D. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "IGView.h"


@interface IGDocument : NSDocument<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (readwrite) BOOL isCameraDocument;

@property (weak) IBOutlet NSScrollView *scrollView;
@property (strong) IBOutlet NSPanel *filtersPanel;
@property (weak) IBOutlet NSTableView *filtersTableView;
@property (weak) IBOutlet NSPopUpButton *filterTypeButton;

@property (weak) IBOutlet NSTextField *filterParamField;
@property (weak) IBOutlet NSSlider *filterParamSlider;
@property (weak) IBOutlet NSTextField *filterParamValueField;

@property (weak) IBOutlet NSTextField *filterParamField2;
@property (weak) IBOutlet NSSlider *filterParamSlider2;
@property (weak) IBOutlet NSTextField *filterParamValueField2;

@property (weak) IBOutlet NSTextField *filterParamField3;
@property (weak) IBOutlet NSSlider *filterParamSlider3;
@property (weak) IBOutlet NSTextField *filterParamValueField3;

@property (weak) IBOutlet NSTextField *filterParamField4;
@property (weak) IBOutlet NSSlider *filterParamSlider4;
@property (weak) IBOutlet NSTextField *filterParamValueField4;

@property (strong) IBOutlet NSButton *showFiltersButton;
@property (weak) IBOutlet IGView *mainView;

- (IBAction)showImageFilters:(id)sender;
- (IBAction)addFilter:(id)sender;

- (IBAction)changedFilterParamValue:(id)sender;
- (IBAction)changedFilterParamValueByText:(id)sender;

- (IBAction)changedFilterParamValue2:(id)sender;
- (IBAction)changedFilterParamValueByText2:(id)sender;

- (IBAction)changedFilterParamValue3:(id)sender;
- (IBAction)changedFilterParamValueByText3:(id)sender;

- (IBAction)chnagedFilterParamValue4:(id)sender;
- (IBAction)chnagedFilterParamValueByText4:(id)sender;

- (IBAction)saveAs:(id)sender;

- (void)setCenterPos:(NSPoint)pos;

@end

