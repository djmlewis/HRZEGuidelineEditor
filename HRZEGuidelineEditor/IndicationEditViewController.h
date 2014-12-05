//
//  IndicationEditViewController.h
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 03/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class GuidelineDisplayingViewController;
@class DrugEditingViewController;


@interface IndicationEditViewController : NSViewController
<
NSTextFieldDelegate, NSTextViewDelegate,
NSBrowserDelegate
>



@property (strong) GuidelineDisplayingViewController *myGuidelineDisplayingViewController;
@property (strong) DrugEditingViewController *embeddedDrugEditingViewController;

@property (strong) NSMutableArray *arrayDrugsInIndication;
@property (strong) NSMutableDictionary *indicationBeingDisplayed;
@property (unsafe_unretained) IBOutlet NSTextView *textViewIndicationComments;
@property (weak) IBOutlet NSButton *checkBoxHideComments;
@property (weak) IBOutlet NSTextField *textFieldDosingInstructions;

@property (weak) IBOutlet NSTableView *tableViewDrugs;

@property (weak) IBOutlet NSTextField *textFieldIndicationName;




-(void)updateIndicationDisplayForIndication:(NSMutableDictionary *)indication;


@end