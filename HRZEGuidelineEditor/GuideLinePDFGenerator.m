//
//  GuideLineTextGenerator.m
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 28/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//
#define kPDFA4 1
#define kPDFUSL 2
#define kTXT 3
#define kRTF 4
#define kMargin 72.0f

#import "GuideLinePDFGenerator.h"
#import "HandyRoutines.h"
#import "PrefixHeader.pch"





@implementation GuideLinePDFGenerator

-(id)initWithGuideline:(NSMutableDictionary *)guideline withName:(NSString *)guidelineName
{
    self = [self init];
    if (self) {
        // Initialize self.
        self.guideline = guideline;
        self.guidelineName = guidelineName;
    }
    return self;
}

#pragma Mark - Generic
-(NSAttributedString *)astringForPlainText:(NSString *)name
{
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setHeadIndent:40.0f];
    [ps setFirstLineHeadIndent:40.0f];
    NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys: [NSFont systemFontOfSize:12.0f], NSFontAttributeName, ps, NSParagraphStyleAttributeName, nil];
    NSAttributedString *astring = [[NSAttributedString alloc] initWithString:name attributes:attribs];
    return astring;
}

-(NSAttributedString *)astringForPlainTextExtraIndent:(NSString *)name
{
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setHeadIndent:50.0f];
    [ps setFirstLineHeadIndent:50.0f];
    NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys: [NSFont systemFontOfSize:12.0f], NSFontAttributeName, ps, NSParagraphStyleAttributeName, nil];
    NSAttributedString *astring = [[NSAttributedString alloc] initWithString:name attributes:attribs];
    return astring;
}

-(NSAttributedString *)astringForSmallPlainText:(NSString *)name
{
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setHeadIndent:40.0f];
    [ps setFirstLineHeadIndent:40.0f];
    NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys: [NSFont systemFontOfSize:10.0f], NSFontAttributeName, ps, NSParagraphStyleAttributeName, nil];
    NSAttributedString *astring = [[NSAttributedString alloc] initWithString:name attributes:attribs];
    return astring;
}


#pragma Mark - Guideline


-(void)addAllStringsForGuideline:(NSMutableArray *)arrayOfDescriptionLines
{
    [self addStringForGuidelineName:arrayOfDescriptionLines];
    [self addStringForGuidelineDescription:arrayOfDescriptionLines];
}

-(void)addStringForGuidelineName:(NSMutableArray *)arrayOfDescriptionLines
{
    if (self.guidelineName.length>0)
    {
        NSString *name = [NSString stringWithFormat:@"\n%@\n",self.guidelineName];
        NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSFont boldSystemFontOfSize:14.0f], NSFontAttributeName,
                                 nil];
        [arrayOfDescriptionLines addObject:[[NSAttributedString alloc] initWithString:name attributes:attribs]];
        
    }
}
-(void)addStringForGuidelineDescription:(NSMutableArray *)stringsArray
{
    if ([[[HandyRoutines attributedStringFromDescriptionData:[self.guideline objectForKey:kKey_GuidelineDescription]] string] length]>0) {
        NSMutableAttributedString *desc = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        [desc appendAttributedString:[HandyRoutines attributedStringFromDescriptionData:[self.guideline objectForKey:kKey_GuidelineDescription]]];
        [desc appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
        [stringsArray addObject:desc];
    }
}

#pragma Mark - Indication
-(void)addAllStringsForIndication:(NSMutableDictionary *)indication arrayOfDescriptionLines:(NSMutableArray *)arrayOfDescriptionLines
{
    [self addStringForIndicationName:indication arrayOfDescriptionLines:arrayOfDescriptionLines];
    [self addStringForIndicationDosingInstructions:indication arrayOfDescriptionLines:arrayOfDescriptionLines];
    [self addStringForIndicationComments:indication arrayOfDescriptionLines:arrayOfDescriptionLines];
}

-(void)addStringForIndicationName:(NSMutableDictionary *)indication arrayOfDescriptionLines:(NSMutableArray *)arrayOfDescriptionLines
{
    if ([[indication objectForKey:kKey_IndicationName] length]>0)
    {
        NSString *name = [NSString stringWithFormat:@"\n%@\n",[HandyRoutines stringFromStringTakingAccountOfNull:[indication objectForKey:kKey_IndicationName]]];
        NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSFont boldSystemFontOfSize:14.0f], NSFontAttributeName,
                                 [[HandyRoutines colourForHeaderInIndication:indication]CGColor], kCTForegroundColorAttributeName,
                                 nil];
        NSAttributedString *astring = [[NSAttributedString alloc] initWithString:name attributes:attribs];
        [arrayOfDescriptionLines addObject:astring];
    }
}

-(void)addStringForIndicationDosingInstructions:(NSMutableDictionary *)indication arrayOfDescriptionLines:(NSMutableArray *)arrayOfDescriptionLines
{
    if ([[indication objectForKey:kKey_IndicationDosingInstructions] length]>0)
    {
        NSString *name = [NSString stringWithFormat:@"%@\n",[HandyRoutines stringFromStringTakingAccountOfNull:[indication objectForKey:kKey_IndicationDosingInstructions]]];
        NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSFont systemFontOfSize:12.0f], NSFontAttributeName,
                                 nil];
        NSAttributedString *astring = [[NSAttributedString alloc] initWithString:name attributes:attribs];
        [arrayOfDescriptionLines addObject:astring];
    }
}

-(void)addStringForIndicationComments:(NSMutableDictionary *)indication arrayOfDescriptionLines:(NSMutableArray *)arrayOfDescriptionLines
{
    if ([[indication objectForKey:kKey_IndicationComments] length]>0)
    {
        NSString *initiHidden = @"(Comments initially hidden)";
        if ([[indication objectForKey:kKey_Indication_HideComments] boolValue] == NO) {
            initiHidden = @"(Comments initially shown)";
        }
        NSString *name = [NSString stringWithFormat:@"%@\n%@\n",[HandyRoutines stringFromStringTakingAccountOfNull:[indication objectForKey:kKey_IndicationComments]],initiHidden];
        NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSFont systemFontOfSize:10.0f], NSFontAttributeName,
                                 nil];
        NSAttributedString *astring = [[NSAttributedString alloc] initWithString:name attributes:attribs];
        [arrayOfDescriptionLines addObject:astring];
    }
}

#pragma Mark - Drug
-(void)addAllStringsForDrug:(NSMutableDictionary *)drug arrayOfDescriptionLines:(NSMutableArray *)arrayOfDescriptionLines
{
    [self addStringForDrugName:drug arrayOfDescriptionLines:arrayOfDescriptionLines];

}

-(void)addStringForDrugName:(NSMutableDictionary *)drug arrayOfDescriptionLines:(NSMutableArray *)arrayOfDescriptionLines
{
    if ([[drug objectForKey:kKey_DrugDisplayName] length]>0)
    {
        NSString *name = [NSString stringWithFormat:@"\n%@\n",[HandyRoutines stringFromStringTakingAccountOfNull:[drug objectForKey:kKey_DrugDisplayName]]];
        NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
        [ps setHeadIndent:20.0f];
        [ps setFirstLineHeadIndent:20.0f];
        NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys: [NSFont boldSystemFontOfSize:12.0f], NSFontAttributeName, ps, NSParagraphStyleAttributeName, nil];
        NSAttributedString *astring = [[NSAttributedString alloc] initWithString:name attributes:attribs];
        [arrayOfDescriptionLines addObject:astring];
    }
}

-(void)addStringForCalculationOfDrug:(NSMutableDictionary *)drug arrayOfDescriptionLines:(NSMutableArray *)arrayOfDescriptionLines
{
    switch ([[drug objectForKey:kKey_DoseCalculationType] integerValue]) {
        case kDoseCalculationBy_MgKg:
            [self addStringForDrug_MgKgdose:drug arrayOfDescriptionLines:arrayOfDescriptionLines];
            break;
        case kDoseCalculationBy_MgKg_Adjustable:
            [self addStringForDrug_MgKgdoseAdjustable:drug arrayOfDescriptionLines:arrayOfDescriptionLines];
            break;
        case kDoseCalculationBy_Threshold:
            [self addStringForDrug_Thresholds:drug arrayOfDescriptionLines:arrayOfDescriptionLines];
            break;
        case kDoseCalculationBy_SingleDose:
            [self addStringForDrug_DescriptiveDose:drug arrayOfDescriptionLines:arrayOfDescriptionLines];
            break;
    }
}

-(void)addStringForDrug_DescriptiveDose:(NSMutableDictionary *)drug arrayOfDescriptionLines:(NSMutableArray *)arrayOfDescriptionLines
{
    [arrayOfDescriptionLines addObject:[self astringForPlainText:[NSString stringWithFormat:@"%@\n",[drug objectForKey:kKey_SingleDoseInstructions]]]];
}

-(void)addStringForDrug_Thresholds:(NSMutableDictionary *)drug arrayOfDescriptionLines:(NSMutableArray *)arrayOfDescriptionLines
{
    [arrayOfDescriptionLines addObject:[self astringForPlainText:[NSString stringWithFormat:@"Minimum allowed body weight is: %li Kg\n",(long)[[drug objectForKey:kKey_Threshold_MinWeight] integerValue]]]];
    
    NSArray *thresholdsArray = (NSArray *)[drug objectForKey:kKey_Threshold_Array_Thresholds];
    if (thresholdsArray.count<1)
    {
        [arrayOfDescriptionLines addObject:[self astringForPlainText:[NSString stringWithFormat:@"No thresholds have been defined.\n"]]];
    }
    else
    {
        for (int i = 0; i<[thresholdsArray count]; i++)
        {
            NSMutableDictionary *threshold = [thresholdsArray objectAtIndex:i];
            NSString *str = [NSString stringWithFormat:@"If body weight %@ %@ Kg: give %@ %@\n",
                             [HandyRoutines predecateStringForPredicate:[threshold objectForKey:kKey_Threshold_Booleans]],
                             [threshold objectForKey:kKey_Threshold_Weights],
                             [threshold objectForKey:kKey_Threshold_doses],
                             [threshold objectForKey:kKey_Threshold_DoseForms]];
            [arrayOfDescriptionLines addObject:[self astringForPlainText:str]];
        }
    }
}

-(void)addStringForDrug_MgKgDoseMaximumAndRounding:(NSMutableDictionary *)drug arrayOfDescriptionLines:(NSMutableArray *)arrayOfDescriptionLines
{
    [arrayOfDescriptionLines addObject:[self astringForPlainText:[NSString stringWithFormat:@"Maximum recommended dose: %li %@\n",(long)[[drug objectForKey:kKey_MaxDose] integerValue],[drug objectForKey:kKey_DoseUnits]]]];
    
    [arrayOfDescriptionLines addObject:[self astringForPlainText:[NSString stringWithFormat:@"Round %@ to nearest %ld %@\n",[HandyRoutines roundingStringFromRoundUpDownValue:[drug objectForKey:kKey_RoundingUpDown]],(long)[[drug objectForKey:kKey_ValueOfRounding] integerValue],[drug objectForKey:kKey_DoseUnits]]]];
}

-(void)addStringForDrug_MgKgdose:(NSMutableDictionary *)drug arrayOfDescriptionLines:(NSMutableArray *)arrayOfDescriptionLines
{
    [arrayOfDescriptionLines addObject:[self astringForPlainText:[NSString stringWithFormat:@"Dose @ %li %@/Kg\nDoes not allow adjustment of dose factor.\n",(long)[[drug objectForKey:kKey_DosageMgKg] integerValue],[drug objectForKey:kKey_DoseUnits]]]];
    [self addStringForDrug_MgKgDoseMaximumAndRounding:drug arrayOfDescriptionLines:arrayOfDescriptionLines];
}

-(void)addStringForDrug_MgKgdoseAdjustable:(NSMutableDictionary *)drug arrayOfDescriptionLines:(NSMutableArray *)arrayOfDescriptionLines
{
    [arrayOfDescriptionLines addObject:[self astringForPlainText:[NSString stringWithFormat:@"Dose @ %li %@/Kg\nAllows adjustment of dose factor within range:\n",(long)[[drug objectForKey:kKey_DosageMgKg] integerValue],[drug objectForKey:kKey_DoseUnits]]]];
    [arrayOfDescriptionLines addObject:[self astringForPlainTextExtraIndent:[NSString stringWithFormat:@"Maximum: %li %@/Kg\n",(long)[[drug objectForKey:kKey_DosageMgKgMaximum] integerValue],[drug objectForKey:kKey_DoseUnits]]]];
    [arrayOfDescriptionLines addObject:[self astringForPlainTextExtraIndent:[NSString stringWithFormat:@"Minimum: %li %@/Kg\n",(long)[[drug objectForKey:kKey_DosageMgKgMinimum] integerValue],[drug objectForKey:kKey_DoseUnits]]]];
    [self addStringForDrug_MgKgDoseMaximumAndRounding:drug arrayOfDescriptionLines:arrayOfDescriptionLines];
}

-(NSAttributedString *)astringForDrugName:(NSString *)name
{
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setHeadIndent:20.0f];
    [ps setFirstLineHeadIndent:20.0f];
    NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys: [NSFont boldSystemFontOfSize:12.0f], NSFontAttributeName, ps, NSParagraphStyleAttributeName, nil];
    NSAttributedString *astring = [[NSAttributedString alloc] initWithString:name attributes:attribs];
    return astring;
}

#pragma Mark - Creation

-(NSMutableAttributedString *)createDescriptionFromGuideline
{
    NSMutableArray *arrayOfDescriptionLines = [NSMutableArray array];
    if (self.guideline != nil)
    {
        [self addAllStringsForGuideline:arrayOfDescriptionLines];
        
        NSMutableArray *indications = (NSMutableArray *)[self.guideline objectForKey:kKey_GuidelineArrayOfIndications];
        for (NSMutableDictionary *indication in indications)
        {
            [self addAllStringsForIndication:indication arrayOfDescriptionLines:arrayOfDescriptionLines];
            
            for (NSMutableDictionary *drug in [indication objectForKey:kKey_ArrayOfDrugs]) {
                [self addAllStringsForDrug:drug arrayOfDescriptionLines:arrayOfDescriptionLines];
                [self addStringForCalculationOfDrug:drug arrayOfDescriptionLines:arrayOfDescriptionLines];

            }
        }
    }
    
    NSMutableAttributedString *desc = [[NSMutableAttributedString alloc] initWithString:@""];
    for (NSAttributedString *as in arrayOfDescriptionLines) {
        [desc appendAttributedString:as];
    }
    return desc;
}


#pragma mark - PDF

-(void)createPDFAtURL:(NSURL *)url withSize:(CGSize)pageSize// 1
{
    NSData *data = [self createPDFData:pageSize];
    NSError *error = nil;
    [data writeToURL:url options:NSDataWritingAtomic error:&error];
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
