ARCHS = armv7 arm64
include ../../theos/makefiles/common.mk

BUNDLE_NAME = Respringtestprefs
Respringtest_FILES = RSTRootListController.m
Respringtest_INSTALL_PATH = /Library/PreferenceBundles
Respringtest_FRAMEWORKS = UIKit
Respringtest_PRIVATE_FRAMEWORKS = Preferences

include ../../theos/makefiles/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Respringtest.plist$(ECHO_END)
