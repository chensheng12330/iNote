//
//  SHNoteWatchViewController.m
//  iNote
//
//  Created by sherwin.chen on 13-1-17.
//
//


#import "NSLoggerSent.h"
#import "SHNoteWatchViewController.h"

CGRect NIRectContract(CGRect rect, CGFloat dx, CGFloat dy) {
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width - dx, rect.size.height - dy);
}

NSString* NIPathForBundleResource(NSBundle* bundle, NSString* relativePath) {
    NSString* resourcePath = [(nil == bundle ? [NSBundle mainBundle] : bundle) resourcePath];
    return [resourcePath stringByAppendingPathComponent:relativePath];
}

@interface SHNoteWatchViewController()
@property (nonatomic, readwrite, retain) UIWebView* webView;
@property (nonatomic, readwrite, retain) UIToolbar* toolbar;
@property (nonatomic, readwrite, retain) UIActionSheet* actionSheet;

@property (nonatomic, readwrite, retain) UIBarButtonItem* backButton;
@property (nonatomic, readwrite, retain) UIBarButtonItem* forwardButton;
@property (nonatomic, readwrite, retain) UIBarButtonItem* refreshButton;
@property (nonatomic, readwrite, retain) UIBarButtonItem* stopButton;
@property (nonatomic, readwrite, retain) UIBarButtonItem* actionButton;
@property (nonatomic, readwrite, retain) UIBarButtonItem* activityItem;

@property (nonatomic, readwrite, retain) NSURL* loadingURL;

@property (nonatomic, readwrite, retain) NSURLRequest* loadRequest;
@end

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SHNoteWatchViewController

@synthesize webView = _webView;
@synthesize toolbar = _toolbar;
@synthesize actionSheet = _actionSheet;
@synthesize backButton = _backButton;
@synthesize forwardButton = _forwardButton;
@synthesize refreshButton = _refreshButton;
@synthesize stopButton = _stopButton;
@synthesize actionButton = _actionButton;
@synthesize activityItem = _activityItem;
@synthesize actionSheetURL = _actionSheetURL;
@synthesize loadingURL = _loadingURL;
@synthesize loadRequest = _loadRequest;
@synthesize toolbarHidden = _toolbarHidden;
@synthesize toolbarTintColor = _toolbarTintColor;

//add
@synthesize noteInfo      = _noteInfo;
@synthesize strWebContent = _strWebContent;

- (void)dealloc {
    _actionSheet.delegate = nil;
    _webView.delegate     = nil;
    
    [_noteInfo      release];
    [_strWebContent release];
    [super dealloc];
}

#pragma mark - UIViewController
-(id)initWithNote:(SHNote*)_note
{
    if(_note==NULL || [_note retainCount]<1)
    {
        LogMessage(@"Init Error", 1, @"SHNoteWatchViewController->initWithNote: _note is NULL");
        return nil;
    }
    
    self = [super initWithNibName:@"SHNoteWatchViewController" bundle:nil];
    _noteInfo = [_note retain];
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *urlPath = [[NSBundle mainBundle] pathForResource:@"template" ofType:@"html"];
    NSURL *URL = [NSURL fileURLWithPath:urlPath];
    
    if (_noteInfo.strContent==NULL) {
        //load template.html
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
        [_webView loadRequest:request];
        //_webView
    }
    else
    {
        //load note content
        NSString *webContent = [NSString stringWithContentsOfFile:urlPath encoding:NSUTF8StringEncoding error:nil];
        self.strWebContent   = [webContent stringByReplacingOccurrencesOfString:@"@@" withString:_noteInfo.strContent];
        [_webView loadHTMLString:_strWebContent baseURL:URL];
    }
    
    return;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateWebViewFrame {
    if (self.toolbarHidden) {
        self.webView.frame = self.view.bounds;
        
    } else {
        self.webView.frame = NIRectContract(self.view.bounds, 0, self.toolbar.frame.size.height);
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadView {
    [super loadView];
    
    CGRect bounds = self.view.bounds;
    
    CGFloat toolbarHeight = 33;
    CGRect toolbarFrame = CGRectMake(0, bounds.size.height - toolbarHeight,
                                     bounds.size.width, toolbarHeight);
    
    self.toolbar = [[UIToolbar alloc] initWithFrame:toolbarFrame];
    self.toolbar.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin
                                     | UIViewAutoresizingFlexibleWidth);
    self.toolbar.tintColor = self.toolbarTintColor;
    self.toolbar.hidden = self.toolbarHidden;
    
    UIActivityIndicatorView* spinner =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
     UIActivityIndicatorViewStyleWhite];
    [spinner startAnimating];
    self.activityItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    UIImage* backIcon = [UIImage imageWithContentsOfFile:
                         NIPathForBundleResource(nil, @"NimbusWebController.bundle/gfx/backIcon.png")];
    // We weren't able to find the forward or back icons in your application's resources.
    // Ensure that you've dragged the NimbusWebController.bundle from src/webcontroller/resources
    //into your application with the "Create Folder References" option selected. You can verify that
    // you've done this correctly by expanding the NimbusPhotos.bundle file in your project
    // and verifying that the 'gfx' directory is blue. Also verify that the bundle is being
    // copied in the Copy Bundle Resources phase.
    //NIDASSERT(nil != backIcon);
    
    self.backButton =
    [[UIBarButtonItem alloc] initWithImage:backIcon
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(didTapBackButton)];
    self.backButton.tag = 2;
    self.backButton.enabled = NO;
    
    UIImage* forwardIcon = [UIImage imageWithContentsOfFile:
                            NIPathForBundleResource(nil, @"NimbusWebController.bundle/gfx/forwardIcon.png")];
    // We weren't able to find the forward or back icons in your application's resources.
    // Ensure that you've dragged the NimbusWebController.bundle from src/webcontroller/resources
    // into your application with the "Create Folder References" option selected. You can verify that
    // you've done this correctly by expanding the NimbusPhotos.bundle file in your project
    // and verifying that the 'gfx' directory is blue. Also verify that the bundle is being
    // copied in the Copy Bundle Resources phase.
    //NIDASSERT(nil != forwardIcon);
    
    self.forwardButton =
    [[UIBarButtonItem alloc] initWithImage:forwardIcon
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(didTapForwardButton)];
    self.forwardButton.tag = 1;
    self.forwardButton.enabled = NO;
    self.refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                          UIBarButtonSystemItemRefresh target:self action:@selector(didTapRefreshButton)];
    self.refreshButton.tag = 3;
    self.stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                       UIBarButtonSystemItemStop target:self action:@selector(didTapStopButton)];
    self.stopButton.tag = 3;
    self.actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                         UIBarButtonSystemItemAction target:self action:@selector(didTapShareButton)];
    
    UIBarItem* flexibleSpace =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                  target: nil
                                                  action: nil];
    
    self.toolbar.items = [NSArray arrayWithObjects:
                          self.backButton,
                          flexibleSpace,
                          self.forwardButton,
                          flexibleSpace,
                          self.refreshButton,
                          flexibleSpace,
                          self.actionButton,
                          nil];
    [self.view addSubview:self.toolbar];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [self updateWebViewFrame];
    self.webView.delegate = self;
    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                     | UIViewAutoresizingFlexibleHeight);
    self.webView.scalesPageToFit = YES;
    
    if ([UIColor respondsToSelector:@selector(underPageBackgroundColor)]) {
        self.webView.backgroundColor = [UIColor underPageBackgroundColor];
    }
    
    [self.view addSubview:self.webView];
    
    return;
}


- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.actionSheet.delegate = nil;
    self.webView.delegate = nil;
    
    self.actionSheet = nil;
    self.webView = nil;
    self.toolbar = nil;
    self.backButton = nil;
    self.forwardButton = nil;
    self.refreshButton = nil;
    self.stopButton = nil;
    self.actionButton = nil;
    self.activityItem = nil;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self updateToolbarWithOrientation:self.interfaceOrientation];
}


- (void)viewWillDisappear:(BOOL)animated {
    // If the browser launched the media player, it steals the key window and never gives it
    // back, so this is a way to try and fix that.
    [self.view.window makeKeyWindow];
    
    [super viewWillDisappear:animated];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}



- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateToolbarWithOrientation:toInterfaceOrientation];
}


#pragma mark - Private



- (void)didTapBackButton {
    [self.webView goBack];
}



- (void)didTapForwardButton {
    [self.webView goForward];
}



- (void)didTapRefreshButton {
    [self.webView reload];
}



- (void)didTapStopButton {
    [self.webView stopLoading];
}



- (void)didTapShareButton {
    // Dismiss the action menu if the user taps the action button again on the iPad.
    if ([self.actionSheet isVisible]) {
        // It shouldn't be possible to tap the share action button again on anything but the iPad.
        //NIDASSERT(NIIsPad());
        
        [self.actionSheet dismissWithClickedButtonIndex:[self.actionSheet cancelButtonIndex] animated:YES];
        
        // We remove the action sheet here just in case the delegate isn't properly implemented.
        self.actionSheet.delegate = nil;
        self.actionSheet = nil;
        self.actionSheetURL = nil;
        
        // Don't show the menu again.
        return;
    }
    
    // Remember the URL at this point
    self.actionSheetURL = [self.URL copy];
    
    if (nil == self.actionSheet) {
        self.actionSheet =
        [[UIActionSheet alloc] initWithTitle:[self.actionSheetURL absoluteString]
                                    delegate:self
                           cancelButtonTitle:nil
                      destructiveButtonTitle:nil
                           otherButtonTitles:nil];
        
        // Let -shouldPresentActionSheet: setup the action sheet
        if (![self shouldPresentActionSheet:self.actionSheet]) {
            // A subclass decided to handle the action in another way
            self.actionSheet = nil;
            self.actionSheetURL = nil;
            return;
        }
    }
    
    [self.actionSheet showInView:self.view];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateToolbarWithOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (!self.toolbarHidden) {
        CGRect toolbarFrame = self.toolbar.frame;
        toolbarFrame.size.height = 33;
        toolbarFrame.origin.y = self.view.bounds.size.height - toolbarFrame.size.height;
        self.toolbar.frame = toolbarFrame;
        
        CGRect webViewFrame = self.webView.frame;
        webViewFrame.size.height = self.view.bounds.size.height - toolbarFrame.size.height;
        self.webView.frame = webViewFrame;
        
    } else {
        self.webView.frame = self.view.bounds;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////




#pragma mark - UIWebViewDelegate



- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    self.loadingURL = [request.mainDocumentURL copy];
    self.backButton.enabled = [self.webView canGoBack];
    self.forwardButton.enabled = [self.webView canGoForward];
    return YES;
}



- (void)webViewDidStartLoad:(UIWebView*)webView {
    self.title = NSLocalizedString(@"Loading...", @"");
    if (!self.navigationItem.rightBarButtonItem) {
        [self.navigationItem setRightBarButtonItem:self.activityItem animated:YES];
    }
    
    NSInteger buttonIndex = 0;
    for (UIBarButtonItem* button in self.toolbar.items) {
        if (button.tag == 3) {
            NSMutableArray* newItems = [NSMutableArray arrayWithArray:self.toolbar.items];
            [newItems replaceObjectAtIndex:buttonIndex withObject:self.stopButton];
            self.toolbar.items = newItems;
            break;
        }
        ++buttonIndex;
    }
    self.backButton.enabled = [self.webView canGoBack];
    self.forwardButton.enabled = [self.webView canGoForward];
}



- (void)webViewDidFinishLoad:(UIWebView*)webView {
    self.loadingURL = nil;
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (self.navigationItem.rightBarButtonItem == self.activityItem) {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
    
    NSInteger buttonIndex = 0;
    for (UIBarButtonItem* button in self.toolbar.items) {
        if (button.tag == 3) {
            NSMutableArray* newItems = [NSMutableArray arrayWithArray:self.toolbar.items];
            [newItems replaceObjectAtIndex:buttonIndex withObject:self.refreshButton];
            self.toolbar.items = newItems;
            break;
        }
        ++buttonIndex;
    }
    
    self.backButton.enabled = [self.webView canGoBack];
    self.forwardButton.enabled = [self.webView canGoForward];
}



- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
    self.loadingURL = nil;
    [self webViewDidFinishLoad:webView];
}




#pragma mark - UIActionSheetDelegate



- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet == self.actionSheet) {
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication] openURL:self.actionSheetURL];
        } else if (buttonIndex == 1) {
            [[UIPasteboard generalPasteboard] setURL:self.actionSheetURL];
        }
    }
}



- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (actionSheet == self.actionSheet) {
        self.actionSheet.delegate = nil;
        self.actionSheet = nil;
        self.actionSheetURL = nil;
    }
}




#pragma mark - Public



- (NSURL *)URL {
    return self.loadingURL ? self.loadingURL : self.webView.request.mainDocumentURL;
}



- (void)openURL:(NSURL*)URL {
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    [self openRequest:request];
}



- (void)openRequest:(NSURLRequest *)request {
    self.loadRequest = request;
    
    if ([self isViewLoaded]) {
        if (nil != request) {
            [self.webView loadRequest:request];
            
        } else {
            [self.webView stopLoading];
        }
    }
}



- (void)openHTMLString:(NSString*)htmlString baseURL:(NSURL*)baseUrl {
	//NIDASSERT([self isViewLoaded]);
	[_webView loadHTMLString:htmlString baseURL:baseUrl];
}



- (void)setToolbarHidden:(BOOL)hidden {
    _toolbarHidden = hidden;
    if ([self isViewLoaded]) {
        self.toolbar.hidden = hidden;
        [self updateWebViewFrame];
    }
}



- (void)setToolbarTintColor:(UIColor*)color {
    if (color != _toolbarTintColor) {
        _toolbarTintColor = color;
    }
    
    if ([self isViewLoaded]) {
        self.toolbar.tintColor = color;
    }
}



- (BOOL)shouldPresentActionSheet:(UIActionSheet *)actionSheet {
    if (actionSheet == self.actionSheet) {
        [self.actionSheet addButtonWithTitle:NSLocalizedString(@"Open in Safari", @"")];
        [self.actionSheet addButtonWithTitle:NSLocalizedString(@"Copy URL", @"")];
    }
    return YES;
}


@end
