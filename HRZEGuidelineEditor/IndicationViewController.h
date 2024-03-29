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



@property (weak) IBOutlet NSView *frameView;
@property (weak) IBOutlet NSVisualEffectView *visualEffectsView;

@property (strong) NSMutableDictionary *indicationInPlay;
@property (weak) IBOutlet NSButton *checkBoxHideComments;
@property (weak) IBOutlet NSButton *buttonColourText;
@property (weak) IBOutlet NSButton *buttonColourPage;


@property (unsafe_unretained) IBOutlet NSTextView *textViewIndicationComments;
@property (weak) IBOutlet NSTextField *textFieldDosingInstructions;

@property (weak) IBOutlet NSTableView *tableViewDrugs;

@property (weak) IBOutlet NSTextField *textFieldIndicationName;

@property NSInteger colourPanelInPlay;


-(void)alignIndicationWithViewAsSelectionIsChanging;
-(void)alignDisplayWithIndication:(NSMutableDictionary *)indication;
-(void)alignIndicationWithView;
-(void)saveGuideline;
-(void)reloadDrugsTableViewSavingSelection:(BOOL)saveSelection;

@end
