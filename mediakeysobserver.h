#ifndef MEDIAKEYSOBSERVER_H
 #define MEDIAKEYSOBSERVER_H

 #include <QObject>
 #include <remconcoreapitarget.h>
 #include <remconcoreapitargetobserver.h>
 #include <remconinterfaceselector.h>

 class MediaKeysObserver : public QObject, public MRemConCoreApiTargetObserver
 {
     Q_OBJECT
     Q_ENUMS(MediaKey)

 public:
     enum MediaKey {
         EVolIncKey,
         EVolDecKey,
         EPlayPauseKey,
         EStopKey,
         EBackwardKey,
         EForwardKey,
         EFastForwardKey,
         EFastRewindKey
     };

     MediaKeysObserver(QObject *parent = 0);
     virtual ~MediaKeysObserver();

 protected:
     void MrccatoCommand(TRemConCoreApiOperationId aOperationId, TRemConCoreApiButtonAction aButtonAct);

 signals:
     void mediaKeyClicked(int key);
     void mediaKeyPressed(int key);
     void mediaKeyReleased(int key);

 private:
     CRemConInterfaceSelector *interfaceSelector;
     CRemConCoreApiTarget *coreTarget;
 };

 #endif // MEDIAKEYSOBSERVER_H
