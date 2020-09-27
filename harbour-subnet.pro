# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-subnet

CONFIG += sailfishapp

SOURCES += src/harbour-subnet.cpp

DISTFILES += qml/harbour-subnet.qml \
    qml/components/IPTextField.qml \
    qml/components/NetworkDetail.qml \
    qml/js/ipcalc.js \
    qml/cover/CoverPage.qml \
    qml/pages/AboutPage.qml \
    qml/pages/NetworkPage.qml \
    qml/pages/SubnetsPage.qml \
    rpm/harbour-subnet.changes.in \
    rpm/harbour-subnet.changes.run.in \
    rpm/harbour-subnet.spec \
    rpm/harbour-subnet.yaml \
    translations/*.ts \
    harbour-subnet.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-subnet-de.ts
