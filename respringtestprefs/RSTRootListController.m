#include "RSTRootListController.h"
#include "notify.h"

@implementation RSTRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (void)respring:(id)sender {
    //send notification to tweak
    notify_post("com.ducksrepo.respring/respring");
}
@end
