//
//  IndicationEditViewController.m
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 03/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import "IndicationViewController.h"
#import "PrefixHeader.pch"
#import "HandyRoutines.h"
#import "GuidelineViewController.h"
#import "DrugViewController.h"   



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
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor lightGrayColor].CGColor;
}

-(void)saveGuideline
{
    [self.myGuidelineDisplayingViewController saveGuideline];
}
- (IBAction)showColourPanel:(NSButton *)sender
{
    if ([[NSColorPanel sharedColorPanel] isVisible])
    {
        [[NSColorPanel sharedColorPanel] orderOut:self];
    }
    else
    {
        [[NSColorPanel sharedColorPanel] setShowsAlpha:NO];
        [[NSColorPanel sharedColorPanel] setMode:NSCrayonModeColorPanel];
        [[NSColorPanel sharedColorPanel] setTarget:self];
        [[NSColorPanel sharedColorPanel] setAction:@selector(colourWellAction:)];
        [[NSColorPanel sharedColorPanel] orderFront:self];

    }
}

- (void)colourWellAction:(NSColorPanel *)sender
{
    CGFloat h;
    CGFloat s;
    CGFloat b;
    CGFloat a;

    [sender.color getHue:&h saturation:&s brightness:&b alpha:&a];
    self.textFieldIndicationName.backgroundColor = [HandyRoutines colourFromHue:[NSNumber numberWithFloat:h]];
    //[self.textViewIndicationComments.backgroundColor]  = [NSColor colorWithCalibratedHue:h saturation:s brightness:kColourDefaultBrightness alpha:1.0f];
}

-(void)alignDisplayWithIndication:(NSMutableDictionary *)indication
{
    self.indicationInPlay = indication;
    [self createDrugArrayIfNeeded];
    self.allowUpdatesFromView = NO;
    [self reloadTableViewSavingSelection:NO];
    [self.textFieldIndicationName setStringValue:[HandyRoutines stringFromStringTakingAccountOfNull: [indication objectForKey:kKey_IndicationName]]];
    [self.textFieldDosingInstructions setStringValue:[HandyRoutines stringFromStringTakingAccountOfNull: [indication objectForKey:kKey_IndicationDosingInstructions]]];
    [[self.textViewIndicationComments textStorage] setAttributedString:[HandyRoutines attributedStringFromDescriptionData:[indication objectForKey:kKey_IndicationComments]]];
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
        [self.indicationInPlay setObject:[HandyRoutines dataForDescriptionAttributedString:self.textViewIndicationComments.attributedString] forKey:kKey_IndicationComments];
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
        [self reloadTableViewSavingSelection:YES];
    }
    else
    {
        [self reloadTableViewSavingSelection:NO];
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
    [self reloadTableViewSavingSelection:NO];
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
                [self reloadTableViewSavingSelection:NO];
                [self saveGuideline];
                [self displayDrugInfoForRow:0];
            };
        }];
    }
}

#pragma mark - TableView DataSource & Delegate

-(void)reloadTableViewSavingSelection:(BOOL)saveSelection
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
    result.textField.stringValue = [HandyRoutines stringFromStringTakingAccountOfNull:[[(NSMutableArray *)[self.indicationInPlay objectForKey:kKey_ArrayOfDrugs] objectAtIndex:row] objectForKey:kKey_DrugDisplayName]];
    
    // Return the result
    return result;
}


@end
