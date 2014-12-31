//
//  IndicationEditViewController.m
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 03/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "IndicationViewController.h"
#import "PrefixHeader.pch"
#import "HandyRoutines.h"
#import "GuidelineViewController.h"
#import "DrugViewController.h"   

#define kColourPanel_Text 0
#define kColourPanel_Page 1


@interface IndicationViewController ()

@end

@implementation IndicationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
    self.allowUpdatesFromView = YES;
}


-(void)viewWillAppear
{
    [super viewWillAppear];
    self.myGuidelineDisplayingViewController.visualEffectsView.hidden = YES;
    //self.view.wantsLayer = YES;
    //self.view.layer.backgroundColor = [[NSColor colorWithCalibratedWhite:0.72f alpha:1.0f] CGColor];
    //self.frameView.layer.backgroundColor = [[NSColor colorWithCalibratedWhite:0.98f alpha:1.0f] CGColor];
    //[[NSColor colorWithCalibratedWhite:0.75f alpha:1.0f] CGColor];
    //[[NSColor colorWithCalibratedRed:245.0f/255.0f green:1.0f blue:1.0f alpha:1.0f] CGColor];
}

-(void)viewWillDisappear
{
    [super viewWillDisappear];
    self.myGuidelineDisplayingViewController.visualEffectsView.hidden = NO;
}

-(void)saveGuideline
{
    [self.myGuidelineDisplayingViewController saveGuideline];
}


#pragma mark - Colours
- (IBAction)showColourPanel:(NSButton *)sender
{
    if ([[NSColorPanel sharedColorPanel] isVisible])
    {
        if (sender.state == NSOnState)
        {
            [self doShowColourPanelFromButton:sender];
        }
        else
        {
            [[NSColorPanel sharedColorPanel] setTarget:nil];
            [[NSColorPanel sharedColorPanel] orderOut:self];
            self.buttonColourPage.state = NSOffState;
            self.buttonColourText.state = NSOffState;
        }
    }
    else
    {
        if (sender.state == NSOnState)
        {
            [self doShowColourPanelFromButton:sender];
        }
        else
            
        {
            self.buttonColourPage.state = NSOffState;
            self.buttonColourText.state = NSOffState;
        }
    }
}

-(void)alignColoursForIndication:(NSMutableDictionary *)indication
{
    NSColor *colour = [HandyRoutines colourFromString:[indication objectForKey:kKey_IndicationColour_Header]];
    if (colour)
    {
        self.textFieldIndicationName.backgroundColor = colour;
        self.textViewIndicationComments.textColor = colour;

    }
    else
    {
        self.textFieldIndicationName.backgroundColor = [NSColor blackColor];
        self.textViewIndicationComments.textColor = [NSColor blackColor];

    }
    colour = [HandyRoutines colourFromString:[indication objectForKey:kKey_IndicationColour_Page]];
    if (CGColorEqualToColor(colour.CGColor, [[NSColor blackColor] CGColor]))
    {
        self.textViewIndicationComments.backgroundColor = [NSColor whiteColor];
    }
    else
    {
        self.textViewIndicationComments.backgroundColor = colour;
    }

}


-(void)doShowColourPanelFromButton:(NSButton *)sender
{
    self.colourPanelInPlay = sender.tag;
    [[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
    [[NSColorPanel sharedColorPanel] setMode:NSCrayonModeColorPanel];
    [[NSColorPanel sharedColorPanel] setTarget:self];
    [[NSColorPanel sharedColorPanel] setAction:@selector(colourPanelChangedColour:)];
    [[NSColorPanel sharedColorPanel] orderFront:self];
    switch (self.colourPanelInPlay) {
        case kColourPanel_Text:
            self.buttonColourPage.state = NSOffState;
            [[NSColorPanel sharedColorPanel] setColor:self.textFieldIndicationName.backgroundColor];
            break;
        case kColourPanel_Page:
            self.buttonColourText.state = NSOffState;
            [[NSColorPanel sharedColorPanel] setColor:self.textViewIndicationComments.backgroundColor];
            break;
    }

}

- (void)colourPanelChangedColour:(NSColorPanel *)sender
{
    switch (self.colourPanelInPlay)
    {
        case kColourPanel_Text:
            self.textFieldIndicationName.backgroundColor = sender.color;
            self.textViewIndicationComments.textColor = sender.color;
           break;
        case kColourPanel_Page:
            self.textViewIndicationComments.backgroundColor  = sender.color;//[HandyRoutines colourFromColourMadeFaint:sender.color];
            break;
    }
    [self alignIndicationWithView];
}

#pragma mark - IBActions

- (IBAction)checkboxInitiallyHideIndicationCommentsChanged:(NSButton *)sender {
    [self alignIndicationWithView];
}


#pragma mark - aligning
-(void)alignDisplayWithIndication:(NSMutableDictionary *)indication
{
    self.indicationInPlay = indication;
    [self createDrugArrayIfNeeded];
    self.allowUpdatesFromView = NO;
    [self reloadDrugsTableViewSavingSelection:NO];
    [self.textFieldIndicationName setStringValue:[HandyRoutines stringFromStringTakingAccountOfNull: [indication objectForKey:kKey_IndicationName]]];
    [self.textFieldDosingInstructions setStringValue:[HandyRoutines stringFromStringTakingAccountOfNull: [indication objectForKey:kKey_IndicationDosingInstructions]]];
    [self.textViewIndicationComments setString:[HandyRoutines stringFromStringTakingAccountOfNull: [indication objectForKey:kKey_IndicationComments]]];
    [self alignColoursForIndication:indication];
    [self.checkBoxHideComments setState:[[indication objectForKey:kKey_Indication_HideComments] boolValue]];
    [self displayDrugInfoForRow:0];
    self.allowUpdatesFromView = YES;
}


-(void)alignIndicationWithViewAsSelectionIsChanging
{
    [self.embeddedDrugEditingViewController alignDrugWithViewAsSelectionIsChanging];
    [self alignIndicationWithView];
}



-(void)alignIndicationWithView
{
    if (self.allowUpdatesFromView)
    {
        self.allowUpdatesFromView = NO;
        [self.indicationInPlay setObject:[HandyRoutines stringFromStringTakingAccountOfNull:self.textFieldIndicationName.stringValue] forKey:kKey_IndicationName];
        [self.indicationInPlay setObject:[HandyRoutines stringFromStringTakingAccountOfNull:self.textFieldDosingInstructions.stringValue] forKey:kKey_IndicationDosingInstructions];
        [self.indicationInPlay setObject:[HandyRoutines stringFromStringTakingAccountOfNull:self.textViewIndicationComments.string] forKey:kKey_IndicationComments];
        
        [self.indicationInPlay setObject:[HandyRoutines stringFromNSColor:self.textViewIndicationComments.backgroundColor] forKey:kKey_IndicationColour_Page];
        [self.indicationInPlay setObject:[HandyRoutines stringFromNSColor:self.textFieldIndicationName.backgroundColor] forKey:kKey_IndicationColour_Header];

        
        [self.indicationInPlay setObject:[NSNumber numberWithBool:self.checkBoxHideComments.state] forKey:kKey_Indication_HideComments];
        
        [self saveGuideline];
        self.allowUpdatesFromView = YES;
    }

}

#pragma mark - NSTextFieldDelegate
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    if ([control.identifier isEqualToString:@"textFieldIndicationName"])
    {
        if ((fieldEditor.string.length == 0))
        {
            return NO;
        }
        [self.myGuidelineDisplayingViewController reloadTableViewSavingSelection:YES];
    }
    [self alignIndicationWithView];
    return YES;
}

#pragma mark - NSTextViewdelegate
- (void)textDidEndEditing:(NSNotification *)notification
{
    [self alignIndicationWithView];
}

- (void)textViewDidChangeTypingAttributes:(NSNotification *)aNotification
{
    [self alignIndicationWithView];
}

#pragma mark - Drugs

- (IBAction)tableViewDrugsTapped:(NSTableView *)sender
{
    [self displayDrugInfoForRow:[sender selectedRow]];
}

-(void)displayDrugInfoForRow:(NSInteger)row
{
    if ([(NSMutableArray *)[self.indicationInPlay objectForKey:kKey_ArrayOfDrugs] count] >0 &&
        row<[(NSMutableArray *)[self.indicationInPlay objectForKey:kKey_ArrayOfDrugs] count])
    {
        [self.embeddedDrugEditingViewController alignViewWithDrug:[(NSMutableArray *)[self.indicationInPlay objectForKey:kKey_ArrayOfDrugs] objectAtIndex:row]];
        self.embeddedDrugEditingViewController.view.hidden = NO;
        [self reloadDrugsTableViewSavingSelection:YES];
    }
    else
    {
        [self reloadDrugsTableViewSavingSelection:NO];
        self.embeddedDrugEditingViewController.view.hidden = YES;
    }
}

-(void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedDrugEditVC"])
    {
        //comes first before we get a document
        self.embeddedDrugEditingViewController = (DrugViewController *)segue.destinationController;
        self.embeddedDrugEditingViewController.myIndicationEditViewController = self;
        self.embeddedDrugEditingViewController.view.hidden = YES;
    }
    
    
}

#pragma mark - Add/remove drugs

- (IBAction)segmentAddRemoveDrugTapped:(NSSegmentedControl *)sender
{
    [self.embeddedDrugEditingViewController alignDrugWithViewAsSelectionIsChanging];
    // NSInteger selSeg = sender.selectedSegment;
    switch (sender.selectedSegment) {
        case 0:
            [self addNewDrug];
            break;
        case 1:
        {
            [self deleteSelectedDrug];
        }
            break;
    }
}



-(void)createDrugArrayIfNeeded
{
    if ((NSMutableArray *)[self.indicationInPlay objectForKey:kKey_ArrayOfDrugs] == nil)
    {
        [self.indicationInPlay setObject:[NSMutableArray array] forKey:kKey_ArrayOfDrugs];
    }

}

-(void)addNewDrug
{
    NSMutableDictionary *drug = [HandyRoutines newEmptyDrugWithCalculationType:kDoseCalculationBy_MgKg_Adjustable];
    [self createDrugArrayIfNeeded];
    
    [(NSMutableArray *)[self.indicationInPlay objectForKey:kKey_ArrayOfDrugs] addObject:drug];
    [self reloadDrugsTableViewSavingSelection:NO];
    [self.tableViewDrugs selectRowIndexes:[NSIndexSet indexSetWithIndex:[(NSMutableArray *)[self.indicationInPlay objectForKey:kKey_ArrayOfDrugs] count]-1] byExtendingSelection:NO];
    [self displayDrugInfoForRow:[(NSMutableArray *)[self.indicationInPlay objectForKey:kKey_ArrayOfDrugs] count]-1];
    [self saveGuideline];
}

-(void)deleteSelectedDrug
{
    NSInteger row = [self.tableViewDrugs selectedRow];
    if (row >=0 && row<[(NSMutableArray *)[self.indicationInPlay objectForKey:kKey_ArrayOfDrugs] count])
    {
        NSString *nameOfDrug = [HandyRoutines stringFromStringTakingAccountOfNull:[[(NSMutableArray *)[self.indicationInPlay objectForKey:kKey_ArrayOfDrugs] objectAtIndex:row] objectForKey:kKey_DrugDisplayName]];

        NSAlert *alert = [[NSAlert alloc] init];
        [alert setAlertStyle:NSCriticalAlertStyle];
        [alert setMessageText:[NSString stringWithFormat:@"Are you sure you want to delete '%@'?\nThis cannot be undone.",nameOfDrug]];
        [alert addButtonWithTitle:@"Delete"];
        [alert addButtonWithTitle:@"Cancel"];
        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
            if (returnCode == NSAlertFirstButtonReturn)
            {
                self.embeddedDrugEditingViewController.view.hidden = YES;
                [(NSMutableArray *)[self.indicationInPlay objectForKey:kKey_ArrayOfDrugs] removeObjectAtIndex:row];
                [self reloadDrugsTableViewSavingSelection:NO];
                [self saveGuideline];
                [self displayDrugInfoForRow:0];
            };
        }];
    }
}

#pragma mark - TableView DataSource & Delegate

-(void)reloadDrugsTableViewSavingSelection:(BOOL)saveSelection
{
    NSInteger row = [self.tableViewDrugs selectedRow];
    [self.tableViewDrugs reloadData];
    if (saveSelection &&  row>=0) {
        [self.tableViewDrugs selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    }
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    [self createDrugArrayIfNeeded];
    return [(NSMutableArray *)[self.indicationInPlay objectForKey:kKey_ArrayOfDrugs] count];
}


- (NSView *)tableView:(NSTableView *)tableView   viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    // Retrieve to get the @"MyView" from the pool or,
    // if no version is available in the pool, load the Interface Builder version
    NSTableCellView *result = [tableView makeViewWithIdentifier:@"drugs" owner:self];
    
    // Set the stringValue of the cell's text field to the nameArray value at row
    NSMutableDictionary *drug = [(NSMutableArray *)[self.indicationInPlay objectForKey:kKey_ArrayOfDrugs] objectAtIndex:row];
    result.textField.stringValue = [HandyRoutines stringFromStringTakingAccountOfNull:[drug objectForKey:kKey_DrugDisplayName]];
    if ([[drug objectForKey:kKey_DrugShowInList] boolValue]==YES) {
        result.textField.textColor = [NSColor blackColor];
    }
    else
    {
        result.textField.textColor = [NSColor darkGrayColor];
    }
    // Return the result
    return result;
}


@end
