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
}

#pragma mark - BrowserDelegate
- (IBAction)tapper:(NSButton *)sender {
    [self.browserIndications reloadColumn:0];
}

- (NSInteger)browser:(NSBrowser *)sender numberOfRowsInColumn:(NSInteger)column {
    if (column == 0) {
        return self.arrayIndicationsInGuideline.count;
    }
    return 0;
}

- (void)browser:(NSBrowser *)sender willDisplayCell:(NSBrowserCell *)cell atRow:(NSInteger)row column:(NSInteger)column {
    // Lazily setup the cell's properties in this method
    NSMutableDictionary *indicationDictAtRow = [self.arrayIndicationsInGuideline objectAtIndex:row];
    [cell setTitle: [indicationDictAtRow objectForKey:kKey_IndicationName]];
    [cell setLeaf:YES];
}


#pragma mark - Segue
- (IBAction)indicationsBrowserTapped:(NSBrowser *)sender
{
    [self.embeddedIndicationEditViewController updateIndicationDisplayForIndication: [self.arrayIndicationsInGuideline objectAtIndex:[sender selectedRowInColumn:0]]];
    self.embeddedIndicationEditViewController.view.hidden = NO;
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
