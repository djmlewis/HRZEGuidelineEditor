//
//  ViewController.h
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 02/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//
@class GuidelineDocument;
@class IndicationEditViewController;


#import <Cocoa/Cocoa.h>

@interface GuidelineDisplayingViewController : NSViewController
<
    NSTextFieldDelegate, NSTextViewDelegate,
NSBrowserDelegate
>






@property (strong) GuidelineDocument *myGuidelineDocument;
@property (strong) IndicationEditViewController *embeddedIndicationEditViewController;
@property (strong) NSMutableArray *arrayIndicationsInGuideline;

@property (unsafe_unretained) IBOutlet NSTextView *textViewGuidelineDescription;



-(void)updateDocumentFromView;










@end

