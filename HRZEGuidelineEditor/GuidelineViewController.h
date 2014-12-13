//
//  ViewController.h
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 02/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//
@class GuidelineDocument;
@class IndicationViewController;


#import <Cocoa/Cocoa.h>

@interface GuidelineViewController : NSViewController
<
    NSTextFieldDelegate, NSTextViewDelegate,
NSTableViewDataSource, NSTableViewDelegate
>



@property BOOL allowUpdatesFromView;



@property (strong) GuidelineDocument *myGuidelineDocument;
@property (strong) IndicationViewController *embeddedIndicationEditViewController;


@property (unsafe_unretained) IBOutlet NSTextView *textViewGuidelineDescription;
@property (weak) IBOutlet NSSegmentedControl *segmentAddRemoveIndication;
@property (weak) IBOutlet NSTableView *tableViewIndications;


-(void)alignGuidelineWithView;
-(void)reloadTableViewSavingSelection:(BOOL)saveSelection;
-(void)saveGuideline;







@end

