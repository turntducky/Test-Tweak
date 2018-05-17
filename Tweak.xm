#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <substrate.h>

static NSString *nsDomainString = @"com.ducksrepo.testtweakprefs";
static NSString *nsNotificationString = @"com.ducksrepo.testtweak/preferences.changed";

static bool popup;
static bool nocydiaads;

@interface NSUserDefaults (TestTweak)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end
@interface FBSystemService : NSObject
	+(id)sharedInstance;
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

//Disable Cydia ads (IDK IF THIS WORKS FOR IOS 11 ITS JUST A SMALL EXAMPLE FOR MULTIPLE TOGGLES)

@interface CyteWebView : UIWebView
@end

%hook CyteWebView

- (void)_updateViewSettings {
if(nocydiaads) {
    %orig;

    // Stolen from Flame, no idea what this does, really
    [self stringByEvaluatingJavaScriptFromString:@"var child = document.getElementsByClassName('spots'); while(child[0]) child[0].parentNode.removeChild(child[0]);"];
}
else %orig;
}
%end

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	NSNumber *n = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"popup" inDomain:nsDomainString];
	NSNumber *b = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"nocydiaads" inDomain:nsDomainString];

	popup = (n)? [n boolValue]:NO;
	nocydiaads = (b)? [b boolValue]:NO;
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
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)respring, CFSTR("com.ducksrepo.testtweak/respring"), NULL, 0);
}
