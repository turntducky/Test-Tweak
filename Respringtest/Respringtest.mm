#import <Preferences/Preferences.h>
#include "notify.h"

@interface RespringtestListController: PSListController {
}
@end

@implementation RespringtestListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Respringtest" target:self] retain];
	}
	return _specifiers;
}

-(void)respring
{
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.ducksrepo.respringtest/respring"), NULL, NULL, YES);
}
@end