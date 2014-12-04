//
//  ViewController.m
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 02/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import "PrefixHeader.pch"
#import "GuidelineDocument.h"
#import "GuidelineDisplayingViewController.h"
#import "HandyRoutines.h"
#import "IndicationEditViewController.h"


@implementation GuidelineDisplayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.arrayIndicationsInGuideline = [NSMutableArray array];
}

-(void)viewWillAppear
{
    [super viewWillAppear];
    self.myGuidelineDocument = [[[self.view window] windowController] document];
    self.myGuidelineDocument.myGuidelineDisplayingViewController = self;
    [self updateViewWithDocument];
}

-(void)viewWillDisappear
{
    [super viewWillDisappear];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

-(void)updateViewWithDocument
{
    //comed after the embed segue

    [[self.textViewGuidelineDescription textStorage] setAttributedString:[HandyRoutines attributedStringFromDescriptionData:[self.myGuidelineDocument.dictionaryGuideline objectForKey:kKey_GuidelineDescription]]];
    self.arrayIndicationsInGuideline = (NSMutableArray *)[self.myGuidelineDocument.dictionaryGuideline objectForKey:kKey_GuidelineArrayOfIndications];
    if (self.arrayIndicationsInGuideline == nil)
    {
        self.arrayIndicationsInGuideline = [NSMutableArray array];
    }
    if (self.arrayIndicationsInGuideline.count>0)
    {
        
    }
    [self reloadTableViewSavingSelection:YES];
    [self displayFirstIndication];
}

-(void)updateDocumentFromView
{
    [self.myGuidelineDocument.dictionaryGuideline setObject:[HandyRoutines dataForDescriptionAttributedString:self.textViewGuidelineDescription.attributedString] forKey:kKey_GuidelineDescription];
    [self.myGuidelineDocument.dictionaryGuideline setObject:self.arrayIndicationsInGuideline forKey:kKey_GuidelineArrayOfIndications];
    
}

-(void)resignAllFirstresponders
{
    [self.textViewGuidelineDescription resignFirstResponder];

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
    [self updateDocumentFromView];
    NSMutableDictionary *indication = [HandyRoutines newEmptyIndicationWithName:name];
    [self.arrayIndicationsInGuideline addObject:indication];
    [self reloadTableViewSavingSelection:NO];
    [self.tableViewIndications selectRowIndexes:[NSIndexSet indexSetWithIndex:self.arrayIndicationsInGuideline.count-1] byExtendingSelection:NO];
    [self displayIndicationInfoForRow:self.arrayIndicationsInGuideline.count-1];
    [self updateDocumentFromView];
}

-(void)deleteSelectedIndication
{
    [self updateDocumentFromView];
    NSInteger row = [self.tableViewIndications selectedRow];
    if (row >=0 && row<self.arrayIndicationsInGuideline.count)
    {
        self.embeddedIndicationEditViewController.view.hidden = YES;
        [self.arrayIndicationsInGuideline removeObjectAtIndex:row];
        [self reloadTableViewSavingSelection:NO];
        [self updateDocumentFromView];
        [self displayFirstIndication];
    }
}

-(void)displayFirstIndication
{
    if (self.arrayIndicationsInGuideline.count > 0) {
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
    if (self.arrayIndicationsInGuideline)
        count=[self.arrayIndicationsInGuideline count];
    return count;
}


- (NSView *)tableView:(NSTableView *)tableView   viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    // Retrieve to get the @"MyView" from the pool or,
    // if no version is available in the pool, load the Interface Builder version
    NSTableCellView *result = [tableView makeViewWithIdentifier:@"indications" owner:self];
    
    // Set the stringValue of the cell's text field to the nameArray value at row
    NSMutableDictionary *indicationDictAtRow = [self.arrayIndicationsInGuideline objectAtIndex:row];
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
    if (row<self.arrayIndicationsInGuideline.count) {
        [self updateDocumentFromView];
        [self.embeddedIndicationEditViewController updateIndicationDisplayForIndication: [self.arrayIndicationsInGuideline objectAtIndex:row]];
        self.embeddedIndicationEditViewController.view.hidden = NO;
        [self reloadTableViewSavingSelection:YES];
    }
}

-(void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedIndicationVC"])
    {
        //comes first before we get a document
        self.embeddedIndicationEditViewController = (IndicationEditViewController *)segue.destinationController;
        self.embeddedIndicationEditViewController.myGuidelineDisplayingViewController = self;
        self.embeddedIndicationEditViewController.view.hidden = YES;
    }

    
}


@end
