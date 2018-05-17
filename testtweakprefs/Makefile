ARCHS = armv7 arm64
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = TestTweakPrefs
TestTweakPrefs_FILES = DTTRootListController.m
TestTweakPrefs_INSTALL_PATH = /Library/PreferenceBundles
TestTweakPrefs_FRAMEWORKS = UIKit
TestTweakPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/TestTweakPrefs.plist$(ECHO_END)
