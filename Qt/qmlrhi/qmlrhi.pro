QT += qml quick
CONFIG += qmltypes
CONFIG -= app_bundle
QML_IMPORT_NAME = MDKTextureItem
QML_IMPORT_MAJOR_VERSION = 1

HEADERS += VideoTextureItem.h
SOURCES += VideoTextureItem.cpp main.cpp
RESOURCES += mdktextureitem.qrc

macos|ios: LIBS += -framework Metal
macos: LIBS += -framework AppKit

target.path = $$[QT_INSTALL_EXAMPLES]/quick/scenegraph/mdktextureitem
INSTALLS += target

######## MDK SDK ##########
MDK_SDK = $$PWD/../../mdk-sdk
INCLUDEPATH += $$MDK_SDK/include
contains(QT_ARCH, x.*64) {
  android: MDK_ARCH = x86_64
  else: MDK_ARCH = x64
} else:contains(QT_ARCH, .*86) {
  MDK_ARCH = x86
} else:contains(QT_ARCH, a.*64) {
  android: MDK_ARCH = arm64-v8a
  else: MDK_ARCH = arm64
} else:contains(QT_ARCH, arm.*) {
  android: MDK_ARCH = armeabi-v7a
  else: MDK_ARCH = arm
}

static|contains(CONFIG, staticlib) {
  DEFINES += Q_MDK_API
} else {
  DEFINES += Q_MDK_API=Q_DECL_EXPORT
}
macx|ios {
  MDK_ARCH=
  QMAKE_CXXFLAGS += -F$$MDK_SDK/lib -x objective-c++ -fobjc-arc
  LIBS += -F$$MDK_SDK/lib -F/usr/local/lib -framework mdk
} else {
  LIBS += -L$$MDK_SDK/lib/$$MDK_ARCH -lmdk
  win32: LIBS += -L$$MDK_SDK/bin/$$MDK_ARCH # qtcreator will prepend $$LIBS to PATH to run targets
}
linux: LIBS += -Wl,-rpath-link,$$MDK_SDK/lib/$$MDK_ARCH # for libc++ symbols


mac {
  RPATHDIR *= @executable_path/Frameworks
  QMAKE_LFLAGS_SONAME = -Wl,-install_name,@rpath/
  isEmpty(QMAKE_LFLAGS_RPATH): QMAKE_LFLAGS_RPATH=-Wl,-rpath,
  for(R,RPATHDIR) {
    QMAKE_LFLAGS *= \'$${QMAKE_LFLAGS_RPATH}$$R\'
  }
}
