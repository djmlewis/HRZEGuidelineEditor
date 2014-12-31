//
//  DrugEditingViewController.h
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 04/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class IndicationViewController;


@interface DrugViewController : NSViewController
<
NSTextFieldDelegate, NSTextViewDelegate,
NSTableViewDataSource, NSTableViewDelegate
>

@property (strong) IndicationViewController *myIndicationEditViewController;
@property (strong) NSMutableDictionary *drugInPlay;
@property BOOL allowUpdatesFromView;

//@property (strong) NSMutableArray *arrayThresholdBooleans;
//@property (strong) NSMutableArray *arrayThresholdWeights;
//@property (strong) NSMutableArray *arrayThresholdDoses;
//@property (strong) NSMutableArray *arrayThresholdDoseForms;



@property (weak) IBOutlet NSView *frameView;

@property (weak) IBOutlet NSTextField *textFieldDrugName;
@property (weak) IBOutlet NSButton *checkboxShowDrugInList;
@property (weak) IBOutlet NSTabView *tabViewCalculationType;
@property (weak) IBOutlet NSPopUpButton *popupButtonCalculationType;
@property (unsafe_unretained) IBOutlet NSTextView *textViewDrugInfo;


//mg/Kg
@property (weak) IBOutlet NSTextField *textFieldmgkgDoseage;
@property (weak) IBOutlet NSTextField *textFieldMinDosage;
@property (weak) IBOutlet NSTextField *textFieldMaxDosage;
@property (weak) IBOutlet NSTextField *textFieldRoundingValue;
@property (weak) IBOutlet NSTextField *textFieldMaximumFinalDose;
@property (weak) IBOutlet NSSegmentedControl *segmentRoundingDirection;
@property (weak) IBOutlet NSButton *checkboxAllowAdjustment;
@property (weak) IBOutlet NSTextField *textFieldLabelMinMgKg;
@property (weak) IBOutlet NSTextField *textFieldLabelMaxMgKg;
@property (weak) IBOutlet NSTextField *textFieldDoseUnits;

@property (weak) IBOutlet NSTextField *labelMinMgKg;
@property (weak) IBOutlet NSTextField *labelMaxMgKg;
@property (weak) IBOutlet NSTextField *labelRoundMg;
@property (weak) IBOutlet NSTextField *labelMaxDoseMg;


//single dose
@property (weak) IBOutlet NSTextField *textFieldSingleDosagedescription;

//threshold
@property (weak) IBOutlet NSSegmentedControl *segmentThresholdAddRemove;
@property (weak) IBOutlet NSTextField *textFieldThresholdMinimumWeightAllowed;
@property (weak) IBOutlet NSTableView *tableViewThresholds;




-(void)alignViewWithDrug:(NSMutableDictionary *)drug;
-(void)alignDrugWithView;
-(void)alignDrugWithViewAsSelectionIsChanging;
-(void)saveGuideline;


@end
