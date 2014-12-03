//
//  IndicationEditViewController.h
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 03/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class GuidelineDisplayingViewController;


@interface IndicationEditViewController : NSViewController
<
NSTextFieldDelegate, NSTextViewDelegate,
NSBrowserDelegate
>



@property (strong) GuidelineDisplayingViewController *myGuidelineDisplayingViewController;

@property (strong) NSMutableArray *arrayDrugsInIndication;
@property (strong) NSMutableDictionary *indicationBeingDisplayed;


@property (weak) IBOutlet NSTextField *textFieldIndicationName;
@property (weak) IBOutlet NSBrowser *browserDrugs;




-(void)updateIndicationDisplayForIndication:(NSMutableDictionary *)indication;


@end
