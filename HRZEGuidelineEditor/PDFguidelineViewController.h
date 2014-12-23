//
//  PDFguidelineViewController.h
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 23/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

@class GuidelineViewController;
@class PDFView;

#import <Cocoa/Cocoa.h>

@interface PDFguidelineViewController : NSViewController

@property (strong) GuidelineViewController *callingGuidelineViewController;

@property (weak) IBOutlet PDFView *pdfView;

@end
