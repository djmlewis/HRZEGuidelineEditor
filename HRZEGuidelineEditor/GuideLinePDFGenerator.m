//
//  GuideLineTextGenerator.m
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 28/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

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
    NSMutableParagraphStyle *ps = [self paragraphStyleForLevel:2];
    NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys: [NSFont systemFontOfSize:12.0f], NSFontAttributeName, ps, NSParagraphStyleAttributeName, nil];
    NSAttributedString *astring = [[NSAttributedString alloc] initWithString:name attributes:attribs];
    return astring;
}

-(NSAttributedString *)astringForPlainTextExtraIndent:(NSString *)name
{
    NSMutableParagraphStyle *ps = [self paragraphStyleForLevel:3];
    NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys: [NSFont systemFontOfSize:12.0f], NSFontAttributeName, ps, NSParagraphStyleAttributeName, nil];
    NSAttributedString *astring = [[NSAttributedString alloc] initWithString:name attributes:attribs];
    return astring;
}

-(NSAttributedString *)astringForSmallPlainText:(NSString *)name
{
    NSMutableParagraphStyle *ps = [self paragraphStyleForLevel:2];
    NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys: [NSFont systemFontOfSize:10.0f], NSFontAttributeName, ps, NSParagraphStyleAttributeName, nil];
    NSAttributedString *astring = [[NSAttributedString alloc] initWithString:name attributes:attribs];
    return astring;
}

-(CGFloat)indentForLevel:(NSInteger)level
{
    switch (level) {
        case 0:
            return 0.0f;
            break;
        case 1:
            return 20.0f;
            break;
        case 2:
            return 40.0f;
            break;
        case 3:
            return 50.0f;
            break;
    }
    return 0.0f;
}

-(NSMutableParagraphStyle *)paragraphStyleForLevel:(NSInteger)level
{
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    [ps setHeadIndent:[self indentForLevel:level]];
    [ps setFirstLineHeadIndent:[self indentForLevel:level]];
    return ps;
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
        [arrayOfDescriptionLines addObject:[self astringForPlainText:@"\n"]];
        NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSFont boldSystemFontOfSize:14.0f], NSFontAttributeName,
                                         [HandyRoutines colourForHeaderInIndication:indication], NSForegroundColorAttributeName,
                                         nil];
        NSString *name = [NSString stringWithFormat:@"%@",[HandyRoutines stringFromStringTakingAccountOfNull:[indication objectForKey:kKey_IndicationName]]];
        NSAttributedString *astring = [[NSAttributedString alloc] initWithString:name attributes:attribs];
        [arrayOfDescriptionLines addObject:astring];
        [arrayOfDescriptionLines addObject:[self astringForPlainText:@"\n"]];

        
    }
}

-(void)addStringForIndicationDosingInstructions:(NSMutableDictionary *)indication arrayOfDescriptionLines:(NSMutableArray *)arrayOfDescriptionLines
{
    if ([[indication objectForKey:kKey_IndicationDosingInstructions] length]>0)
    {
        NSString *name = [NSString stringWithFormat:@"%@\n",[HandyRoutines stringFromStringTakingAccountOfNull:[indication objectForKey:kKey_IndicationDosingInstructions]]];
        NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSFont systemFontOfSize:12.0f], NSFontAttributeName,
                                 [HandyRoutines colourForHeaderInIndication:indication], NSForegroundColorAttributeName,
                                 [HandyRoutines colourForPageInIndication:indication], NSBackgroundColorAttributeName,
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
                                 [HandyRoutines colourForHeaderInIndication:indication], NSForegroundColorAttributeName,
                                 [HandyRoutines colourForPageInIndication:indication], NSBackgroundColorAttributeName,
                                 nil];
        NSAttributedString *astring = [[NSAttributedString alloc] initWithString:name attributes:attribs];
        [arrayOfDescriptionLines addObject:astring];
    }
}

#pragma Mark - Drug
-(void)addAllStringsForDrug:(NSMutableDictionary *)drug arrayOfDescriptionLines:(NSMutableArray *)arrayOfDescriptionLines
{
    [self addStringForDrugName:drug arrayOfDescriptionLines:arrayOfDescriptionLines];
    [self addStringForShownInList:drug arrayOfDescriptionLines:arrayOfDescriptionLines];
    [self addStringForCalculationOfDrug:drug arrayOfDescriptionLines:arrayOfDescriptionLines];
    [self addStringForDrugInfo:drug arrayOfDescriptionLines:arrayOfDescriptionLines];

}

-(void)addStringForDrugName:(NSMutableDictionary *)drug arrayOfDescriptionLines:(NSMutableArray *)arrayOfDescriptionLines
{
    if ([[drug objectForKey:kKey_DrugDisplayName] length]>0)
    {
        NSString *name = [NSString stringWithFormat:@"\n%@\n",[HandyRoutines stringFromStringTakingAccountOfNull:[drug objectForKey:kKey_DrugDisplayName]]];
        NSMutableParagraphStyle *ps = [self paragraphStyleForLevel:1];
        NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys: [NSFont boldSystemFontOfSize:12.0f], NSFontAttributeName, ps, NSParagraphStyleAttributeName, nil];
        NSAttributedString *astring = [[NSAttributedString alloc] initWithString:name attributes:attribs];
        [arrayOfDescriptionLines addObject:astring];
    }
}

-(void)addStringForDrugInfo:(NSMutableDictionary *)drug arrayOfDescriptionLines:(NSMutableArray *)arrayOfDescriptionLines
{
    if ([[drug objectForKey:kKey_DrugInfo] length]>0)
    {
        NSString *name = [NSString stringWithFormat:@"\n%@\n",[HandyRoutines stringFromStringTakingAccountOfNull:[drug objectForKey:kKey_DrugInfo]]];
        NSMutableParagraphStyle *ps = [self paragraphStyleForLevel:1];
        NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSFont systemFontOfSize:12.0f], NSFontAttributeName, ps, NSParagraphStyleAttributeName,
                                 [[NSColor darkGrayColor]CGColor], kCTForegroundColorAttributeName,
                                 nil];
        NSAttributedString *astring = [[NSAttributedString alloc] initWithString:name attributes:attribs];
        [arrayOfDescriptionLines addObject:astring];
    }
}

-(void)addStringForShownInList:(NSMutableDictionary *)drug arrayOfDescriptionLines:(NSMutableArray *)arrayOfDescriptionLines
{
    NSString *shownString = @"(Initially shown in list of drugs)\n";
    if ([[drug objectForKey:kKey_DrugShowInList] boolValue] == NO)
    {
        shownString = @"(Not initially shown in list of drugs)\n";
    }
    NSMutableParagraphStyle *ps = [self paragraphStyleForLevel:1];
    NSDictionary *attribs = [NSDictionary dictionaryWithObjectsAndKeys: [NSFont systemFontOfSize:11.0f], NSFontAttributeName, ps, NSParagraphStyleAttributeName, nil];
    NSAttributedString *astring = [[NSAttributedString alloc] initWithString:shownString attributes:attribs];
    [arrayOfDescriptionLines addObject:astring];
    
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
    NSMutableParagraphStyle *ps = [self paragraphStyleForLevel:1];
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

-(void)createPDFAtURL:(NSURL *)url withPrintInfo:(NSPrintInfo *)printInfo// 1
{
    NSData *data = [self createPDFDataUsingLayoutWithPrintInfo:printInfo];
    NSError *error = nil;
    [data writeToURL:url options:NSDataWritingAtomic error:&error];
}

-(NSData *)createPDFDataUsingLayoutWithPrintInfo:(NSPrintInfo *)printInfo
{
    NSAttributedString *astring = [self createDescriptionFromGuideline];
    
    CGRect pageRect = CGRectMake(0, 0, printInfo.paperSize.width, printInfo.paperSize.height);
    CGRect containerRect = CGRectMake(0, 0, printInfo.paperSize.width-printInfo.leftMargin-printInfo.rightMargin, printInfo.paperSize.height-printInfo.topMargin-printInfo.bottomMargin);
    
    CGContextRef pdfContext;
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
        
        //Make the layout
        NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:astring];
        NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
        [textStorage addLayoutManager:layoutManager];
        
        BOOL done = NO;
        do
        {
            NSTextContainer *textContainer = [[NSTextContainer alloc] initWithContainerSize:CGSizeMake(containerRect.size.width, containerRect.size.height)];
            [layoutManager addTextContainer:textContainer];
            NSRange glyphRange = [layoutManager glyphRangeForTextContainer:textContainer];
            if (glyphRange.length == 0)
            {
                [layoutManager removeTextContainerAtIndex:layoutManager.textContainers.count-1];
                done = YES;
            }
            
        }while (done == NO);

        //rnder the pages
        for (int page = 0; page<layoutManager.textContainers.count; page++) {
            CGPDFContextBeginPage (pdfContext, pageDictionary);

            [NSGraphicsContext saveGraphicsState];
            CGContextSetTextMatrix(pdfContext, CGAffineTransformIdentity);
            // Core Text draws from the bottom-left corner up, so flip
            // the current transform prior to drawing.
            CGContextTranslateCTM(pdfContext, 0, pageRect.size.height);
            CGContextScaleCTM(pdfContext, 1.0, -1.0);
            
            NSGraphicsContext* context = [NSGraphicsContext graphicsContextWithCGContext:pdfContext flipped: YES];
            [NSGraphicsContext setCurrentContext: context];
            
            
            // Do Cocoa drawing here.
            NSRange glyphRange = [layoutManager glyphRangeForTextContainer:[layoutManager.textContainers objectAtIndex:page]];

            [layoutManager drawGlyphsForGlyphRange: glyphRange atPoint: CGPointMake(printInfo.leftMargin, printInfo.topMargin)];
            [layoutManager drawBackgroundForGlyphRange: glyphRange atPoint: CGPointMake(printInfo.leftMargin, printInfo.topMargin)];
            
            [NSGraphicsContext restoreGraphicsState];

            CGPDFContextEndPage (pdfContext);
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
