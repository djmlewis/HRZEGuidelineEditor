//
//  ThresholdTableCellView.h
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 06/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DrugViewController;

@interface ThresholdTableCellView : NSTableCellView
<
    NSTextFieldDelegate
>
@property BOOL allowUpdatesFromView;

@property (strong) DrugViewController *myDrugEditingViewController;
@property (strong) NSMutableDictionary *threshold;

@property NSInteger callingRow;

@property (weak) IBOutlet NSSegmentedControl *segmentThresholdBoolean;
@property (weak) IBOutlet NSTextField *textFieldThresholdWeight;
@property (weak) IBOutlet NSTextField *textFieldThresholdDose;
@property (weak) IBOutlet NSTextField *textFieldThresholdDosageForm;



-(void)zeroThresholdFields;

-(void)setupCellFromDrugEditingViewController:(DrugViewController *)theDrugEditingViewController withThreshold:(NSMutableDictionary *)threshold;
-(void)alignThresholdWithView;

@end
