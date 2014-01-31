/* Copyright ? mangolazi 2012.
This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

//#include <QtGui/QApplication>
#include <QtDeclarative>
#include "qmlapplicationviewer.h"
#include "mediakeysobserver.h"
#include "qdeclarativefolderlistmodel.h"

 int main(int argc, char **argv)
 {
     QApplication app(argc, argv);
     app.setApplicationName("Smooze Player");

     QDeclarativeView view;
     //QDeclarativeContext *context = view.rootContext();

     qmlRegisterType<MediaKeysObserver>("MediaKeysObserver", 1, 0, "MediaKeysObserver");
     qmlRegisterType<QDeclarativeFolderListModel>("FolderListModelNew", 1, 0, "FolderListModelNew");

     view.setSource(QUrl("qml/Smooze/main.qml"));
     view.window()->show();
     QObject::connect(view.engine(), SIGNAL(quit()), &view, SLOT(close()));

     return app.exec();
 }
