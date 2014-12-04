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
NSTableViewDataSource, NSTableViewDelegate
>






@property (strong) GuidelineDocument *myGuidelineDocument;
@property (strong) IndicationEditViewController *embeddedIndicationEditViewController;
@property (strong) NSMutableArray *arrayIndicationsInGuideline;

@property (unsafe_unretained) IBOutlet NSTextView *textViewGuidelineDescription;
@property (weak) IBOutlet NSSegmentedControl *segmentAddRemoveIndication;

@property (weak) IBOutlet NSTableView *tableViewIndications;


-(void)updateDocumentFromView;
-(void)reloadTableViewSavingSelection:(BOOL)saveSelection;








@end

