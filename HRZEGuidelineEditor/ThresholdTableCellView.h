//
//  ThresholdTableCellView.h
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 06/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DrugEditingViewController;

@interface ThresholdTableCellView : NSTableCellView
<
    NSTextFieldDelegate
>

@property (strong) DrugEditingViewController *myDrugEditingViewController;
@property NSInteger callingRow;

@property (weak) IBOutlet NSSegmentedControl *segmentThresholdBoolean;
@property (weak) IBOutlet NSTextField *textFieldThresholdWeight;
@property (weak) IBOutlet NSTextField *textFieldThresholdDose;
@property (weak) IBOutlet NSTextField *textFieldThresholdDosageForm;



-(void)zeroTheCalculationFields;

-(void)setupCellFromDrugEditingViewController:(DrugEditingViewController *)theDrugEditingViewController forArrayRow:(NSInteger)arrayRow;
-(void)updateDrugFromView;

@end
