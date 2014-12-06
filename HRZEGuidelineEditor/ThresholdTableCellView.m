//
//  ThresholdTableCellView.m
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 06/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import "ThresholdTableCellView.h"

@implementation ThresholdTableCellView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}



-(void)zeroTheCalculationFields
{
    [self.textFieldThresholdDosageForm setStringValue:@""];
    [self.textFieldThresholdDose setStringValue:@""];
    [self.textFieldThresholdWeight setStringValue:@""];
    [self.segmentThresholdBoolean setSelectedSegment:0];
    
}







@end
