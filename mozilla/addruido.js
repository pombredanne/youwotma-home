
if(gFolderDisplay.selectedCount == 1){
    var uri = gFolderDisplay.selectedMessageUris[0];
    if(uri.indexOf("david%40bengoarocandio.com") >= 0){
        MsgMoveMessage(GetMsgFolderFromUri("imap://david%40bengoarocandio.com@imap.gmail.com/AddRuido"));
    }else if(uri.indexOf("youwotma%40mozilla-hispano.org") >= 0){
        MsgMoveMessage(GetMsgFolderFromUri("imap://youwotma%40mozilla-hispano.org@pop.gmail.com/AddRuido"));
    }
}

