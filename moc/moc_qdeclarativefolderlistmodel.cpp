/****************************************************************************
** Meta object code from reading C++ file 'qdeclarativefolderlistmodel.h'
**
** Created: Fri Dec 27 00:41:28 2013
**      by: The Qt Meta Object Compiler version 62 (Qt 4.7.4)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../qdeclarativefolderlistmodel.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'qdeclarativefolderlistmodel.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.7.4. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_QDeclarativeFolderListModel[] = {

 // content:
       5,       // revision
       0,       // classname
       0,    0, // classinfo
       7,   14, // methods
       9,   49, // properties
       1,   85, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: signature, parameters, type, tag, flags
      29,   28,   28,   28, 0x05,

 // slots: signature, parameters, type, tag, flags
      45,   28,   28,   28, 0x08,
      71,   55,   28,   28, 0x08,
     101,   55,   28,   28, 0x08,
     140,  130,   28,   28, 0x08,

 // methods: signature, parameters, type, tag, flags
     194,  188,  183,   28, 0x02,
     217,  188,  208,   28, 0x02,

 // properties: name, type, flags
     239,  234, 0x11495103,
     246,  234, 0x11495001,
     271,  259, 0x0b095103,
     293,  283, 0x0009510b,
     303,  183, 0x01095103,
     316,  183, 0x01095103,
     325,  183, 0x01095103,
     342,  183, 0x01095103,
     363,  359, 0x02095001,

 // properties: notify_signal_id
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,

 // enums: name, flags, count, data
     283, 0x0,    5,   89,

 // enum data: key, value
     369, uint(QDeclarativeFolderListModel::Unsorted),
     378, uint(QDeclarativeFolderListModel::Name),
     383, uint(QDeclarativeFolderListModel::Time),
     388, uint(QDeclarativeFolderListModel::Size),
     393, uint(QDeclarativeFolderListModel::Type),

       0        // eod
};

static const char qt_meta_stringdata_QDeclarativeFolderListModel[] = {
    "QDeclarativeFolderListModel\0\0"
    "folderChanged()\0refresh()\0index,start,end\0"
    "inserted(QModelIndex,int,int)\0"
    "removed(QModelIndex,int,int)\0start,end\0"
    "handleDataChanged(QModelIndex,QModelIndex)\0"
    "bool\0index\0isFolder(int)\0QVariant\0"
    "getFilePath(int)\0QUrl\0folder\0parentFolder\0"
    "QStringList\0nameFilters\0SortField\0"
    "sortField\0sortReversed\0showDirs\0"
    "showDotAndDotDot\0showOnlyReadable\0int\0"
    "count\0Unsorted\0Name\0Time\0Size\0Type\0"
};

const QMetaObject QDeclarativeFolderListModel::staticMetaObject = {
    { &QAbstractListModel::staticMetaObject, qt_meta_stringdata_QDeclarativeFolderListModel,
      qt_meta_data_QDeclarativeFolderListModel, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &QDeclarativeFolderListModel::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *QDeclarativeFolderListModel::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *QDeclarativeFolderListModel::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_QDeclarativeFolderListModel))
        return static_cast<void*>(const_cast< QDeclarativeFolderListModel*>(this));
    if (!strcmp(_clname, "QDeclarativeParserStatus"))
        return static_cast< QDeclarativeParserStatus*>(const_cast< QDeclarativeFolderListModel*>(this));
    if (!strcmp(_clname, "com.trolltech.qml.QDeclarativeParserStatus"))
        return static_cast< QDeclarativeParserStatus*>(const_cast< QDeclarativeFolderListModel*>(this));
    return QAbstractListModel::qt_metacast(_clname);
}

int QDeclarativeFolderListModel::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QAbstractListModel::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: folderChanged(); break;
        case 1: refresh(); break;
        case 2: inserted((*reinterpret_cast< const QModelIndex(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])),(*reinterpret_cast< int(*)>(_a[3]))); break;
        case 3: removed((*reinterpret_cast< const QModelIndex(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])),(*reinterpret_cast< int(*)>(_a[3]))); break;
        case 4: handleDataChanged((*reinterpret_cast< const QModelIndex(*)>(_a[1])),(*reinterpret_cast< const QModelIndex(*)>(_a[2]))); break;
        case 5: { bool _r = isFolder((*reinterpret_cast< int(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = _r; }  break;
        case 6: { QVariant _r = getFilePath((*reinterpret_cast< int(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = _r; }  break;
        default: ;
        }
        _id -= 7;
    }
#ifndef QT_NO_PROPERTIES
      else if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QUrl*>(_v) = folder(); break;
        case 1: *reinterpret_cast< QUrl*>(_v) = parentFolder(); break;
        case 2: *reinterpret_cast< QStringList*>(_v) = nameFilters(); break;
        case 3: *reinterpret_cast< SortField*>(_v) = sortField(); break;
        case 4: *reinterpret_cast< bool*>(_v) = sortReversed(); break;
        case 5: *reinterpret_cast< bool*>(_v) = showDirs(); break;
        case 6: *reinterpret_cast< bool*>(_v) = showDotAndDotDot(); break;
        case 7: *reinterpret_cast< bool*>(_v) = showOnlyReadable(); break;
        case 8: *reinterpret_cast< int*>(_v) = count(); break;
        }
        _id -= 9;
    } else if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: setFolder(*reinterpret_cast< QUrl*>(_v)); break;
        case 2: setNameFilters(*reinterpret_cast< QStringList*>(_v)); break;
        case 3: setSortField(*reinterpret_cast< SortField*>(_v)); break;
        case 4: setSortReversed(*reinterpret_cast< bool*>(_v)); break;
        case 5: setShowDirs(*reinterpret_cast< bool*>(_v)); break;
        case 6: setShowDotAndDotDot(*reinterpret_cast< bool*>(_v)); break;
        case 7: setShowOnlyReadable(*reinterpret_cast< bool*>(_v)); break;
        }
        _id -= 9;
    } else if (_c == QMetaObject::ResetProperty) {
        _id -= 9;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 9;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 9;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 9;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 9;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 9;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void QDeclarativeFolderListModel::folderChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, 0);
}
QT_END_MOC_NAMESPACE
