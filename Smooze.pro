# Add more folders to ship with the application, here
folder_01.source = qml/Smooze
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

symbian:TARGET.UID3 = 0xE1AEB249
VERSION = 0.9.1

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += ReadUserData
vendorinfo += "%{\"mangolazi\"}" ":\"mangolazi\""
my_deployment.pkg_prerules = vendorinfo
DEPLOYMENT += my_deployment

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
# CONFIG += qdeclarative-boostable

# Add dependency to Symbian components
CONFIG += qt-components

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    mediakeysobserver.cpp \
    qdeclarativefolderlistmodel.cpp

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

HEADERS += \
    mediakeysobserver.h \
    qdeclarativefolderlistmodel.h

symbian{
    LIBS += -L\epoc32\release\armv5\lib -lremconcoreapi
    LIBS += -L\epoc32\release\armv5\lib -lremconinterfacebase
}
