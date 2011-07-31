//
//  QLabCurrentCue.h
//  QLabCurrentCue
//
//  Created by Gabe Rives-Corbett on 7/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



@interface QLabCurrentCue : NSObject
{
    NSMenu* cc_newMenu;
    NSWindow* cc_newWindow;
    NSTextField* cc_textField;
    SEL cc_goAction;
    id cc_goTarget;
    id cc_qListView;
}

+ (QLabCurrentCue*)sharedInstance;
@end
