//
//  DrugEditingViewController.h
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 04/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class IndicationEditViewController;


@interface DrugEditingViewController : NSViewController
<
NSTextFieldDelegate,
NSTableViewDataSource, NSTableViewDelegate
>

@property (strong) IndicationEditViewController *myIndicationEditViewController;
@property (strong) NSMutableDictionary *drugDisplayed;

@property (strong) NSMutableArray *arrayThresholdBooleans;
@property (strong) NSMutableArray *arrayThresholdWeights;
@property (strong) NSMutableArray *arrayThresholdDoses;
@property (strong) NSMutableArray *arrayThresholdDoseForms;




@property (weak) IBOutlet NSTextField *textFieldDrugName;
@property (unsafe_unretained) IBOutlet NSTextView *textViewDrugDescription;
@property (weak) IBOutlet NSButton *checkboxShowDrugInList;
@property (weak) IBOutlet NSTabView *tabViewCalculationType;


//mg/Kg
@property (weak) IBOutlet NSTextField *textFieldmgkgDoseage;
@property (weak) IBOutlet NSTextField *textFieldMinDosage;
@property (weak) IBOutlet NSTextField *textFieldMaxDosage;
@property (weak) IBOutlet NSTextField *textFieldRoundingValue;
@property (weak) IBOutlet NSTextField *textFieldMaximumFinalDose;
@property (weak) IBOutlet NSSegmentedControl *segmentRoundingDirection;
@property (weak) IBOutlet NSButton *checkboxAllowAdjustment;
@property (weak) IBOutlet NSView *containerViewAdjustDosage;

//single dose
@property (weak) IBOutlet NSTextField *textFieldSingleDosagedescription;

//threshold
@property (weak) IBOutlet NSSegmentedControl *segmentThresholdAddRemove;
@property (weak) IBOutlet NSTextField *textFieldThresholdMinimumWeightAllowed;
@property (weak) IBOutlet NSTableView *tableViewThresholds;








-(void)displayDrugInfo:(NSMutableDictionary *)drug;
-(void)updateDrugFromViewAndUpdateCallingIndication:(BOOL)updateCallingIndication;



@end
