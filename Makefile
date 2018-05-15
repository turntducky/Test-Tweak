ARCHS = armv7 arm64
TARGET = iphone:clang:latest:latest
THEOS_PACKAGE_DIR_NAME = debs
include ../theos/makefiles/common.mk

TWEAK_NAME = Respringtest
Respringtest_FILES = Tweak.xm
Respringtest_FRAMEWORKS = UIKit
Respringtest_PRIVATE_FRAMEWORKS = ChatKit
Respringtest_LDFLAGS += -Wl,-segalign,4000
Respringtest_CFLAGS = -fobjc-arc
Respringtest_LIBRARIES = MobileGestalt

include ../theos/makefiles/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += Respringtest
include ../theos/makefiles/aggregate.mk
