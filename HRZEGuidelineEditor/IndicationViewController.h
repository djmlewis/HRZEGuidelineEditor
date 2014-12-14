//
//  IndicationEditViewController.h
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 03/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class GuidelineViewController;
@class DrugViewController;


@interface IndicationViewController : NSViewController
<
NSTextFieldDelegate, NSTextViewDelegate,
NSBrowserDelegate
>

@property BOOL allowUpdatesFromView;


@property (strong) GuidelineViewController *myGuidelineDisplayingViewController;
@property (strong) DrugViewController *embeddedDrugEditingViewController;

@property (strong) NSMutableDictionary *indicationInPlay;
@property (unsafe_unretained) IBOutlet NSTextView *textViewIndicationComments;
@property (weak) IBOutlet NSButton *checkBoxHideComments;
@property (weak) IBOutlet NSTextField *textFieldDosingInstructions;

@property (weak) IBOutlet NSTableView *tableViewDrugs;

@property (weak) IBOutlet NSTextField *textFieldIndicationName;




-(void)alignDisplayWithIndication:(NSMutableDictionary *)indication;
-(void)alignIndicationWithView;
-(void)saveGuideline;
-(void)reloadTableViewSavingSelection:(BOOL)saveSelection;

@end
