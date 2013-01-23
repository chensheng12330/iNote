//
//  SHNoteWatchViewController.h
//  iNote
//
//  Created by sherwin.chen on 13-1-17.
//
//

#import <UIKit/UIKit.h>
#import "SHNote.h"

@interface SHNoteWatchViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>

@property (nonatomic,readonly, retain) SHNote   *noteInfo;
@property (nonatomic, retain) NSString *strWebContent;
@property (nonatomic, readwrite, assign, getter = isToolbarHidden) BOOL toolbarHidden;
@property (nonatomic, readwrite, retain) UIColor* toolbarTintColor;
@property (nonatomic, readonly, retain) UIWebView* webView;

-(id)initWithNote:(SHNote*)_note;

// Subclassing
- (BOOL)shouldPresentActionSheet:(UIActionSheet *)actionSheet;
@property (nonatomic, retain) NSURL* actionSheetURL;

@end
