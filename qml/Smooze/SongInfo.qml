// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: pageSongInfo
    tools: mainToolbar
    property string s_title : ""
    property string s_albumArtist : ""
    property string s_albumTitle : ""
    property string s_trackNumber : ""
    property string s_year : ""
    property string s_genre : ""
    property string s_copyright : ""

    // Default toolbar
    ToolBarLayout {
        id: mainToolbar

        // BACK BUTTON
        ToolButton {
            id: toolbarbtnBack
            iconSource: "toolbar-back"
            onClicked:
            {
                window.pageStack.depth <= 1 ? Qt.quit() : window.pageStack.pop()
            }
        }
    }

    ListView {
        id: infoView
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 5
        highlightFollowsCurrentItem: true
        clip: true
        model: songinfoModel
        delegate: songinfoComponent
    }

    ListModel {
        id: songinfoModel
        ListElement {
            infokey: ""
            infovalue: ""
        }
    }

    Component {
      id: songinfoComponent

      ListItem {
          id: songinfoItem
          height: (txtValue.height > 60) ? txtValue.height + 5 : 60

          Row {
              spacing: 5
              width: parent.width
              Text {
                  id: txtKey
                  text: infokey
                  width: 100
                  color: "white"
                  font.bold: true
                  wrapMode: Text.WordWrap
                  font.pointSize: 9
              }
              Text {
                  id: txtValue
                  text: infovalue
                  width: parent.width - 100
                  color: "white"
                  font.bold: false
                  wrapMode: Text.WordWrap
                  font.pointSize: 9
              }
          }
      }
    }

    onStatusChanged: {
        if (status == PageStatus.Activating) {
            songinfoModel.clear()
            songinfoModel.append({ "infokey": "Title" , "infovalue": s_title})
            songinfoModel.append({ "infokey": "Album artist" , "infovalue": s_albumArtist})
            songinfoModel.append({ "infokey": "Album title" , "infovalue": s_albumTitle})
            songinfoModel.append({ "infokey": "Track number" , "infovalue": s_trackNumber})
            songinfoModel.append({ "infokey": "Year" , "infovalue": s_year})
            songinfoModel.append({ "infokey": "Genre" , "infovalue": s_genre})
            songinfoModel.append({ "infokey": "Copyright" , "infovalue": s_copyright})
        }
    }

} // end page
