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




@interface PDFguidelineViewController ()

@end

@implementation PDFguidelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

-(void)viewWillAppear
{
    [super viewWillAppear];
    //NSURL *url = [self.callingGuidelineViewController createPDFFile:CGSizeMake(842.0f,1190.0f)];
    self.pdfView.document = [[PDFDocument alloc] initWithData:[self.callingGuidelineViewController createPDFData:CGSizeMake(842.0f,1190.0f)]];
}

@end
