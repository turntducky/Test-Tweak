#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <substrate.h>

static NSString *nsDomainString = @"com.ducksrepo.respringtestprefs";
static NSString *nsNotificationString = @"com.ducksrepo.respringtest/preferences.changed";

static bool popup;
static bool FullStatusTime;
static bool infinate;
static bool nostoreupdates;
static bool nocydiaads;
static bool dictation;

inline bool GetPrefBool(NSString *key) {
        return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key] boolValue];
}

@interface NSUserDefaults (respringtest)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end
@interface FBSystemService : NSObject
        +(id)sharedInstance
        -(void)exitAndRelaunch:(BOOL)arg1;
@end
@interface SpringBoard : NSObject
        - (void)_relaunchSpringBoardNow;
        +(id)sharedInstance;
    -(id)_accessibilityFrontMostApplication;
    -(void)clearMenuButtonTimer;
@end

//Enables a respring popup
%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)application{
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

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	NSNumber *n = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"popup" inDomain:nsDomainString];
	NSNumber *o = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"FullStatusTime" inDomain:nsDomainString];
	NSNumber *p = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"infinate" inDomain:nsDomainString];
	NSNumber *e = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"nostoreupdates" inDomain:nsDomainString];
	NSNumber *m = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"nocydiaads" inDomain:nsDomainString];
	NSNumber *z = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"dictation" inDomain:nsDomainString];

	popup = (n)? [n boolValue]:NO;
	FullStatusTime = (o)? [o boolValue]:NO;
	infinate = (p) ? [p boolValue] : NO;
	nostoreupdates = (e) ? [e boolValue] : NO;
	nocydiaads = (m) ? [m boolValue] : NO;
	dictation = (z) ? [z boolValue] : NO;
}

static void respring() {
	SpringBoard *sb = (SpringBoard *)[UIApplication sharedApplication];
  	if ([sb respondsToSelector:@selector(_relaunchSpringBoardNow)]) {
    	[sb _relaunchSpringBoardNow];
  	} else if (%c(FBSystemService)) {
    	[[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
  	}
}

%ctor {
  notificationCallback(NULL, NULL, NULL, NULL, NULL);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
		NULL,
		notificationCallback,
		(CFStringRef)nsNotificationString,
		NULL,
		CFNotificationSuspensionBehaviorCoalesce);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)respring, CFSTR("com.ducksrepo.respringtest/respring"), NULL, 0);
}
