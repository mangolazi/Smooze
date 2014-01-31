/* Copyright mangolazi 2012.
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
import FolderListModelNew 1.0 // thanks for nothing Nokia!
import QtMultimediaKit 1.1
import MediaKeysObserver 1.0
import "dbcore.js" as DBcore

Page {
    id: mainPage
    property int indexPlaying : 0 // index of file being played, in play model
    property int indexViewing : 0 // index of file being played, in view model
    property int indexRandom : 0 // random index for shuffle
    property string filePlaying : "" // full path of file being played
    property string filePlayingName : "" // filename of file being played
    property string activeFolder // active folder with file being played
    property string currentFolder // current folder
    property int indexFolder : -1 // index of previous folder clicked, to refocus list
    property double currentVolume : 0.1 // current volume
    property string resumePlaying : "false" // config value for auto-resume play
    property int lastPosition : 0 // previous position in song, on first load
    property string playMode : "normal" // play mode - normal, loopall, loopsingle, shuffle
  
  tools: mainToolbar

  // AUDIO ELEMENT FOR PLAYING SONGS
    Audio {
      id: songPlayer
      volume: 0.2
      autoLoad: false

      onStarted: {
          // stupid Symbian Qt 4.8 volume bug! fixed!
          volume = 0.0
          volume = currentVolume
      }

      // keep playing next song
      onStatusChanged: {
          if (status == Audio.EndOfMedia) {
              // loop single, end of song, play again
              if (playMode == "loopsingle") {
                  play()
              }
              else if (playMode == "shuffle"){
                  playShuffle()
              }
              else {
                  nextSong()
              }
          }
      }
  }

    // VOLUME AND MEDIA KEYS HANDLER
    MediaKeysObserver {
        id: mediakeysobserver
        property int key

        onMediaKeyClicked: {
            // increase volume
            if (key == MediaKeysObserver.EVolIncKey) {
                volDialog.open()
                if (currentVolume < 1.0) {
                    currentVolume += 0.02
                    songPlayer.volume = currentVolume
                }
                volTimer.start()
            }
            // decrease volume
            else if (key == MediaKeysObserver.EVolDecKey) {
                volDialog.open()
                if (currentVolume > 0.02) {
                    currentVolume -= 0.02
                    songPlayer.volume = currentVolume
                }
                volTimer.start()
            }
            else if (key == MediaKeysObserver.EStopKey) {
                // pause if playing
                if ((songPlayer.playing == true) && (songPlayer.paused == false)) {
                    songPlayer.pause()
                }
                // resume play if paused
                if ((songPlayer.playing == true) && (songPlayer.paused == true)) {
                    songPlayer.play()
                }
            }
            // play next song
            else if (key == MediaKeysObserver.EForwardKey) {
                if (playMode == "shuffle"){
                    playShuffle()
                }
                else {
                    nextSong()
                }
            }
            // play previous song
            else if (key == MediaKeysObserver.EBackwardKey) {
                if (playMode == "shuffle"){
                    playShuffle()
                }
                else {
                    prevSong()
                }
            }
         }

        onMediaKeyPressed: {
            if ((key == MediaKeysObserver.EVolIncKey) || (key == MediaKeysObserver.EVolDecKey)) {
                mediakeysobserver.key = key
                volDialog.open()
                timerMediaKeys.start()
            }
        }

        onMediaKeyReleased: {
            if ((key == MediaKeysObserver.EVolIncKey) || (key == MediaKeysObserver.EVolDecKey)) {
                timerMediaKeys.stop()
                volDialog.close()
            }
        }
    }

    // MEDIA KEYS TIMER FOR LONG PRESS
    Timer {
        id: timerMediaKeys
        interval: 200
        repeat: true
        onTriggered: {
            // increase volume
            if (mediakeysobserver.key == MediaKeysObserver.EVolIncKey) {
                if (currentVolume < 1.0) {
                    currentVolume += 0.02
                    songPlayer.volume = currentVolume
                }
            }
            // decrease volume
            else if (mediakeysobserver.key == MediaKeysObserver.EVolDecKey) {
                if (currentVolume > 0.02) {
                    currentVolume -= 0.02
                    songPlayer.volume = currentVolume
                }
            }
        }
    }

    // =============================
    // Default toolbar
    ToolBarLayout {
        id: mainToolbar

        // BACK BUTTON
        ToolButton {
            id: toolbarbtnBack
            iconSource: folderModel.parentFolder == "" ? "close_stop.svg" : "toolbar-back"
            onClicked:
            {
                folderModel.parentFolder == "" ? quitSmooze() : upFolderView()
            }
            onPlatformPressAndHold: {
                pageStack.depth <= 1 ? quitSmooze() : pageStack.pop()
            }
        }

        // BACKWARDS BUTTON - go to previous song
        ToolButton {
            id: toolbarbtnBackwards
            iconSource: "prev.svg"
            flat: false
            onClicked:
            {
                if (playMode == "shuffle"){
                    playShuffle()
                }
                else {
                    prevSong()
                }
            }
        }

        // STOP START BUTTON - stop currently playing song, start playing again
        ToolButton {
            id: toolbarbtnStopStart
            flat: false
            iconSource: (songPlayer.paused == true || songPlayer.playing == false) ? "toolbar_play.svg" : "toolbar_pause.svg"
            onClicked: {
                // pause playing current song, otherwise resume
                if (songPlayer.playing == true) {
                    if (songPlayer.paused == true) {
                        jumpBack()
                        songPlayer.play()
                    }
                    else {
                        jumpBack()
                        songPlayer.pause()
                    }
                }
            }
        }

        // FORWARD BUTTON - go to next song
        // long press to fast forward 10 seconds each time
        ToolButton {
            id: toolbarbtnForward
            iconSource: "next.svg"
            flat: false
            onClicked: {
                if (playMode == "shuffle"){
                    playShuffle()
                }
                else {
                    nextSong()
                }
            }
            /*onPlatformReleased:  {
                if (songPlayer.position < songPlayer.duration - 10000 ) {
                    songPlayer.position += 10000
                }
            }*/
        }

        // MENU BUTTON
        ToolButton {
            id: toolbarbtnMenu
            iconSource: "toolbar-menu"
            onClicked: mainMenu.open()
        }
    }

    // MAIN MENU
    Menu {
        id: mainMenu
        content: MenuLayout {


            MenuItem {
                text: "Auto resume"
                Image {
                    id: checkedIcon
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    source: "checked.svg"
                    visible: (resumePlaying == "true") ? true : false
                }
                onClicked: {
                    if (resumePlaying == "true") { resumePlaying = "false" }
                    else if (resumePlaying == "false") { resumePlaying = "true" }
                }
            }

            MenuItem {
                text: "Volume"
                onClicked: {
                    volDialog.open()
                }
            }

            MenuItem {
                text: "Song info"
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("SongInfo.qml"), {s_title:songPlayer.metaData.title, s_albumArtist:songPlayer.metaData.albumArtist, s_albumTitle:songPlayer.metaData.albumTitle, s_trackNumber:songPlayer.metaData.trackNumber, s_year:songPlayer.metaData.year, s_genre:songPlayer.metaData.genre, s_copyright:songPlayer.metaData.copyright })
                }
            }

            MenuItem {
                text: "About"
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("About.qml"))
                }
            }

            MenuItem {
                text: "Exit"
                onClicked: {
                    quitSmooze()
                }
            }
         }
     }

    // TIMER FOR LONG PRESS ON MEDIA KEYS
    // currently volume only, need to do ff/rewind
    Timer {
        id: timerFast
        interval: 200
        repeat: true
        onTriggered: {
            // increase volume
            if (mediakeysobserver.key == MediaKeysObserver.EVolIncKey) {
                if (currentVolume < 1.0) {
                    currentVolume += 0.02
                    songPlayer.volume = currentVolume
                }
            }
            // decrease volume
            else if (mediakeysobserver.key == MediaKeysObserver.EVolDecKey) {
                if (currentVolume > 0.02) {
                    currentVolume -= 0.02
                    songPlayer.volume = currentVolume
                }
            }
        }
    }

    // SLIDER TO DISPLAY MUSIC DURATION
    Item {
        id: sliderBar
        anchors.bottom: parent.bottom
        width: parent.width
        height: slider.height

        Text {
            id: currentTime
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            color: "lightgray"
            font.pixelSize: 18
            text: (filePlaying == "" ) ? "" : getTimeFromMSec(slider.value)
        }

        Slider {
             id: slider
             anchors.top: parent.top
             anchors.left: currentTime.right
             anchors.right: durationTime.left
             anchors.verticalCenter: parent.verticalCenter
             height: 60
             width: parent.width - currentTime.width - durationTime.width - loopButton.width
             maximumValue: songPlayer.duration
             valueIndicatorVisible: true
             valueIndicatorText: getTimeFromMSec(slider.value)
             stepSize: 1000
             onPressedChanged: {
                 if (!pressed)
                     songPlayer.position = value
             }
             Binding {
                 target: slider
                 property: "value"
                 value: songPlayer.position
                 when: !slider.pressed
             }
        }

        Text {
            id: durationTime
            anchors.right: loopButton.left // parent.right
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            color: "lightgray"
            font.pixelSize: 18
            text: (filePlaying == "" ) ? "" : getTimeFromMSec(songPlayer.duration)
        }

        // SHUFFLE BUTTON
        Button {
            id: loopButton
            anchors.right: parent.right
            width: 50
            anchors.verticalCenter: parent.verticalCenter
            text: "N"
            onClicked: {
                // toggle through different loop states
                if (playMode == "normal") { state = "loopsingle"; playMode = "loopsingle" }
                else if (state == "loopsingle") { state = "loopall"; playMode = "loopall" }
                else if (state == "loopall") { state = "shuffle"; playMode = "shuffle" }
                else if (state == "shuffle") { state = "normal"; playMode = "normal" }
                }
            states: [
                State {
                    name: "normal";
                    PropertyChanges { target: loopButton; text: "N" }
                    StateChangeScript { script: infoBanner.showText("Normal play") }
                    },
                State {
                    name: "loopsingle";
                    PropertyChanges { target: loopButton; text: "1" }
                    StateChangeScript { script: infoBanner.showText("Loop single") }
                    },
                State {
                    name: "loopall";
                    PropertyChanges { target: loopButton; text: "A" }
                    StateChangeScript { script: infoBanner.showText("Loop all songs") }
                    },
                State {
                    name: "shuffle";
                    PropertyChanges { target: loopButton; text: "S" }
                    StateChangeScript { script: infoBanner.showText("Shuffle play") }
                    }
            ]
        }
    }

    // VOLUME DIALOG
    CommonDialog {
        id: volDialog
        titleText: "Current volume"
        content:         
            Row {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width

            Text {
                id: negvol
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: "-"
                font.pixelSize: 16
                font.bold: true
                color: "white"
            }
            Text {
                id: volValue
                anchors.horizontalCenter: volbar.horizontalCenter
                anchors.verticalCenter: volbar.verticalCenter
                text: currentVolume * 100
                font.pixelSize: 16
                font.bold: true
                color: "white"
            }
            ProgressBar {
                id: volbar
                anchors.left: negvol.right
                anchors.leftMargin: 10
                anchors.right: posvol.left
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                height: 60
                minimumValue: 0.0
                maximumValue: 1.0
                value: currentVolume
                visible: true
            }
            Text {
                id: posvol
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: "+"
                font.pixelSize: 16
                font.bold: true
                color: "white"
            }
        }

        onClickedOutside: {
            volDialog.close()
        }
    }

    Timer {
        id: volTimer
        interval: 3000
        running: false
        repeat: false
        onTriggered: volDialog.close()
    }

    // =============================
    // MAIN SONG VIEW

    ListView {
        id: songView
        anchors.top: parent.top
        anchors.bottom: sliderBar.top
        anchors.left: parent.left
        anchors.right: parent.right
        focus: true
        clip: true
        model: folderModel
        delegate: songComponent
    }

    ScrollDecorator {
         id: scrolldecorator
         flickableItem: songView
     }

    FolderListModelNew {
        id: folderModel        
        folder: "file:////"
        showDirs: true
        sortField: "Type"
        showDotAndDotDot: false
        showOnlyReadable: true
        nameFilters: ["*.mp3", "*.wav", "*.m4a", "*.mp4", "*.aac"]
    }

    ListModel {
        id: folderHistoryModel
        ListElement {
            folder: ""
            index: 0
        }
    }

    ListModel {
        id: playModel
        ListElement {
            filepath: ""
        }
    }

    Component {
      id: songComponent
      ListItem {
          id: songItem          
          height: (filename.height > 50) ? filename.height + 5 : 50
          property variant myData: model
          Image {
              id: foldersymbol
              source: (folderModel.isFolder(index)) ? "folder.svg" : "song.svg"
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
          }
          Text {
              id: filename
              text: fileName
              anchors.verticalCenter: parent.verticalCenter              
              anchors.left: foldersymbol.right
              anchors.leftMargin: 5
              anchors.right: parent.right
              width: parent.width - foldersymbol.width
              color: (filePlaying == model.filePath) ? "red" : "white"
              font.bold: (filePlaying == model.filePath) ? true : false
              wrapMode: Text.Wrap
              font.pointSize: 9
          }

          // Folder and file navigation
          onClicked: {
              if (folderModel.isFolder(index)) { // If folder, change to folder
                  indexFolder = index
                  folderModel.folder += "/" + fileName
                  folderHistoryModel.append({"folder": folderModel.folder, "index": index})
                  setcurrentFolder()
              }
              else { // If song file, play
                  filePlaying = model.filePath
                  filePlayingName = model.fileName
                  activeFolder = folderModel.folder
                  songPlayer.stop()                  
                  songPlayer.source = model.filePath
                  songPlayer.play()
                  setPlayModel()
              }
          }
      }
    }


    // -----------------------------------------
    // FUNCTIONS

    // RESET PLAYBACK
    function resetPlayback () {
        filePlaying = ""
        indexPlaying = -1
        songView.currentIndex = -1
        songPlayer.position = 0
    }

    // SET CURRENT FOLDER NAME FOR DISPLAY
    // longer for landscape, shorter for portrait orientation
    function setcurrentFolder () {
        var folder = new String(folderModel.folder);
        folder = folder.substring(folder.length, folder.lastIndexOf('/') + 1);

        if (folder.length > 16) {
            if (screen.currentOrientation == Screen.Portrait) {
                folder = folder.substring(16, 0).concat("...")
            }
            else {
                folder = folder.substring(50, 0).concat("...")
            }
        }
        currentFolder = folder
    }

    // SET PLAY MODEL TO POPULATE FILE LIST FOR PLAYBACK
    function setPlayModel() {
        playModel.clear()
        var i = 0;
        for (i =0; i < folderModel.count; i++) {
            if (!folderModel.isFolder(i)) {
                playModel.append({"filepath" : folderModel.getFilePath(i)});
                if (folderModel.getFilePath(i) == filePlaying) { // currently playing file
                    indexPlaying = playModel.count-1;
                }
            }
        }
    }

    // GO BACK TO FOLDER WITH CURRENTLY PLAYING FILE
    function jumpBack () {
        folderModel.folder = activeFolder
        setcurrentFolder()
    }

    // GO BACK TO PREVIOUS FOLDER, WHEN CLICKING ON BACK BUTTON
    function upFolderView () {
        folderModel.folder = folderModel.parentFolder
        setcurrentFolder()
//        if (folderHistoryModel.count > 0) {
//           songView.positionViewAtIndex(folderHistoryModel.get(folderHistoryModel.count - 1).index, ListView.Center)
//            folderHistoryModel.remove(folderHistoryModel.count - 1)
//        }
    }

    // AUTO-RESUME PREVIOUSLY PLAYED SONG, NEEDS TIMER HACK
    Timer {
        id: timerAutoplay
        interval: 700
        onTriggered: {
            songPlayer.position = lastPosition
            songView.currentIndex = indexPlaying
            songView.positionViewAtIndex(indexPlaying, ListView.Center)
            setPlayModel()
        }
    }

    // PLAY NEXT FILE
    function nextSong () {
        songPlayer.stop()
        // Normal play, end of list, stop
        if (playMode == "normal") {
            if (indexPlaying < playModel.count - 1) {
                indexPlaying += 1
                filePlaying = playModel.get(indexPlaying).filepath
                songPlayer.source = filePlaying
                songPlayer.play()
            }
            else {
                resetPlayback()
            }
        }

        // Loop all or loop single, end of list, go back to top
        if (playMode == "loopall" || playMode == "loopsingle") {
            if (indexPlaying < playModel.count - 1) {
                indexPlaying += 1
            }
            else {
                indexPlaying = 0
            }
            filePlaying = playModel.get(indexPlaying).filepath
            songPlayer.source = filePlaying
            songPlayer.play()
        }

        if (folderModel.folder == activeFolder) {
            songView.positionViewAtIndex(indexPlaying, ListView.Center)
        }
    }

    // PLAY PREVIOUS FILE
    function prevSong () {
        songPlayer.stop()
        // Normal play, end of list, stop
        if (playMode == "normal") {
            if (indexPlaying > 0) {
                indexPlaying -= 1
                filePlaying = playModel.get(indexPlaying).filepath
                songPlayer.source = filePlaying
                songPlayer.play()
            }
            else {
                resetPlayback()
            }
        }

        // Loop all or loop single, end of list, go back to top
        if (playMode == "loopall" || playMode == "loopsingle") {
            if (indexPlaying > 0) {
                indexPlaying -= 1
            }
            else {
                indexPlaying = 0
            }
            filePlaying = playModel.get(indexPlaying).filepath
            songPlayer.source = filePlaying
            songPlayer.play()
        }

        if (folderModel.folder == activeFolder) {
            songView.positionViewAtIndex(indexPlaying, ListView.Center)
        }
    }

    // SHUFFLE PLAY
    function playShuffle() {
        songPlayer.stop()
        getRandomIndex()
        indexPlaying = indexRandom
        console.log("Shuffle " + indexPlaying)
        filePlaying = playModel.get(indexPlaying).filepath
        songPlayer.source = filePlaying
        songPlayer.play()
        if (folderModel.folder == activeFolder) {
            songView.positionViewAtIndex(indexPlaying, ListView.Center)
        }
    }

    // GET RANDOM INDEX FOR SHUFFLE, NO REPEATS
    function getRandomIndex() {
        indexRandom = Math.floor(Math.random() * playModel.count);
        while (indexPlaying == indexRandom) {
            indexRandom = Math.floor(Math.random() * playModel.count);
        }
    }

    // CONVERT MSECS TO TIME
    function getTimeFromMSec(msec) {
        if (msec <= 0 || msec == undefined) {
            return "0:00"
        }
        else {
            var sec = "" + Math.floor(msec / 1000) % 60
            if (sec.length == 1)
                sec = "0" + sec
            var hour = Math.floor(msec / 3600000)
            if (hour < 1) {
                return Math.floor(msec / 60000) + ":" + sec
            }
            else {
                var min = "" + Math.floor(msec / 60000) % 60
                if (min.length == 1)
                    min = "0" + min
                return hour + ":" + min + ":" + sec
            }
        }
    }


    // SAVE CONFIG, LAST PATH, SONG AND TIME TO DATABASE
    function saveConfig() {
        var configitem = DBcore.defaultConfig();
        configitem.configkey = "resumeplaying";
        configitem.configvalue = resumePlaying; //folderModel.folder;
        DBcore.deleteConfig(configitem.configkey)
        DBcore.createConfig(configitem);
        configitem.configkey = "lastpath";
        configitem.configvalue = activeFolder;
        DBcore.deleteConfig(configitem.configkey)
        DBcore.createConfig(configitem);
        configitem.configkey = "lastsong";
        configitem.configvalue = songPlayer.source
        DBcore.deleteConfig(configitem.configkey)
        DBcore.createConfig(configitem);
        configitem.configkey = "lastposition";
        configitem.configvalue = songPlayer.position;
        DBcore.deleteConfig(configitem.configkey)
        DBcore.createConfig(configitem);       
        configitem.configkey = "lastindex";
        configitem.configvalue = indexPlaying;
        DBcore.deleteConfig(configitem.configkey)
        DBcore.createConfig(configitem);
    }


    // QUIT SMOOZE, SAVE ALL CONFIGS FIRST
    function quitSmooze() {
        saveConfig()
        Qt.quit()
    }

    // PAGE LOADING SETUP
    // set initial folder, resume song, time, load from database
    Component.onCompleted: {                
        DBcore.openDB()
        var configitem;
        // auto resume code
        configitem = DBcore.readConfig("resumeplaying")
        resumePlaying = configitem.configvalue

        if (resumePlaying == "true") {
            infoBanner.showText("Resuming playback")
            configitem = DBcore.readConfig("lastpath")
            folderModel.folder = configitem.configvalue
            activeFolder = folderModel.folder
            currentFolder = folderModel.folder
            setcurrentFolder()
            configitem = DBcore.readConfig("lastsong")
            filePlaying = configitem.configvalue
            songPlayer.source = configitem.configvalue
            configitem = DBcore.readConfig("lastposition")
            lastPosition = configitem.configvalue
            configitem = DBcore.readConfig("lastindex")
            indexPlaying = configitem.configvalue

            // set timer to auto resume play
            songPlayer.play()
            timerAutoplay.start()
        }
    }

    // State machine to handle portrait/landscape orientation
    states: [
        State {
            name: "LANDSCAPE"; when: (screen.currentOrientation == Screen.Landscape)
            StateChangeScript { script: setcurrentFolder(); }
            },
        State {
            name: "PORTRAIT"; when: (screen.currentOrientation == Screen.Portrait)
            StateChangeScript { script: setcurrentFolder(); }
            }
    ]

} // end page
