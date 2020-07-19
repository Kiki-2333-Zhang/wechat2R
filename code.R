# Data Input
# reference https://cran.r-project.org/web/packages/DBI/DBI.pdf
setwd("E:/Apple/Backup/9a2f1f18fdfde6cc8bf02094182914dbca324449")
library(RSQLite)
library(DBI)
con <- dbConnect(SQLite(),"Manifest.db")
dbListTables(con)
files <- dbReadTable(con, "Files")
dbDisconnect(con)
# get information about tencent wechat
wechat <- files[grep("tencent.xin", files$domain),]
temp <- wechat[grep("DB", wechat$relativePath),]
temp <- temp[ - grep("IndexedDB", temp$relativePath),]
hash <- substring(temp$relativePath[1], 11, 42)
contactPath <- paste0("Documents/", hash, "/DB/WCDB_Contact.sqlite")
messagePath <- paste0("Documents/", hash, "/DB/MM.sqlite")
emoticonPath <- paste0("Documents/", hash, "/Emoticon/DB/Emoticon.sqlite")
contactName <- temp$fileID[temp$relativePath == contactPath]
messageName <- temp$fileID[temp$relativePath == messagePath]
emoticonName <- temp$fileID[temp$relativePath == emoticonPath]

# reference https://www.ouq.net/%E5%88%A9%E7%94%A8r%E8%AF%AD%E8%A8%80%E6%89%B9%E9%87%8F%E5%88%9B%E5%BB%BA%E3%80%81%E7%A7%BB%E5%8A%A8%E3%80%81%E5%88%A0%E9%99%A4%E3%80%81%E4%BF%AE%E6%94%B9%E6%96%87%E4%BB%B6.html
dir.create("wechat_file")
file.copy(paste0(substring(contactName, 1, 2), "/", contactName), "wechat_file")
file.copy(paste0(substring(messageName, 1, 2), "/", messageName), "wechat_file")
file.copy(paste0(substring(emoticonName, 1, 2), "/", emoticonName), "wechat_file")
setwd("wechat_file")
file.rename(contactName, "contact_sms.db")
file.rename(messageName, "message_sms.db")
file.rename(emoticonName, "emoticon_sms.db")
rm(contactName, contactPath, emoticonName, emoticonPath, hash, messageName, messagePath)

#check contact
con.contact <- dbConnect(SQLite(), "contact_sms.db")
dbListTables(con.contact)
# CRT <- dbReadTable(con.contact, "ChatRoomTool_WeApp")   # nothing
# CSMT <- dbReadTable(con.contact, "ContactSendMsgTicket")   # nothing
friend <- dbReadTable(con.contact, "Friend")
# MSC <- dbReadTable(con.contact, "MassSendContact")  # nothing
# OIC <- dbReadTable(con.contact, "OpenIMContact")   # nothing

#check message
con.message <- dbConnect(SQLite(), "message_sms.db")
chat.list <- as.list(dbListTables(con.message))  # 1063 and later is overall message
chat.list[[1076]]
MessageBizExtTable <- dbReadTable(con.message, "MessageBizExtTable")
sqlite_sequence <- dbReadTable(con.message, "sqlite_sequence")
# BCT4 <- dbReadTable(con.message, "BottleContactTable4")   # nothing
# BT4 <- dbReadTable(con.message, "BottleTable4")  # nothing


# check emoticon
# con.emoticon <- dbConnect(SQLite(), "emoticon_sms.db")
# dbListTables(con.emoticon)
# emoticon1 <- dbReadTable(con.emoticon, "Emoticon1") #don't know what it is
# emoticonPack <- dbReadTable(con.emoticon, "EmoticonPackage05") # meme package

random_chat.1 <- dbReadTable(con.message, "Chat_cee1d10da5bd9d85b41c7c4e24a14e1e")   ## later is MD5 of 17699590841@chatroom

