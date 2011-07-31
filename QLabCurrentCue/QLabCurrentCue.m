//
//  QLabCurrentCue.m
//  QLabCurrentCue
//
//  Created by Gabe Rives-Corbett on 7/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QLabCurrentCue.h"

@implementation QLabCurrentCue

- (NSButton*)findGOButton:(NSView*)root
{
    //awk if this changes
    NSView* splitView = [[root subviews] objectAtIndex:0];
     NSLog(@"QLabCurrentCue::2");
    NSView* splitView2 = [[splitView subviews] objectAtIndex:0];
     NSLog(@"QLabCurrentCue::3");
    NSView* view2 = [[splitView2 subviews] objectAtIndex:0];
     NSLog(@"QLabCurrentCue::4");
    
    return (NSButton*)[[view2 subviews] objectAtIndex:0];
}

- (id)findCueList:(NSView*)root
{
    NSView* splitView = [[root subviews] objectAtIndex:0];
    NSView* view1 = [[splitView subviews] objectAtIndex:1];
    NSView* scrollView = [[view1 subviews] objectAtIndex:2];
    NSView* clipView = [[scrollView subviews] objectAtIndex:0];
    
    return [[clipView subviews] objectAtIndex:0];
}

- (void)goPressed:(id)sender
{
    id selectedCue = [cc_qListView selectedItem];
    NSLog(@"QLabCurrentCue::%@", [selectedCue number]);
    
    [cc_textField setStringValue:[selectedCue number]];
    
    static int i = 0;
    [cc_goTarget performSelector:cc_goAction withObject:sender];
    NSLog(@"QLabCurrentCue::GO PUSHED %d", i++);
}

- (void) showPressed:(id)sender
{
    NSLog(@"QLabCurrentCue::showPressed, searching for GO button");
    NSWindow* frontWindow = [[NSApp orderedWindows] objectAtIndex:0];
    
    NSButton* go = [self findGOButton:[frontWindow contentView]];
    NSLog(@"QLabCurrentCue::found go button %@", [go title]);
    
    cc_qListView = [self findCueList:[frontWindow contentView]];
    
    cc_goAction = [go action];
    cc_goTarget = [go target];
    
    [go setAction:@selector(goPressed:)];
    [go setTarget:self];
    
    cc_newWindow = [[NSWindow alloc] initWithContentRect:NSMakeRect(frontWindow.frame.origin.x, frontWindow.frame.origin.y, 500, 500) 
                                                      styleMask:(NSTitledWindowMask|NSClosableWindowMask|NSResizableWindowMask) 
                                                        backing:NSBackingStoreBuffered 
                                                          defer:NO];
    cc_textField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 500, 500)];
    [cc_textField setStringValue:@"abc"];
    [cc_textField setEditable:NO];
    [cc_textField setFont:[NSFont fontWithName:@"Arial" size:100]];
    
    [cc_newWindow setContentView:cc_textField];
    [cc_textField release];
    
    [cc_newWindow makeKeyAndOrderFront:NSApp];
}

- (id)init
{
    self = [super init];
    if (self) 
    {
        NSMenuItem* mainItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"CurrentCue" action:NULL keyEquivalent:@""];
        
        cc_newMenu = [[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@"CurrentCue"];
        
        NSMenuItem* showButton = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Show" action:@selector(showPressed:) keyEquivalent:@""];
        [showButton setTarget:self];
        [cc_newMenu addItem:showButton];
        [showButton release];
        
        [mainItem setSubmenu:cc_newMenu];
        [cc_newMenu release];
        
        [[NSApp mainMenu] addItem: mainItem];
        [mainItem release];
    }
    
    return self;
}

+ (void)load
{
    [QLabCurrentCue sharedInstance];
}

+ (QLabCurrentCue*)sharedInstance
{
    static QLabCurrentCue* instance = nil;
    
    if (instance == nil)
        instance = [[QLabCurrentCue alloc] init];
    
    return instance;
}

@end
