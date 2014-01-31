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
import com.nokia.extras 1.1

PageStackWindow {
    id: window 
    initialPage: songlist
    showStatusBar: true
    showToolBar: true

    SongList {
        id: songlist
    }

    StatusBar {            
        id: statusBar
        Text {
            id: statusBarTitle
            text: songlist.currentFolder
            color:"white"
        }
    }

    InfoBanner {
        id: infoBanner
        function showText(text) {
            infoBanner.text = text
            infoBanner.open()
        }
    }

} // end page
