ARCHS = armv7 arm64
TARGET = iphone:clang:latest:latest
THEOS_PACKAGE_DIR_NAME = debs
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TestTweak
TestTweak_FILES = Tweak.xm
TestTweak_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += TestTweakPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk
