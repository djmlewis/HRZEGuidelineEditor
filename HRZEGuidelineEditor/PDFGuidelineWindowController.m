//
//  PDFGuidelineWindowController.m
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 23/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import "PDFGuidelineWindowController.h"
#import "PDFguidelineViewController.h"
#import "GuidelineViewController.h"


@interface PDFGuidelineWindowController ()

@end

@implementation PDFGuidelineWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
}

-(void)setPDFdocumentWithPDFData:(NSData *)pdfData
{
    [self.embeddedPDFguidelineViewController setPDFdocumentWithPDFData:pdfData];
}
@end
