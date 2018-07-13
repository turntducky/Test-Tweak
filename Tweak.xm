/* What all you import for your tweak */
#import <Foundation/Foundation.h>

/* This is needed but never changes after you first put it in */
/* you will need to change the com.___.___ to match yours or else it will not work */
static NSString *nsDomainString = @"com.ducksrepo.testtweakprefs";
static NSString *nsNotificationString = @"com.ducksrepo.testtweak/preferences.changed";

/* This pulls from plist */
/* [THIS IS NEEDED] each time you make a new plist part you need to static bool key */
static bool popup;

/*This is the user default call [ALL THAT NEED TO CHANGE IS "MasterTweak" THAT NEEDS TO BE YOUR TWEAK NAME. DO NOT CHANGE ANYTHING ELSE]*/
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

/*

	Explanation -
	: hook what you want to tweak
	: "-" indicates that the method is an instance method, as opposed to a class method "(void)" indicates the return type {This can be found with FLEXible or in headers}
	: if() basically says "if popup is enabled then ..."
	: %orig; overrides what the original code does
	: Then we make a UIAlert
	: Then the title of the alert
	: Put text in the body
	: delegate is an object that acts on behalf of, or in coordination with, another object when that object encounters an event in a program
	: Then put what the button says
	: We have the other buttons hidden
	: Show the alert
	: else{} says if the key isnt enabled then use original

*/

//Respring popup
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
else {%orig;}
}
%end
//End respring popup


//Calls for notificationCallback so it will get from plist that something was enabled or disabled
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
/*[THIS DOWN IS ALL NEEDED] if you add a plist you have to update this {change - to a letter or word} */
//NSNumber *- = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"key" inDomain:nsDomainString];
	NSNumber* n = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"popup" inDomain:nsDomainString];


//Also change - with the corresponding word or letter from above
//key = (-)? [- boolValue]:NO;
	popup = (n) ? [n boolValue] : NO;


//Repring function
static void respring() {
	SpringBoard *sb = (SpringBoard *)[UIApplication sharedApplication];
  	if ([sb respondsToSelector:@selector(_relaunchSpringBoardNow)]) {
    	[sb _relaunchSpringBoardNow];
  	} else if (%c(FBSystemService)) {
    	[[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
  	}
}

/* If you use this way to pull form your plist you will need to add everything below till the last NULL,
if you do not want the respring function. */
%ctor {
	notificationCallback(NULL, NULL, NULL, NULL, NULL);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
		NULL,
		notificationCallback,
		(CFStringRef)nsNotificationString,
		NULL,
		CFNotificationSuspensionBehaviorCoalesce);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)respring, CFSTR("com.ducksrepo.mastertweak/respring"), NULL, 0);
}
