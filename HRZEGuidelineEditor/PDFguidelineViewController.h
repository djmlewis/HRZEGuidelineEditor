//
//  PDFguidelineViewController.h
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 23/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

@class PDFView;

#import <Cocoa/Cocoa.h>

@interface PDFguidelineViewController : NSViewController


@property (weak) IBOutlet PDFView *pdfView;




-(void)setPDFdocumentWithPDFData:(NSData *)pdfData;


@end
