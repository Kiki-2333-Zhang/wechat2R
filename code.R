# Data Input
#reference https://cran.r-project.org/web/packages/DBI/DBI.pdf
setwd("backup file path")
library(RSQLite)
library(DBI)
con <- dbConnect(SQLite(),"Manifest.db")
dbListTables(con)
files <- dbReadTable(con, "Files")
dbDisconnect(con)
head(files,10)
wechat <- files[grep("tencent.xin", files$domain),]
rm(files)
temp <- wechat[grep("DB", wechat$relativePath),]
temp$relativePath # could be simplify
temp2 <- temp[ - grep("IndexedDB", temp$relativePath),]
rm(temp)
hash <- substring(temp2$relativePath[1], 11, 42)
contactPath <- paste0("Documents/", hash, "/DB/WCDB_Contact.sqlite")
messagePath <- paste0("Documents/", hash, "/DB/MM.sqlite")
contactName <- temp2$fileID[temp2$relativePath == contactPath]
messageName <- temp2$fileID[temp2$relativePath == messagePath]

# copy from https://www.ouq.net/%E5%88%A9%E7%94%A8r%E8%AF%AD%E8%A8%80%E6%89%B9%E9%87%8F%E5%88%9B%E5%BB%BA%E3%80%81%E7%A7%BB%E5%8A%A8%E3%80%81%E5%88%A0%E9%99%A4%E3%80%81%E4%BF%AE%E6%94%B9%E6%96%87%E4%BB%B6.html
dir.create("wechat_file")
file.copy(paste0(substring(contactName, 1, 2), "/", contactName), "wechat_file")
file.copy(paste0(substring(messageName, 1, 2), "/", messageName), "wechat_file")
setwd("wechat_file")
file.rename(contactName, "contact_sms.db")
file.rename(messageName, "message_sms.db")

con.contact <- dbConnect(SQLite(), "contact_sms.db")
con.message <- dbConnect(SQLite(), "message_sms.db")
#dbListTables(con.contact)
#dbListTables(con.message)
ttt <- dbReadTable(con.message, "Chat_cee1d10da5bd9d85b41c7c4e24a14e1e")
head(ttt,40)
