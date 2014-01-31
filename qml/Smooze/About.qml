/* Copyright © mangolazi 2012.
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

import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: about
    tools: mainToolbar
    property string version: "0.9.1"

    // Default toolbar
    ToolBarLayout {
        id: mainToolbar
        ToolButton {
            id: toolbarbtnBack
            flat: true
            iconSource: "toolbar-back"
            anchors.left: parent.left
            onClicked: {
                    window.pageStack.pop()
            }
        }
   }

    Image {
        id: logoImage
        anchors.top: parent.top
        anchors.left: parent.left
        width: 80
        height: 80
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: "Smooze.svg"
    }

    Text {
        id: versionTxt
        anchors.left: logoImage.right
        anchors.leftMargin: 8
        anchors.right: parent.right
        anchors.bottom: logoImage.verticalCenter
        horizontalAlignment: Text.AlignLeft
        text: "Smooze " + version
        font.pointSize: 10
        font.bold: true
        color: "lightgray"
    }

    Text {
        id: byTxt
        anchors.left: logoImage.right
        anchors.leftMargin: 8
        anchors.right: parent.right
        anchors.top: logoImage.verticalCenter
        horizontalAlignment: Text.AlignLeft
        text: "mangolazi"
        font.pointSize: 8
        font.bold: true
        color: "lightgray"
    }

    Text {
        anchors.top: logoImage.bottom
        anchors.topMargin: 2
        anchors.bottom: parent.bottom
        width: parent.width
        text: "Smooze is a light and fast music player that uses QML FolderListModel and Audio elements. MP3, WAV, AAC(MP4) files are supported. \n
Toolbar buttons are for playing previous song, play/pause current song, and playing next song. Change play modes - normal, single loop, loop all and shuffle - using the mode button next to the time bar. Drag the time bar go back/forward in a file. While browsing other folders, press the pause/play button to return to the currently playing folder.\n
Licensed under GPLv3. Source at https://github.com/mangolazi/Smooze, check for new releases over at the Dailymobile Symbian^3 forum\n"
        font.pointSize: 8
        font.bold: false
        color: "white"
        wrapMode: Text.Wrap
        horizontalAlignment: Text.AlignLeft
    }


} // end page
