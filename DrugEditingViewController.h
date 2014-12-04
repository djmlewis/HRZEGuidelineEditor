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



-(void)displayDrugInfo:(NSMutableDictionary *)drug;




@end
