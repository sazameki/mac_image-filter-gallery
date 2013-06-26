//
//  IGDocument.m
//  ImageFilter Gallery
//
//  Created by numata on 2013/06/22.
//  Copyright (c) 2013 Sazameki and Satoshi Numata, Ph.D. All rights reserved.
//

#import "IGDocument.h"
#import "IGAppDelegate.h"
#import "SZMKFlippedClipView.h"
#import "IGFilterInfo.h"
#import "IGView.h"

#import "IGNaiveGrayscaleFilter.h"
#import "IGGrayscaleFilter.h"
#import "IGBinaryFilter.h"
#import "IGInvertFilter.h"
#import "IGSplitFilter.h"
#import "IGMosaicFilter.h"
#import "IGHueControlFilter.h"
#import "IGSatControlFilter.h"
#import "IGValueControlFilter.h"
#import "IGFlipHFilter.h"
#import "IGFlipVFilter.h"
#import "IGWhite2TransparentFilter.h"
#import "IGWhite2TransparentFilter2.h"

#import "NSMutableArray+Util.h"
#import "NSWindow+AccessoryView.h"


typedef enum {
    IGBackgroundTypeCheckerboard,
    IGBackgroundTypeBlack,
    IGBackgroundTypeWhite,
} IGBackgroundType;


@implementation IGDocument {
    CIImage *ciImage;
    CIImage *ciImageProcessed;
    NSSize  imageSize;
    NSSize  scaledImageSize;

    NSMutableArray *filters;

    BOOL    isShowingFilters;

    CIFilter *flipFilter;
    CIFilter *cropFilter;

    IGBackgroundType backgroundType;
    CIImage *backgroundImage;

    float   scale;

    // Camera Support
    BOOL hasSetImageSize;
    AVCaptureSession *captureSession;
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

+ (void)initialize
{
    [IGNaiveGrayscaleFilter registerFilter];
    [IGGrayscaleFilter registerFilter];
    [IGBinaryFilter registerFilter];
    [IGInvertFilter registerFilter];
    [IGSplitFilter registerFilter];
    [IGMosaicFilter registerFilter];
    [IGHueControlFilter registerFilter];
    [IGSatControlFilter registerFilter];
    [IGValueControlFilter registerFilter];
    [IGFlipHFilter registerFilter];
    [IGFlipVFilter registerFilter];
    [IGWhite2TransparentFilter registerFilter];
    [IGWhite2TransparentFilter2 registerFilter];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.isCameraDocument = NO;
        filters = @[].mutableCopy;
    }
    return self;
}

- (NSString *)windowNibName
{
    return @"IGDocument";
}

- (void)invalidateParamControls
{
    self.filterParamSlider.enabled = NO;
    self.filterParamValueField.enabled = NO;

    self.filterParamField.stringValue = @"";
    self.filterParamSlider.minValue = 0.0;
    self.filterParamSlider.maxValue = 1.0;
    self.filterParamSlider.floatValue = 0.0;
    self.filterParamValueField.floatValue = 0.0;

    self.filterParamSlider2.enabled = NO;
    self.filterParamValueField2.enabled = NO;

    self.filterParamField2.stringValue = @"";
    self.filterParamSlider2.minValue = 0.0;
    self.filterParamSlider2.maxValue = 1.0;
    self.filterParamSlider2.floatValue = 0.0;
    self.filterParamValueField2.floatValue = 0.0;

    self.filterParamSlider3.enabled = NO;
    self.filterParamValueField3.enabled = NO;

    self.filterParamField3.stringValue = @"";
    self.filterParamSlider3.minValue = 0.0;
    self.filterParamSlider3.maxValue = 1.0;
    self.filterParamSlider3.floatValue = 0.0;
    self.filterParamValueField3.floatValue = 0.0;

    self.filterParamSlider4.enabled = NO;
    self.filterParamValueField4.enabled = NO;

    self.filterParamField4.stringValue = @"";
    self.filterParamSlider4.minValue = 0.0;
    self.filterParamSlider4.maxValue = 1.0;
    self.filterParamSlider4.floatValue = 0.0;
    self.filterParamValueField4.floatValue = 0.0;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];

    scale = 1.0f;

    if (self.isCameraDocument) {
        hasSetImageSize = NO;

        // 入力デバイスの取得
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:NULL];

        // ビデオデータ出力の作成
        AVCaptureVideoDataOutput *dataOutput = [AVCaptureVideoDataOutput new];
        dataOutput.videoSettings = @{ (id)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA) };
        dataOutput.alwaysDiscardsLateVideoFrames = YES;
        [dataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];

        // セッションの作成
        captureSession = [AVCaptureSession new];
        [captureSession addInput:deviceInput];
        [captureSession addOutput:dataOutput];

        imageSize = NSMakeSize(640, 480);
        scaledImageSize = imageSize;

        [captureSession startRunning];

        [self.mainView.window setTitle:@"Camera"];
    }

    self.mainView.document = self;

    isShowingFilters = NO;

    self.filterParamSlider.enabled = NO;
    self.filterParamValueField.enabled = NO;

    [self invalidateParamControls];

    NSView *documentView = self.mainView;
    [documentView setWantsLayer:YES];
    [SZMKFlippedClipView setupClipView:self.scrollView.contentView];

    NSRect imageRect = NSMakeRect(0, 0, scaledImageSize.width, scaledImageSize.height);

    documentView.frame = imageRect;
    documentView.window.contentSize = scaledImageSize;
    documentView.window.contentMaxSize = scaledImageSize;
    [documentView.window setFrame:[documentView.window frameRectForContentRect:imageRect] display:NO];

    CALayer *layer = documentView.layer;
    layer.frame = CGRectMake(0, 0, scaledImageSize.width, scaledImageSize.height);
    CGColorRef bgColor = CGColorCreateGenericRGB(1.0f, 1.0f, 1.0f, 1.0f);
    layer.backgroundColor = bgColor;
    CGColorRelease(bgColor);
    layer.contentsGravity = kCAGravityBottomLeft;

    self.filtersPanel.level = NSFloatingWindowLevel;

    backgroundType = IGBackgroundTypeCheckerboard;
    [self setBackgroundCheckerboard:self];

    [self.filtersTableView registerForDraggedTypes:@[NSStringPboardType]];

    NSWindow *window = documentView.window;
    [window addViewToTitleBar:self.showFiltersButton
                  atXPosition:imageSize.width-self.showFiltersButton.frame.size.width-8];

    if (!self.isCameraDocument && !ciImage) {
        [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(closeDocument:) userInfo:nil repeats:NO];
    }
}

- (void)closeDocument:(NSTimer *)timer
{
    [self close];
}

- (void)updateImageView
{
    CIContext *ciContext = [CIContext contextWithCGContext:(CGContextRef)[[NSGraphicsContext currentContext] graphicsPort]
                                                   options:nil];
    CGImageRef cgImage = [ciContext createCGImage:ciImageProcessed fromRect:CGRectMake(0, 0, scaledImageSize.width, scaledImageSize.height)];

    CALayer *layer = self.mainView.layer;
    layer.frame = CGRectMake(0, 0, scaledImageSize.width, scaledImageSize.height);
    layer.contents = (__bridge id)cgImage;

    CGImageRelease(cgImage);
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (CIImage *)flipImage:(CIImage *)image
{
    if (!flipFilter) {
        flipFilter = [CIFilter filterWithName:@"IGFlipVFilter"];
        [flipFilter setDefaults];
    }
    [flipFilter setValue:image forKey:@"inputImage"];
    image = [flipFilter valueForKey:@"outputImage"];

    return image;
}

- (CIImage *)cropImage:(CIImage *)image
{
    if (!cropFilter) {
        cropFilter = [CIFilter filterWithName:@"CICrop"];
        [cropFilter setDefaults];
    }
    [cropFilter setValue:image forKey:@"inputImage"];
    [cropFilter setValue:[CIVector vectorWithX:0 Y:0 Z:scaledImageSize.width W:scaledImageSize.height]
                  forKey:@"inputRectangle"];
    image = [cropFilter valueForKey:@"outputImage"];

    return image;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:data];
    imageSize = NSMakeSize(imageRep.pixelsWide, imageRep.pixelsHigh);
    scaledImageSize = imageSize;
    ciImage = [CIImage imageWithCGImage:imageRep.CGImage];

    ciImage = [self flipImage:ciImage];
    ciImage = [self cropImage:ciImage];

    [self applyFilters:self];

    return YES;
}

- (IBAction)showImageFilters:(id)sender
{
    if (isShowingFilters) {
        isShowingFilters = NO;
        [self.filtersPanel orderOut:self];
        return;
    }

    isShowingFilters = YES;

    NSURL *url = self.fileURL;
    NSString *displayName;
    if ([url getResourceValue:&displayName forKey:NSURLLocalizedNameKey error:nil]) {
        self.filtersPanel.title = displayName;
    }

    [self.filtersPanel makeKeyAndOrderFront:self];
}

- (IBAction)applyFilters:(id)sender
{
    // フィルタを適用した画像の用意。CIImageはフィルタの積み重ねで表現されるので、背景と重ね合わせる前にレンダリングする。
    CIImage *image = [self makeFilteredImage];

    // 背景画像とブレンドする
    CIFilter *blendFilter = [CIFilter filterWithName:@"CISourceOverCompositing"];
    [blendFilter setDefaults];
    [blendFilter setValue:image forKey:@"inputImage"];
    [blendFilter setValue:backgroundImage forKey:@"inputBackgroundImage"];
    image = [blendFilter valueForKey:@"outputImage"];

    image = [self flipImage:image];
    ciImageProcessed = [self cropImage:image];

    [self updateImageView];
}

- (IBAction)addFilter:(id)sender
{
    IGFilterInfo *filterInfo = [[IGFilterInfo alloc] initWithFilterTag:(int)self.filterTypeButton.selectedTag];
    [filters addObject:filterInfo];

    [self.filtersTableView reloadData];
    [self.filtersTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    [self tableViewSelectionDidChange:nil];

    [self applyFilters:self];
}

- (IBAction)changedFilterParamValue:(id)sender
{
    NSInteger row = self.filtersTableView.selectedRow;
    if (row < 0) {
        return;
    }

    IGFilterInfo *filterInfo = filters[filters.count-row-1];
    filterInfo.paramValue = self.filterParamSlider.floatValue;

    self.filterParamValueField.floatValue = self.filterParamSlider.floatValue;

    [self applyFilters:self];
}

- (IBAction)changedFilterParamValueByText:(id)sender
{
    NSInteger row = self.filtersTableView.selectedRow;
    if (row < 0) {
        return;
    }

    IGFilterInfo *filterInfo = filters[filters.count-row-1];
    filterInfo.paramValue = self.filterParamValueField.floatValue;

    self.filterParamSlider.floatValue = self.filterParamValueField.floatValue;

    [self applyFilters:self];
}

- (IBAction)changedFilterParamValue2:(id)sender
{
    NSInteger row = self.filtersTableView.selectedRow;
    if (row < 0) {
        return;
    }

    IGFilterInfo *filterInfo = filters[filters.count-row-1];
    filterInfo.paramValue2 = self.filterParamSlider2.floatValue;

    self.filterParamValueField2.floatValue = self.filterParamSlider2.floatValue;

    [self applyFilters:self];
}

- (IBAction)changedFilterParamValueByText2:(id)sender
{
    NSInteger row = self.filtersTableView.selectedRow;
    if (row < 0) {
        return;
    }

    IGFilterInfo *filterInfo = filters[filters.count-row-1];
    filterInfo.paramValue2 = self.filterParamValueField2.floatValue;

    self.filterParamSlider2.floatValue = self.filterParamValueField2.floatValue;

    [self applyFilters:self];
}

- (IBAction)changedFilterParamValue3:(id)sender
{
    NSInteger row = self.filtersTableView.selectedRow;
    if (row < 0) {
        return;
    }

    IGFilterInfo *filterInfo = filters[filters.count-row-1];
    filterInfo.paramValue3 = self.filterParamSlider3.floatValue;

    self.filterParamValueField3.floatValue = self.filterParamSlider3.floatValue;

    [self applyFilters:self];
}

- (IBAction)changedFilterParamValueByText3:(id)sender
{
    NSInteger row = self.filtersTableView.selectedRow;
    if (row < 0) {
        return;
    }

    IGFilterInfo *filterInfo = filters[filters.count-row-1];
    filterInfo.paramValue3 = self.filterParamValueField3.floatValue;

    self.filterParamSlider3.floatValue = self.filterParamValueField3.floatValue;

    [self applyFilters:self];
}

- (IBAction)chnagedFilterParamValue4:(id)sender
{
    NSInteger row = self.filtersTableView.selectedRow;
    if (row < 0) {
        return;
    }

    IGFilterInfo *filterInfo = filters[filters.count-row-1];
    filterInfo.paramValue4 = self.filterParamSlider4.floatValue;

    self.filterParamValueField4.floatValue = self.filterParamSlider4.floatValue;

    [self applyFilters:self];
}

- (IBAction)chnagedFilterParamValueByText4:(id)sender
{
    NSInteger row = self.filtersTableView.selectedRow;
    if (row < 0) {
        return;
    }

    IGFilterInfo *filterInfo = filters[filters.count-row-1];
    filterInfo.paramValue4 = self.filterParamValueField4.floatValue;

    self.filterParamSlider4.floatValue = self.filterParamValueField4.floatValue;

    [self applyFilters:self];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return filters.count;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    if ([aTableColumn.identifier isEqualToString:@"enabled"]) {
        return @([filters[filters.count-rowIndex-1] enabled]);
    } else {
        return [filters[filters.count-rowIndex-1] filterName];
    }
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    if ([aTableColumn.identifier isEqualToString:@"enabled"]) {
        IGFilterInfo *filterInfo = filters[filters.count-rowIndex-1];
        filterInfo.enabled = [anObject boolValue];

        [self applyFilters:self];
    }
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    [self invalidateParamControls];

    NSInteger row = self.filtersTableView.selectedRow;
    if (row < 0) {
        return;
    }

    IGFilterInfo *filterInfo = filters[filters.count-row-1];

    if (filterInfo.hasFilter1) {
        self.filterParamSlider.enabled = YES;
        self.filterParamValueField.enabled = YES;

        self.filterParamField.stringValue = [filterInfo.paramDisplayName stringByAppendingString:@":"];
        self.filterParamSlider.minValue = filterInfo.minValue;
        self.filterParamSlider.maxValue = filterInfo.maxValue;
        self.filterParamSlider.floatValue = filterInfo.paramValue;
        self.filterParamValueField.floatValue = filterInfo.paramValue;
    }

    if (filterInfo.hasFilter2) {
        self.filterParamSlider2.enabled = YES;
        self.filterParamValueField2.enabled = YES;

        self.filterParamField2.stringValue = [filterInfo.paramDisplayName2 stringByAppendingString:@":"];
        self.filterParamSlider2.minValue = filterInfo.minValue2;
        self.filterParamSlider2.maxValue = filterInfo.maxValue2;
        self.filterParamSlider2.floatValue = filterInfo.paramValue2;
        self.filterParamValueField2.floatValue = filterInfo.paramValue2;
    }

    if (filterInfo.hasFilter3) {
        self.filterParamSlider3.enabled = YES;
        self.filterParamValueField3.enabled = YES;

        self.filterParamField3.stringValue = [filterInfo.paramDisplayName3 stringByAppendingString:@":"];
        self.filterParamSlider3.minValue = filterInfo.minValue3;
        self.filterParamSlider3.maxValue = filterInfo.maxValue3;
        self.filterParamSlider3.floatValue = filterInfo.paramValue3;
        self.filterParamValueField3.floatValue = filterInfo.paramValue3;
    }

    if (filterInfo.hasFilter4) {
        self.filterParamSlider4.enabled = YES;
        self.filterParamValueField4.enabled = YES;

        self.filterParamField4.stringValue = [filterInfo.paramDisplayName4 stringByAppendingString:@":"];
        self.filterParamSlider4.minValue = filterInfo.minValue4;
        self.filterParamSlider4.maxValue = filterInfo.maxValue4;
        self.filterParamSlider4.floatValue = filterInfo.paramValue4;
        self.filterParamValueField4.floatValue = filterInfo.paramValue4;
    }
}

- (void)windowDidResignMain:(NSNotification *)notification
{
    if (notification.object != self.filtersPanel) {
        [self.filtersPanel orderOut:self];
    }
}

- (void)windowDidBecomeMain:(NSNotification *)notification
{
    if (notification.object != self.filtersPanel) {
        if (isShowingFilters) {
            [self.filtersPanel orderFront:self];
        }
    }
}

- (void)windowWillClose:(NSNotification *)notification
{
    if (notification.object == self.filtersPanel) {
        isShowingFilters = NO;
    }

    if (captureSession) {
        [captureSession stopRunning];
        captureSession = nil;

        gHasCameraImage = NO;
    }
}

- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id < NSDraggingInfo >)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation
{
    NSString *fromStr = [[info draggingPasteboard] stringForType:NSStringPboardType];
    NSInteger from = filters.count - fromStr.integerValue - 1;
    NSInteger to = filters.count - row;

    NSInteger movedIndex = [filters moveObjectAtIndex:from toIndex:to];
    movedIndex = filters.count - movedIndex - 1;

    [self.filtersTableView reloadData];
    [self.filtersTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:movedIndex] byExtendingSelection:NO];
    [self applyFilters:self];

    return YES;
}

- (BOOL)tableView:(NSTableView *)aTableView shouldEditTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    if ([aTableColumn.identifier isEqualToString:@"enabled"]) {
        return YES;
    }
    return NO;
}

- (NSDragOperation)tableView:(NSTableView *)aTableView validateDrop:(id < NSDraggingInfo >)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)operation
{
    if (operation == NSTableViewDropAbove) {
        return NSDragOperationMove;
    } else {
        return NSDragOperationNone;
    }
}

- (BOOL)tableView:(NSTableView *)aTableView
writeRowsWithIndexes:(NSIndexSet *)rowIndexes
     toPasteboard:(NSPasteboard *)pboard
{
    [pboard setString:[NSString stringWithFormat:@"%ld", rowIndexes.firstIndex] forType:NSStringPboardType];
    return YES;
}

- (void)removeSelectedFilter
{
    NSInteger row = self.filtersTableView.selectedRow;
    if (row < 0) {
        return;
    }
    row = filters.count - row - 1;
    [filters removeObjectAtIndex:row];

    [self.filtersTableView reloadData];
    [self applyFilters:self];
}

- (void)setCenterPos:(NSPoint)pos
{
    NSInteger row = self.filtersTableView.selectedRow;
    if (row < 0) {
        return;
    }

    IGFilterInfo *currentFilterInfo = filters[filters.count-row-1];
    if ([currentFilterInfo setCenterPos:pos]) {
        [self applyFilters:self];

        [self tableViewSelectionDidChange:nil];
    }
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    if (menuItem.action == @selector(setBackgroundCheckerboard:)) {
        menuItem.state = (backgroundType == IGBackgroundTypeCheckerboard)? NSOnState: NSOffState;
        return YES;
    }
    else if (menuItem.action == @selector(setBackgroundBlack:)) {
        menuItem.state = (backgroundType == IGBackgroundTypeBlack)? NSOnState: NSOffState;
        return YES;
    }
    else if (menuItem.action == @selector(setBackgroundWhite:)) {
        menuItem.state = (backgroundType == IGBackgroundTypeWhite)? NSOnState: NSOffState;
        return YES;
    }
    return [super validateMenuItem:menuItem];
}

- (IBAction)setBackgroundCheckerboard:(id)sender
{
    backgroundType = IGBackgroundTypeCheckerboard;

    CIFilter *checkerboardFilter = [CIFilter filterWithName:@"CICheckerboardGenerator"];
    [checkerboardFilter setDefaults];
    [checkerboardFilter setValue:@8 forKey:@"inputWidth"];
    [checkerboardFilter setValue:[CIColor colorWithRed:1.0 green:1.0 blue:1.0] forKey:@"inputColor0"];
    [checkerboardFilter setValue:[CIColor colorWithRed:0.8 green:0.8 blue:0.8] forKey:@"inputColor1"];
    [checkerboardFilter setValue:[CIVector vectorWithX:0 Y:0] forKey:@"inputCenter"];

    backgroundImage = [checkerboardFilter valueForKey:@"outputImage"];
    backgroundImage = [self cropImage:backgroundImage];

    [self applyFilters:self];
}

- (IBAction)setBackgroundBlack:(id)sender
{
    backgroundType = IGBackgroundTypeBlack;

    CIFilter *constantColorFilter = [CIFilter filterWithName:@"CIConstantColorGenerator"];
    [constantColorFilter setDefaults];
    [constantColorFilter setValue:[CIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0] forKey:@"inputColor"];

    backgroundImage = [constantColorFilter valueForKey:@"outputImage"];
    backgroundImage = [self cropImage:backgroundImage];

    [self applyFilters:self];
}

- (IBAction)setBackgroundWhite:(id)sender
{
    backgroundType = IGBackgroundTypeWhite;
    CIFilter *constantColorFilter = [CIFilter filterWithName:@"CIConstantColorGenerator"];
    [constantColorFilter setDefaults];
    [constantColorFilter setValue:[CIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0] forKey:@"inputColor"];

    backgroundImage = [constantColorFilter valueForKey:@"outputImage"];
    backgroundImage = [self cropImage:backgroundImage];

    [self applyFilters:self];
}

- (CIImage *)makeFilteredImage
{
    NSData *tiffData = [self makeTiffData];
    CIImage *ret = [CIImage imageWithData:tiffData];
    return ret;
}

- (NSData *)makeTiffData
{
    CIImage *image = ciImage;
    for (IGFilterInfo *filterInfo in filters) {
        if (!filterInfo.enabled) {
            continue;
        }
        image = [filterInfo filteredImageForImage:image imageSize:imageSize];
    }

    CIContext *ciContext = [CIContext contextWithCGContext:(CGContextRef)[[NSGraphicsContext currentContext] graphicsPort]
                                                   options:nil];
    CGImageRef cgImage = [ciContext createCGImage:image fromRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    NSImage *nsImage = [[NSImage alloc] initWithCGImage:cgImage size:imageSize];

    NSData *tiffData = nsImage.TIFFRepresentation;

    CGImageRelease(cgImage);

    return tiffData;
}

- (NSData *)makePNGData
{
    CIImage *image = ciImage;
    for (IGFilterInfo *filterInfo in filters) {
        if (!filterInfo.enabled) {
            continue;
        }
        image = [filterInfo filteredImageForImage:image imageSize:imageSize];
    }
    image = [self flipImage:image];

    CIContext *ciContext = [CIContext contextWithCGContext:(CGContextRef)[[NSGraphicsContext currentContext] graphicsPort]
                                                   options:nil];
    CGImageRef cgImage = [ciContext createCGImage:image fromRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    NSImage *nsImage = [[NSImage alloc] initWithCGImage:cgImage size:imageSize];

    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:nsImage.TIFFRepresentation];
    NSData *pngData = [imageRep representationUsingType:NSPNGFileType
                                             properties:@{ NSImageInterlaced:@NO }];

    CGImageRelease(cgImage);

    return pngData;
}

- (void)writeImageAtURL:(NSURL *)url
{
    NSData *pngData = [self makePNGData];

    if (![pngData writeToURL:url atomically:YES]) {
        NSLog(@"Failed to write PNG file: %@", url);
    }
}

- (IBAction)saveAs:(id)sender
{
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    savePanel.directoryURL = [self.fileURL URLByDeletingLastPathComponent];
    savePanel.allowedFileTypes = @[@"png"];
    [savePanel beginSheetModalForWindow:self.mainView.window
                      completionHandler:^(NSInteger result)
    {
        if (result == NSFileHandlingPanelOKButton) {
            NSURL *fileURL = savePanel.URL;
            [self writeImageAtURL:fileURL];
        }
    }];
}

- (IBAction)copy:(id)sender
{
    NSData *pngData = [self makePNGData];

    NSPasteboard *pboard = [NSPasteboard generalPasteboard];
    [pboard declareTypes:@[ NSPasteboardTypePNG ] owner:self];
    [pboard setData:pngData forType:NSPasteboardTypePNG];
}

- (void)captureOutput:(AVCaptureOutput*)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    // イメージバッファの取得
    CVImageBufferRef buffer = CMSampleBufferGetImageBuffer(sampleBuffer);

    // イメージバッファのロック
    CVPixelBufferLockBaseAddress(buffer, 0);

    // イメージバッファ情報の取得
    uint8_t *base = CVPixelBufferGetBaseAddress(buffer);
    size_t width = CVPixelBufferGetWidth(buffer);
    size_t height = CVPixelBufferGetHeight(buffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(buffer);

    if (!hasSetImageSize) {
        imageSize = NSMakeSize(width, height);
        scaledImageSize = NSMakeSize(width * scale, height * scale);

        if (backgroundType == IGBackgroundTypeCheckerboard) {
            [self setBackgroundCheckerboard:self];
        } else if (backgroundType == IGBackgroundTypeBlack) {
            [self setBackgroundBlack:self];
        } else if (backgroundType == IGBackgroundTypeWhite) {
            [self setBackgroundWhite:self];
        }

        NSView *documentView = self.mainView;
        NSRect imageRect = NSMakeRect(0, 0, imageSize.width, imageSize.height);
        documentView.frame = imageRect;
        documentView.window.contentSize = imageSize;
        documentView.window.contentMaxSize = imageSize;
        [documentView.window setFrame:[documentView.window frameRectForContentRect:imageRect] display:NO];

        CALayer *layer = documentView.layer;
        layer.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);

        hasSetImageSize = YES;
    }

    // ビットマップコンテキストの作成
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef cgContext = CGBitmapContextCreate(base, width, height, 8, bytesPerRow, colorSpace,
                                      kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);

    // 画像の作成
    CGImageRef cgImage = CGBitmapContextCreateImage(cgContext);
    CIImage *image = [CIImage imageWithCGImage:cgImage];
    image = [self flipImage:image];
    image = [self cropImage:image];
    ciImage = image;
    [self applyFilters:self];
    CGImageRelease(cgImage);
    CGContextRelease(cgContext);
    
    // イメージバッファのアンロック
    CVPixelBufferUnlockBaseAddress(buffer, 0);
}

- (void)setScale:(float)value
{
    scale = value;

    scaledImageSize.width = (int)(imageSize.width * scale);
    scaledImageSize.height = (int)(imageSize.height * scale);

    NSWindow *window = self.mainView.window;
    float left = window.frame.origin.x;
    float top = window.frame.origin.y + window.frame.size.height;

    NSRect imageRect = NSMakeRect(0, 0, scaledImageSize.width, scaledImageSize.height);

    NSRect windowFrame = [window frameRectForContentRect:imageRect];
    windowFrame.origin.x = left;
    windowFrame.origin.y = top - windowFrame.size.height;
    [window setFrame:windowFrame display:YES animate:YES];

    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(updateAfterScaling:) userInfo:nil repeats:NO];
}

- (void)updateAfterScaling:(NSTimer *)timer
{
    NSView *documentView = self.mainView;
    NSWindow *window = self.mainView.window;

    NSRect imageRect = NSMakeRect(0, 0, scaledImageSize.width, scaledImageSize.height);

    documentView.frame = imageRect;
    CALayer *layer = documentView.layer;
    layer.frame = CGRectMake(0, 0, scaledImageSize.width, scaledImageSize.height);
    window.contentSize = scaledImageSize;
    window.contentMaxSize = scaledImageSize;

    [self applyFilters:self];
}

- (IBAction)setScaleOriginal:(id)sender
{
    // TODO: スケール変更の実装
    //[self setScale:1.0];
}

- (IBAction)setScale50p:(id)sender
{
    // TODO: スケール変更の実装
    //[self setScale:0.9];
}

@end


