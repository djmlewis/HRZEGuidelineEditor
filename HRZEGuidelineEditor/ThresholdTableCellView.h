//
//  ThresholdTableCellView.h
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 06/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ThresholdTableCellView : NSTableCellView




@property (weak) IBOutlet NSSegmentedControl *segmentThresholdBoolean;
@property (weak) IBOutlet NSTextField *textFieldThresholdWeight;
@property (weak) IBOutlet NSTextField *textFieldThresholdDose;
@property (weak) IBOutlet NSTextField *textFieldThresholdDosageForm;



-(void)zeroTheCalculationFields;




@end
