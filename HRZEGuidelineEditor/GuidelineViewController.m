//
//  ViewController.m
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 02/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import "PrefixHeader.pch"
#import "GuidelineDocument.h"
#import "GuidelineViewController.h"
#import "HandyRoutines.h"
#import "IndicationViewController.h"


@implementation GuidelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear
{
    [super viewWillAppear];
    self.myGuidelineDocument = [[[self.view window] windowController] document];
    self.myGuidelineDocument.myGuidelineDisplayingViewController = self;
    if ((NSMutableArray *)[self.myGuidelineDocument.dictionaryGuideline objectForKey:kKey_GuidelineArrayOfIndications] == nil)
    {
       [self.myGuidelineDocument.dictionaryGuideline setObject:[NSMutableArray array] forKey:kKey_GuidelineArrayOfIndications] ;
    }

    [self alignViewWithGuideline];
}

-(void)viewWillDisappear
{
    [super viewWillDisappear];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


-(void)saveGuideline
{
    [self.myGuidelineDocument updateChangeCount:NSChangeDone];
}

-(void)alignViewWithGuideline
{
    //comed after the embed segue

    [[self.textViewGuidelineDescription textStorage] setAttributedString:[HandyRoutines attributedStringFromDescriptionData:[self.myGuidelineDocument.dictionaryGuideline objectForKey:kKey_GuidelineDescription]]];
    [self reloadTableViewSavingSelection:YES];
    [self displayFirstIndication];
}

-(void)alignGuidelineWithView
{
    [self.myGuidelineDocument.dictionaryGuideline setObject:[HandyRoutines dataForDescriptionAttributedString:self.textViewGuidelineDescription.attributedString] forKey:kKey_GuidelineDescription];
    //[self.myGuidelineDocument.dictionaryGuideline setObject:self.arrayIndicationsInGuideline forKey:kKey_GuidelineArrayOfIndications];
    [self saveGuideline];
}

-(void)resignAllFirstresponders
{
    [self.textViewGuidelineDescription resignFirstResponder];

}

#pragma mark - NSTextViewdelegate
- (void)textDidEndEditing:(NSNotification *)notification
{
    [self alignGuidelineWithView];
}

- (void)textViewDidChangeTypingAttributes:(NSNotification *)aNotification
{
    [self alignGuidelineWithView];
}


#pragma mark - Add/remove indications

- (IBAction)segmentAddRemoveIndicationTapped:(NSSegmentedControl *)sender
{
   // NSInteger selSeg = sender.selectedSegment;
    switch (sender.selectedSegment) {
        case 0:
            [self addNewIndicationWithName:@"Untitled"];
            break;
        case 1:
            [self deleteSelectedIndication];
            break;
    }
}

-(void)addNewIndicationWithName:(NSString *)name
{
    NSMutableDictionary *indication = [HandyRoutines newEmptyIndicationWithName:name];
    [(NSMutableArray *)[self.myGuidelineDocument.dictionaryGuideline objectForKey:kKey_GuidelineArrayOfIndications] addObject:indication];
    [self reloadTableViewSavingSelection:NO];
    [self.tableViewIndications selectRowIndexes:[NSIndexSet indexSetWithIndex:[(NSMutableArray *)[self.myGuidelineDocument.dictionaryGuideline objectForKey:kKey_GuidelineArrayOfIndications] count]-1] byExtendingSelection:NO];
    [self displayIndicationInfoForRow:[(NSMutableArray *)[self.myGuidelineDocument.dictionaryGuideline objectForKey:kKey_GuidelineArrayOfIndications] count]-1];
    [self saveGuideline];
}

-(void)deleteSelectedIndication
{
    NSInteger row = [self.tableViewIndications selectedRow];
    if (row >=0 && row<[(NSMutableArray *)[self.myGuidelineDocument.dictionaryGuideline objectForKey:kKey_GuidelineArrayOfIndications]count])
    {
        self.embeddedIndicationEditViewController.view.hidden = YES;
        [(NSMutableArray *)[self.myGuidelineDocument.dictionaryGuideline objectForKey:kKey_GuidelineArrayOfIndications] removeObjectAtIndex:row];
        [self reloadTableViewSavingSelection:NO];
        [self saveGuideline];
        [self displayFirstIndication];
    }
}

-(void)displayFirstIndication
{
    if ([(NSMutableArray *)[self.myGuidelineDocument.dictionaryGuideline objectForKey:kKey_GuidelineArrayOfIndications] count] > 0) {
        [self.tableViewIndications selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        [self displayIndicationInfoForRow:0];
    }

}

#pragma mark - TableView DataSource & Delegate

-(void)reloadTableViewSavingSelection:(BOOL)saveSelection
{
    NSInteger row = [self.tableViewIndications selectedRow];
    [self.tableViewIndications reloadData];
    [self.segmentAddRemoveIndication setEnabled:NO forSegment:1];
    if (saveSelection &&  row>=0) {
        [self.tableViewIndications selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
        [self.segmentAddRemoveIndication setEnabled:YES forSegment:1];
    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    NSInteger count=0;
    if ((NSMutableArray *)[self.myGuidelineDocument.dictionaryGuideline objectForKey:kKey_GuidelineArrayOfIndications] != nil)
        count=[(NSMutableArray *)[self.myGuidelineDocument.dictionaryGuideline objectForKey:kKey_GuidelineArrayOfIndications] count];
    return count;
}


- (NSView *)tableView:(NSTableView *)tableView   viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    // Retrieve to get the @"MyView" from the pool or,
    // if no version is available in the pool, load the Interface Builder version
    NSTableCellView *result = [tableView makeViewWithIdentifier:@"indications" owner:self];
    
    // Set the stringValue of the cell's text field to the nameArray value at row
    NSMutableDictionary *indicationDictAtRow = [(NSMutableArray *)[self.myGuidelineDocument.dictionaryGuideline objectForKey:kKey_GuidelineArrayOfIndications] objectAtIndex:row];
    result.textField.stringValue = [HandyRoutines stringFromStringTakingAccountOfNull: [indicationDictAtRow objectForKey:kKey_IndicationName]];

    // Return the result
    return result;
}

#pragma mark - Segue

- (IBAction)tableViewIndicationsTapped:(NSTableView *)sender
{
    [self displayIndicationInfoForRow:[sender selectedRow]];
}

-(void)displayIndicationInfoForRow:(NSInteger)row
{
    if (row<[(NSMutableArray *)[self.myGuidelineDocument.dictionaryGuideline objectForKey:kKey_GuidelineArrayOfIndications] count]) {
        [self.embeddedIndicationEditViewController alignDisplayWithIndication: [(NSMutableArray *)[self.myGuidelineDocument.dictionaryGuideline objectForKey:kKey_GuidelineArrayOfIndications] objectAtIndex:row]];
        self.embeddedIndicationEditViewController.view.hidden = NO;
        [self reloadTableViewSavingSelection:YES];
    }
}

-(void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedIndicationVC"])
    {
        //comes first before we get a document
        self.embeddedIndicationEditViewController = (IndicationViewController *)segue.destinationController;
        self.embeddedIndicationEditViewController.myGuidelineDisplayingViewController = self;
        self.embeddedIndicationEditViewController.view.hidden = YES;
    }

    
}


@end
