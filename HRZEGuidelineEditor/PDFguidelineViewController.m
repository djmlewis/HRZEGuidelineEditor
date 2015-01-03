//
//  PDFguidelineViewController.m
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 23/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import "PDFguidelineViewController.h"
#import "GuidelineViewController.h"
#import <Quartz/Quartz.h>

#import "PDFGuidelineWindowController.h"


@interface PDFguidelineViewController ()

@end

@implementation PDFguidelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [(PDFGuidelineWindowController *)[[self.view window] windowController] setEmbeddedPDFguidelineViewController:self];
}

-(void)setPDFdocumentWithPDFData:(NSData *)pdfData
{
    self.pdfView.document = [[PDFDocument alloc] initWithData:pdfData];

}

-(void)viewWillAppear
{
    [super viewWillAppear];

}

@end
