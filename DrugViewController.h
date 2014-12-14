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

//@property (strong) NSMutableArray *arrayThresholdBooleans;
//@property (strong) NSMutableArray *arrayThresholdWeights;
//@property (strong) NSMutableArray *arrayThresholdDoses;
//@property (strong) NSMutableArray *arrayThresholdDoseForms;




@property (weak) IBOutlet NSTextField *textFieldDrugName;
@property (unsafe_unretained) IBOutlet NSTextView *textViewDrugDescription;
@property (weak) IBOutlet NSButton *checkboxShowDrugInList;
@property (weak) IBOutlet NSTabView *tabViewCalculationType;
@property (weak) IBOutlet NSPopUpButton *popupButtonCalculationType;

@property BOOL allowUpdatesFromView;

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

//single dose
@property (weak) IBOutlet NSTextField *textFieldSingleDosagedescription;

//threshold
@property (weak) IBOutlet NSSegmentedControl *segmentThresholdAddRemove;
@property (weak) IBOutlet NSTextField *textFieldThresholdMinimumWeightAllowed;
@property (weak) IBOutlet NSTableView *tableViewThresholds;




-(void)alignViewWithDrug:(NSMutableDictionary *)drug;
-(void)alignDrugWithView;
-(void)saveGuideline;


@end
