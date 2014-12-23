//
//  PDFGuidelineWindowController.h
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 23/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

@class GuidelineViewController;
@class PDFguidelineViewController;


#import <Cocoa/Cocoa.h>

@interface PDFGuidelineWindowController : NSWindowController

@property (strong) GuidelineViewController *callingGuidelineViewController;
@property (strong) PDFguidelineViewController *embeddedPDFguidelineViewController;

-(void)setPDFdocumentWithPDFData:(NSData *)pdfData;

@end
