#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <substrate.h>

static bool popup;
static bool FullStatusTime;
static bool infinate;
static bool nostoreupdates;
static bool nocydiaads;
static bool dictation;

#define PLIST_PATH @"/var/mobile/Library/Preferences/com.ducksrepo.entry.plist"

inline bool GetPrefBool(NSString *key) {
        return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key] boolValue];
}
//Start respring
@interface FBSystemService : NSObject
+(id)sharedInstance;
- (void)exitAndRelaunch:(bool)arg1;
@end

static void RespringDevice()
{
    [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}

%ctor
{
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)RespringDevice, CFSTR("com.ducksrepo.respringtest/respring"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
//End respring function

//Enables a respring popup
%hook SpringBoard

-(void)applicationDidFinishLaunching:(id)application{
if(popup){
    %orig;

    UIAlertView *alert = [[UIAlertView alloc]
    initWithTitle:@"Success"
    message:@"Your device did a successful respring"
    delegate:self
    cancelButtonTitle:@"Okay"
    otherButtonTitles:nil];

    [alert show];
}
else %orig;
}
%end

//Makes the format in the statusbar h:mm M/d/yy
@interface SBStatusBarStateAggregator : NSObject
@end

%hook SBStatusBarStateAggregator

-(void)_resetTimeItemFormatter {
if(FullStatusTime){
  %orig;

  NSDateFormatter *timeFormat = [self valueForKey:@"_timeItemDateFormatter"];
  timeFormat.dateFormat = @"h:mm a   M/d/yy ";

}
else %orig;
}
%end

//Makes the keyboard dark system wide

//Enables infinate zoom in the photos app.
%hook PUOneUpSettings

- (void)setDefaultMaximumZoomFactor:(CGFloat)factor {
if(infinate){
    %orig(INFINITY);
}
else %orig;
}
%end

//When enabled it won't show app update history in the App Store's Update tab.
%hook ASUpdatesPage

- (void)_renderSectionsWithClientContext:(id)context timezoneOffset:(double)offset availableUpdates:(id)available installedByDate:(id)updated {
if(nostoreupdates) {
    updated = NULL;
    %orig;
}
else %orig;
}
%end

//Gets rid of cydia ads.
@interface CyteWebView : UIWebView
@end

%hook CyteWebView

- (void)_updateViewSettings {
if(nocydiaads){
    %orig;

    //This is a snippit from the tweak Flame
    [self stringByEvaluatingJavaScriptFromString:@"var child = document.getElementsByClassName('spots'); while(child[0]) child[0].parentNode.removeChild(child[0]);"];
}
else %orig;
}
%end

//Double tap on status bar time to toggle between date and time.


//Disables dictation key
%hook UIKeyboardLayotStar

-(BOOL)shouldShowDictationKey {
if(dictation){
return NO;
}
else return YES;
}
%end
//To be continued..
