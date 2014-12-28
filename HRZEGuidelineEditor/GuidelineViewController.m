//
//  ViewController.m
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 02/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//
#define kPDFA4 1
#define kPDFUSL 2
#define kTXT 3
#define kRTF 4
#define kMargin 72.0f

#import "PrefixHeader.pch"
#import "GuidelineDocument.h"
#import "GuidelineViewController.h"
#import "HandyRoutines.h"
#import "IndicationViewController.h"
#import "PDFguidelineViewController.h"
#import "PDFGuidelineWindowController.h"
#import "GuideLineTextGenerator.h"

#import <CoreText/CoreText.h>


@implementation GuidelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.allowUpdatesFromView = YES;
}

-(void)viewWillAppear
{
    [super viewWillAppear];
    self.myGuidelineDocument = [[[self.view window] windowController] document];
    self.myGuidelineDocument.myGuidelineDisplayingViewController = self;
    if ((NSMutableArray *)[self.myGuidelineDocument.guideline objectForKey:kKey_GuidelineArrayOfIndications] == nil)
    {
       [self.myGuidelineDocument.guideline setObject:[NSMutableArray array] forKey:kKey_GuidelineArrayOfIndications] ;
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
    self.allowUpdatesFromView = NO;
    [[self.textViewGuidelineDescription textStorage] setAttributedString:[HandyRoutines attributedStringFromDescriptionData:[self.myGuidelineDocument.guideline objectForKey:kKey_GuidelineDescription]]];
    [self reloadTableViewSavingSelection:YES];
    [self displayIndicationInfoForRow:0];
    self.allowUpdatesFromView = YES;

}

-(void)alignGuidelineWithView
{
    if (self.allowUpdatesFromView)
    {
        self.allowUpdatesFromView = NO;
        [self.myGuidelineDocument.guideline setObject:[HandyRoutines dataForDescriptionAttributedString:self.textViewGuidelineDescription.attributedString] forKey:kKey_GuidelineDescription];
        [self saveGuideline];
        self.allowUpdatesFromView = YES;
        
    }
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
    [self.embeddedIndicationEditViewController alignIndicationWithViewAsSelectionIsChanging];
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
    [(NSMutableArray *)[self.myGuidelineDocument.guideline objectForKey:kKey_GuidelineArrayOfIndications] addObject:indication];
    [self reloadTableViewSavingSelection:NO];
    [self.tableViewIndications selectRowIndexes:[NSIndexSet indexSetWithIndex:[(NSMutableArray *)[self.myGuidelineDocument.guideline objectForKey:kKey_GuidelineArrayOfIndications] count]-1] byExtendingSelection:NO];
    [self displayIndicationInfoForRow:[(NSMutableArray *)[self.myGuidelineDocument.guideline objectForKey:kKey_GuidelineArrayOfIndications] count]-1];
    [self saveGuideline];
}

-(void)deleteSelectedIndication
{
    NSInteger row = [self.tableViewIndications selectedRow];
    if (row >=0 && row<[(NSMutableArray *)[self.myGuidelineDocument.guideline objectForKey:kKey_GuidelineArrayOfIndications]count])
    {
        NSString *nameOfIndication = [HandyRoutines stringFromStringTakingAccountOfNull: [[(NSMutableArray *)[self.myGuidelineDocument.guideline objectForKey:kKey_GuidelineArrayOfIndications] objectAtIndex:row] objectForKey:kKey_IndicationName]];

        NSAlert *alert = [[NSAlert alloc] init];
        [alert setAlertStyle:NSCriticalAlertStyle];
        [alert setMessageText:[NSString stringWithFormat:@"Are you sure you want to delete '%@'?\nThis cannot be undone.",nameOfIndication]];
        [alert addButtonWithTitle:@"Delete"];
        [alert addButtonWithTitle:@"Cancel"];
        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
            if (returnCode == NSAlertFirstButtonReturn)
            {
                self.embeddedIndicationEditViewController.view.hidden = YES;
                [(NSMutableArray *)[self.myGuidelineDocument.guideline objectForKey:kKey_GuidelineArrayOfIndications] removeObjectAtIndex:row];
                [self reloadTableViewSavingSelection:NO];
                [self saveGuideline];
                [self displayIndicationInfoForRow:0];
            };
        }];

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
    if ((NSMutableArray *)[self.myGuidelineDocument.guideline objectForKey:kKey_GuidelineArrayOfIndications] != nil)
        count=[(NSMutableArray *)[self.myGuidelineDocument.guideline objectForKey:kKey_GuidelineArrayOfIndications] count];
    return count;
}


- (NSView *)tableView:(NSTableView *)tableView   viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    // Retrieve to get the @"MyView" from the pool or,
    // if no version is available in the pool, load the Interface Builder version
    NSTableCellView *result = [tableView makeViewWithIdentifier:@"indications" owner:self];
    
    // Set the stringValue of the cell's text field to the nameArray value at row
    NSMutableDictionary *indicationDictAtRow = [(NSMutableArray *)[self.myGuidelineDocument.guideline objectForKey:kKey_GuidelineArrayOfIndications] objectAtIndex:row];
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
    if ([(NSMutableArray *)[self.myGuidelineDocument.guideline objectForKey:kKey_GuidelineArrayOfIndications] count]>0 &&
        row<[(NSMutableArray *)[self.myGuidelineDocument.guideline objectForKey:kKey_GuidelineArrayOfIndications] count]) {
        [self.embeddedIndicationEditViewController alignDisplayWithIndication: [(NSMutableArray *)[self.myGuidelineDocument.guideline objectForKey:kKey_GuidelineArrayOfIndications] objectAtIndex:row]];
        self.embeddedIndicationEditViewController.view.hidden = NO;
        [self reloadTableViewSavingSelection:YES];
    }
    else
    {
        [self reloadTableViewSavingSelection:NO];
        self.embeddedIndicationEditViewController.view.hidden = YES;
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
    else if ([segue.identifier isEqualToString:@"showPDFwindow"])
    {
        PDFGuidelineWindowController* thePDFGuidelineWindowController = (PDFGuidelineWindowController *)[segue destinationController];
        thePDFGuidelineWindowController.callingGuidelineViewController = self;
        [thePDFGuidelineWindowController setPDFdocumentWithPDFData:[self createPDFData:CGSizeMake(842.0f,1190.0f)]];
        [[thePDFGuidelineWindowController window] setTitle:[self.view.window.title stringByDeletingPathExtension]];
    }
    /*else if ([segue.identifier isEqualToString:@"showPDF"])
    {
        PDFguidelineViewController* thePDFguidelineViewController = (PDFguidelineViewController *)[segue destinationController];
        thePDFguidelineViewController.callingGuidelineViewController = self;
    }*/
    
}





#pragma mark - PDF

-(NSMutableAttributedString *)createDescriptionFromGuideline
{
    GuideLineTextGenerator *texter = [[GuideLineTextGenerator alloc] init];
    return [texter textForGuideline:self.myGuidelineDocument.guideline withName:self.view.window.title];
}


-(NSURL *)createPDFFile:(CGSize)pageSize// 1
{
    NSAttributedString *astring;// = [self createDescriptionFromGuideline];
    
    CGRect pageRect = CGRectMake(0, 0, pageSize.width, pageSize.height);
    NSURL *nurl = nil;
    NSError *ferror = nil;
    NSString *path = [[HandyRoutines pathToDocsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@ description.pdf",self.view.window.title]];
    if ([[NSFileManager defaultManager]fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager]removeItemAtPath:path error:&ferror];
    }
    nurl = [NSURL fileURLWithPath:path];
    
    CGContextRef pdfContext;
    //CFStringRef path;
    CFURLRef url = (__bridge CFURLRef)(nurl);
    CFDataRef boxData = NULL;
    CFMutableDictionaryRef myDictionary = NULL;
    CFMutableDictionaryRef pageDictionary = NULL;
    
    
    myDictionary = CFDictionaryCreateMutable(NULL, 0,
                                             &kCFTypeDictionaryKeyCallBacks,
                                             &kCFTypeDictionaryValueCallBacks); // 4
    CFDictionarySetValue(myDictionary, kCGPDFContextTitle, CFSTR("Guideline PDF File"));
    CFDictionarySetValue(myDictionary, kCGPDFContextCreator, CFSTR("HRZE Editor"));
    pdfContext = CGPDFContextCreateWithURL (url, &pageRect, myDictionary); // 5
    CFRelease(myDictionary);
    pageDictionary = CFDictionaryCreateMutable(NULL, 0,
                                               &kCFTypeDictionaryKeyCallBacks,
                                               &kCFTypeDictionaryValueCallBacks); // 6
    boxData = CFDataCreate(NULL,(const UInt8 *)&pageRect, sizeof (CGRect));
    CFDictionarySetValue(pageDictionary, kCGPDFContextMediaBox, boxData);
    
    if (astring.length>0)
    {
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)(astring));
        if (framesetter)
        {
            CFRange currentRange = CFRangeMake(0, 0);
            NSInteger currentPage = 0;
            BOOL done = NO;
            astring = [self createDescriptionFromGuideline];
            do {
                // Mark the beginning of a new page.
                CGPDFContextBeginPage (pdfContext, pageDictionary);
                
                // Draw a page number at the bottom of each page.
                currentPage++;
                [self drawPageNumber:currentPage pageSize:pageSize];
                
                // Render the current page and update the current range to
                // point to the beginning of the next page.
                currentRange = [self renderPage:currentPage withTextRange:currentRange andFramesetter:framesetter pageSize:pageSize pdfContext:pdfContext];
                
                // If we're at the end of the text, exit the loop.
                if (currentRange.location == CFAttributedStringGetLength((CFAttributedStringRef)astring))
                    done = YES;
                CGPDFContextEndPage (pdfContext);
                
            } while (!done);
            
            
            // Release the framewetter.
            CFRelease(framesetter);
            
        } else {
            NSLog(@"Could not create the framesetter needed to lay out the atrributed string.");
        }
    }
    CGContextRelease (pdfContext);// 10
    CFRelease(pageDictionary); // 11
    CFRelease(boxData);
    
    return nurl;
}

-(NSData *)createPDFData:(CGSize)pageSize// 1
{
    NSAttributedString *astring = [self createDescriptionFromGuideline];
    
    CGRect pageRect = CGRectMake(0, 0, pageSize.width, pageSize.height);
    
    CGContextRef pdfContext;
    //CFStringRef path;
    CFDataRef boxData = NULL;
    CFMutableDictionaryRef myDictionary = NULL;
    CFMutableDictionaryRef pageDictionary = NULL;
    
    
    myDictionary = CFDictionaryCreateMutable(NULL, 0,
                                             &kCFTypeDictionaryKeyCallBacks,
                                             &kCFTypeDictionaryValueCallBacks); // 4
    CFDictionarySetValue(myDictionary, kCGPDFContextTitle, CFSTR("Guideline PDF File"));
    CFDictionarySetValue(myDictionary, kCGPDFContextCreator, CFSTR("HRZE Editor"));
    
    CFAllocatorRef allocator = NULL;
    CFMutableDataRef data = NULL;
    data = CFDataCreateMutable(allocator, 0);
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData(data);
    pdfContext = CGPDFContextCreate(consumer, &pageRect, myDictionary);
    CFRelease(myDictionary);
    
    pageDictionary = CFDictionaryCreateMutable(NULL, 0,
                                               &kCFTypeDictionaryKeyCallBacks,
                                               &kCFTypeDictionaryValueCallBacks); // 6
    boxData = CFDataCreate(NULL,(const UInt8 *)&pageRect, sizeof (CGRect));
    CFDictionarySetValue(pageDictionary, kCGPDFContextMediaBox, boxData);
    
    if (astring.length>0)
    {
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)(astring));
        if (framesetter)
        {
            CFRange currentRange = CFRangeMake(0, 0);
            NSInteger currentPage = 0;
            BOOL done = NO;
            
            do {
                // Mark the beginning of a new page.
                CGPDFContextBeginPage (pdfContext, pageDictionary);
                
                // Draw a page number at the bottom of each page.
                currentPage++;
                [self drawPageNumber:currentPage pageSize:pageSize];
                
                // Render the current page and update the current range to
                // point to the beginning of the next page.
                currentRange = [self renderPage:currentPage withTextRange:currentRange andFramesetter:framesetter pageSize:pageSize pdfContext:pdfContext];
                
                // If we're at the end of the text, exit the loop.
                if (currentRange.location == CFAttributedStringGetLength((CFAttributedStringRef)astring))
                    done = YES;
                CGPDFContextEndPage (pdfContext);
                
            } while (!done);
            
            
            // Release the framewetter.
            CFRelease(framesetter);
            
        } else {
            NSLog(@"Could not create the framesetter needed to lay out the atrributed string.");
        }
    }
    CGContextRelease (pdfContext);// 10
    CFRelease(pageDictionary); // 11
    CFRelease(boxData);
    CGDataConsumerRelease(consumer);
    NSData *ndata = [NSData dataWithData:(__bridge NSData *)(data)];
    CFRelease(data);
    return ndata;
}


// Use Core Text to draw the text in a frame on the page.
- (CFRange)renderPage:(NSInteger)pageNum withTextRange:(CFRange)currentRange
       andFramesetter:(CTFramesetterRef)framesetter pageSize:(CGSize)pageSize pdfContext:(CGContextRef) currentContext
{
    // Get the graphics context.
    //CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Create a path object to enclose the text. Use 72 point
    // margins all around the text.
    CGRect    frameRect = CGRectMake(kMargin, kMargin, pageSize.width-(kMargin*2), pageSize.height-(kMargin*2));
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    // The currentRange variable specifies only the starting point. The framesetter
    // lays out as much text as will fit into the frame.
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    //DONT DO THIS
    //CGContextTranslateCTM(currentContext, 0, pageSize.height);
    //CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    // Update the current range based on what was drawn.
    currentRange = CTFrameGetVisibleStringRange(frameRef);
    currentRange.location += currentRange.length;
    currentRange.length = 0;
    CFRelease(frameRef);
    
    return currentRange;
}

- (void)drawPageNumber:(NSInteger)pageNum pageSize:(CGSize)pageSize
{
    NSString *pageString = [NSString stringWithFormat:@"- %ld -", (long)pageNum];
    NSFont *theFont = [NSFont systemFontOfSize:12];
    CGSize maxSize = CGSizeMake(pageSize.width, kMargin);
    CGSize pageStringSize = [pageString boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:theFont forKey:NSFontAttributeName]].size;
    
    CGRect stringRect = CGRectMake(((pageSize.width - pageStringSize.width) / 2.0),
                                   (pageSize.height-kMargin) + ((kMargin - pageStringSize.height) / 2.0),
                                   pageStringSize.width,
                                   pageStringSize.height);
    
    [pageString drawInRect:stringRect withAttributes:[NSDictionary dictionaryWithObject:theFont forKey:NSFontAttributeName]];
}

/*
 Letter		 612x792
 LetterSmall	 612x792
 Tabloid		 792x1224
 Ledger		1224x792
 Legal		 612x1008
 Statement	 396x612
 Executive	 540x720
 A0               2384x3371
 A1              1685x2384
 A2		1190x1684
 A3		 842x1190
 A4		 595x842
 A4Small		 595x842
 A5		 420x595
 B4		 729x1032
 B5		 516x729
 Envelope	 ???x???
 Folio		 612x936
 Quarto		 610x780
 10x14		 720x1008
 */


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
