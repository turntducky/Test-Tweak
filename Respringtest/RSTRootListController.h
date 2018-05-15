#import <Preferences/PSListController.h>

@interface RSTRootListController : PSListController

@end

@interface FBSystemService : NSObject
+(id)sharedInstance;
- (void)exitAndRelaunch:(bool)arg1;
@end

static void RespringDevice()
{
    [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}