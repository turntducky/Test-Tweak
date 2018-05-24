//What all you import for your tweak
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <substrate.h>
#import <QuartzCore/QuartzCore.h>

//This is needed but never changes after you first put it in
static NSString *nsDomainString = @"com.ducksrepo.testtweakprefs";
static NSString *nsNotificationString = @"com.ducksrepo.testtweak/preferences.changed";

//Pulls from plist
/*[THIS IS NEEDED] each time you make a new plist part you need to static bool key */
static bool popup;//gets from plist

/*This is the user default call [ALL THAT NEED TO CHANGE IS "TestTweak" THAT NEEDS TO BE YOUR TWEAK NAME. DO NOT CHANGE ANYTHING ELSE]*/
@interface NSUserDefaults (TestTweak)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end
@interface FBSystemService : NSObject
	+(id)sharedInstance;
	-(void)exitAndRelaunch:(BOOL)arg1;
@end
//This is part of the respring function
@interface SpringBoard : NSObject
	- (void)_relaunchSpringBoardNow;
	+(id)sharedInstance;
  -(id)_accessibilityFrontMostApplication;
  -(void)clearMenuButtonTimer;
@end

//Respring popup
%hook SpringBoard //hook what header you wanna tweak
- (void)applicationDidFinishLaunching:(id)application{ //"-" indicates that the method is an instance method, as opposed to a class method "(void)" indicates the return type {This can be found with FLEXible or in headers}
if(popup){ //This basically says "if popup is enabled then ..."
    %orig; //Overrides what the original code was

    UIAlertView *alert = [[UIAlertView alloc] //Makes a UIAlert
    initWithTitle:@"Success" //Puts what the title will be
    message:@"Your device did a successful respring" //Text under the title
    delegate:self//delegate is an object that acts on behalf of, or in coordination with, another object when that object encounters an event in a program
    cancelButtonTitle:@"Okay" //Puts what the button says
    otherButtonTitles:nil]; //Hides the other button

    [alert show]; //Shows the alert
}
else {%orig;} //Says if popup isn't enabled then use the original code
}
%end
//End respring popup

//Calls for notificationCallback so it will get from plist that something was enabled or Disabled
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
/*[THIS DOWN IS ALL NEEDED] if you add a plist you have to update this {change - to a letter or word} */
//NSNumber *- = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"key" inDomain:nsDomainString];
	NSNumber *n = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"popup" inDomain:nsDomainString];
	
	popup = (n)? [n boolValue]:NO;


//Repring function
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
