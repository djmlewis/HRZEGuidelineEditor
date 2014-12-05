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
NSTextFieldDelegate
>

@property (strong) IndicationEditViewController *myIndicationEditViewController;
@property (strong) NSMutableDictionary *drugDisplayed;

@property (weak) IBOutlet NSTextField *textFieldDrugName;
@property (unsafe_unretained) IBOutlet NSTextView *textViewDrugDescription;



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










-(void)displayDrugInfo:(NSMutableDictionary *)drug;




@end
