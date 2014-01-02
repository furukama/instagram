#-------------------------------------------------------------------
# Downloading Instagram pictures for a hashtag or location
# Benedikt Koehler, 2013
# @furukama
#-------------------------------------------------------------------

library(RCurl)
library(RJSONIO)

# Login credentials
token <- "" # API key for Instagram API goes here

# Search data: either hashtag or location
hashtag <- "winter"
lat <- "48.14384"
lng <- "11.578259"

# Search parameters
p <- 10
limit <- as.numeric(Sys.time())
today <- format(Sys.time(), "%Y-%m-%d")
imgdir <- paste(getwd(), "/", today, "-", hashtag, sep="")
dir.create(imgdir)

if (hashtag != "") {
    api <- paste("https://api.instagram.com/v1/tags/", hashtag, "/media/recent?access_token=", token, sep="")
} else if (lat != "") {
    api <- paste("https://api.instagram.com/v1/media/search?lat=", lat, "&lng=", lng, "&access_token=", token, "&max_timestamp=", limit, sep="")
}

for (i in 1:p) {
    print(api)
    raw_data <- getURL(api, ssl.verifypeer = FALSE)
    data <- fromJSON(raw_data)
    url <- lapply(data$data, function(x) c(x$images$thumbnail$url))
    api <- data$pagination["next_url"]

    for (u in 1:length(url)) {
        id <- data$data[u][[1]]$id
        temp <- paste(imgdir, "/", id, ".jpg", sep="")
        download.file(url[[u]], temp, mode="wb")
    }
}
