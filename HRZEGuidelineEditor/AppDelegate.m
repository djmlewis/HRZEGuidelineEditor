//
//  AppDelegate.m
//  HRZEGuidelineEditor
//
//  Created by David Lewis on 02/12/2014.
//  Copyright (c) 2014 eu.djml. All rights reserved.
//

#import "AppDelegate.h"
#import "PrefixHeader.pch"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
    return YES;
}

- (IBAction)showGuidelinePDF:(NSMenuItem *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_ShowGuidelinePDF object:self];
}
- (IBAction)saveGuidelinePDF:(NSMenuItem *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_SaveGuidelinePDF object:self];

}

@end
