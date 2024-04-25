#name: download_clc
#date: Feb 25 2024  
#author: Tillman Reuter
#R version: 4.3.2

# READ ME ######################################################################
'
automated download of Clorine Land Cover data
2000, 2006, 2012, and 2018
of Denmark, Germany, Sweden, Spain, and Portugal

' 
par(mfrow=c(1,1))
Sys.setenv(LANG = "en")
#Sys.setenv(LANG = "ger")

# LOAD AND INSTALL PACKAGES ####################################################

library(openssl)
library(jose)
library(jsonlite)
library(httr)
library(readr)
library(utils)
library(jsonlite)
library(terra)

#no working directory, I work directly in an R Project
#otherwise create a working directory

#setwd("")

'
manually create an account on https://land.copernicus.eu using EU-Login.
request an API token on your profile tab (https://land.copernicus.eu/en/profile#api_tokens).
copy the text of the API-token (it is only displayed once) in the line of code below between the ''.

'

# MAIN #########################################################################

# create json web token ########################################################

insert_copied_text_from_API_token <- 'here'

#write the text to a JSON file
write_json(insert_copied_text_from_API_token, "API_token_DETECT.json")

#now read in this token as a list of its content
service_key <- fromJSON("API_token_DETECT.json", flatten = TRUE)
#this file is the manually created API-Token on https://land.copernicus.eu/en/profile#api_tokens

private_key <- charToRaw(service_key$private_key)

claim <- jwt_claim(  iss = service_key$client_id,
                     sub = service_key$user_id,
                     aud = service_key$token_uri,
                     iat = as.integer(Sys.time()),
                     exp = as.integer(Sys.time() + 60 * 60)) #jwt will expire after 1 hour

# Encode with sig
jwt <- jwt_encode_sig(claim, key = service_key$private_key)


# create access token ##########################################################

#request body of POST request
request_body <- list(
  grant_type = "urn:ietf:params:oauth:grant-type:jwt-bearer",
  assertion = jwt #uses the above created json web token
)

#url to authenticate
url <- "https://land.copernicus.eu/@@oauth2-token"

payload <- paste0("grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Ajwt-bearer&assertion=",jwt)

encode <- "form"

response <- VERB("POST", url, body = payload, content_type("application/x-www-form-urlencoded"), accept("application/json"), encode = encode)

#take the access token out of the response (object of class request)
access_token <- content(response, "parsed")$access_token


# search for download info ###############################################################

#url of search endpoint to browse available datasets
url <- "https://land.copernicus.eu/api/@search?portal_type=DataSet&metadata_fields=UID&metadata_fields=dataset_full_format&&metadata_fields=dataset_download_information"

headers <- c(
  "Accept" = "application/json",
  "Authorization" = paste0("Bearer ", access_token)
)

response <- GET(
  url = url,
  add_headers(headers)
)

#write response of search in list
content <- content(response)$items

#search in this list for the datasets we want

#connect the urls of the dataset to an index in the list
index <- data.frame(id=c(0), url=c(0))
for(i in 1:length(content)){
  print(content[[i]]$'@id')
  index <- rbind(index, c(i, print(content[[i]]$'@id')))
}
index <- index[-1, ]

#search for entries that are of our interest
base_url <- "https://land.copernicus.eu/api/en/products/corine-land-cover/clc"

target_ids <- list(
  index$id[index$url==paste0(base_url, -2000)]
  ,index$id[index$url==paste0(base_url, -2006)]
  ,index$id[index$url==paste0(base_url, -2012)]
  ,index$id[index$url==paste0(base_url, -2018)|index$url==paste0(base_url, 2018)] #there is a typo in the name of the URL. We are prepared if they fix it
)

#extract dataset-specific download info for every dataset of interest (raster format)
UID_2000 <- content[[as.numeric(target_ids[1])]]$UID
id_2000 <- content[[as.numeric(target_ids[1])]]$dataset_download_info$items[[2]]$'@id'

UID_2006 <- content[[as.numeric(target_ids[2])]]$UID
id_2006 <- content[[as.numeric(target_ids[2])]]$dataset_download_info$items[[2]]$'@id'

UID_2012 <- content[[as.numeric(target_ids[3])]]$UID
id_2012 <- content[[as.numeric(target_ids[3])]]$dataset_download_info$items[[2]]$'@id'

UID_2018 <- content[[as.numeric(target_ids[4])]]$UID
id_2018 <- content[[as.numeric(target_ids[4])]]$dataset_download_info$items[[2]]$'@id'


# request download #############################################################

#url to request downloads to
url <- "https://land.copernicus.eu/api/@datarequest_post"

# Request headers
headers <- c(
  "Accept" = "application/json",
  "Authorization" = paste0("Bearer ", access_token) #try out different access tokens to see what works
)


desired_GCS <- "EPSG:4326"

## Function to create dataset list
create_datasets_list <- function(UID, id, nuts_codes, output_format = "Geotiff", output_GCS) {
  lapply(nuts_codes, function(nuts) {
    list(
      DatasetID = UID,
      DatasetDownloadInformationID = id,
      OutputFormat = output_format,
      OutputGCS = output_GCS,
      NUTS = nuts
    )
  })
}

## NUTS codes are the same for each request, so we define them once
nuts_codes <- c("DE", "PT", "SE", "ES", "DK")

## Now, we can create each request body with a single line of code
request_body_2000 <- list(Datasets = create_datasets_list(UID_2000, id_2000, nuts_codes, "Geotiff", desired_GCS))
request_body_2006 <- list(Datasets = create_datasets_list(UID_2006, id_2006, nuts_codes, "Geotiff", desired_GCS))
request_body_2012 <- list(Datasets = create_datasets_list(UID_2012, id_2012, nuts_codes, "Geotiff", desired_GCS))
request_body_2018 <- list(Datasets = create_datasets_list(UID_2018, id_2018, nuts_codes, "Geotiff", desired_GCS))


# for all 4 datasets:
# make the POST request
response <- POST(url, body = request_body_2000, encode = "json", add_headers(headers))
#extract TaskID
TaskID_2000 <- content(response)$TaskIds[[1]]$TaskID #download task ID

response <- POST(url, body = request_body_2006, encode = "json", add_headers(headers))
TaskID_2006 <- content(response)$TaskIds[[1]]$TaskID #download task ID

response <- POST(url, body = request_body_2012, encode = "json", add_headers(headers))
TaskID_2012 <- content(response)$TaskIds[[1]]$TaskID #download task ID

response <- POST(url, body = request_body_2018, encode = "json", add_headers(headers))
TaskID_2018 <- content(response)$TaskIds[[1]]$TaskID #download task ID


# status of download request ###############################################################

#url to check progress on download requests
url <- "https://land.copernicus.eu/api/@datarequest_search?"

headers <- c(
  "Accept" = "application/json",
  "Authorization" = paste0("Bearer ", access_token)
)

response <- GET(
  url = url,
  add_headers(headers)
)

task.ids <- c("TaskID_2000", "TaskID_2006", "TaskID_2012", "TaskID_2018") # mit punkt ist globale, mit unterstrich lokale variable
task.status <- setNames(rep(NA, length(task.ids)), task.ids)
#task.status <- setNames(rep(NA, length(task_ids)), task_ids) das untere ist von moritz, aber damit allein klappts nicht, weil es task_ids nocht nicht gibt

# Function to update task status
update_task_status <- function(task_status, task_ids) {
  for (task_id in names(task_status)) {
    response <- GET(
                    url = url,
                    add_headers(headers)
                   ) #this also makes a request to not check the old response again and again
    task_status[[task_id]] <- content(response)[[get(task_id)]]$Status
  }
  print(task_status)
  task.status <<- task_status
}

# Function to check if all tasks are no longer queued
all_tasks_completed <- function(task_status) {
  # Check if any task is still in 'queued' status
  !any(task_status == "Queued"|task_status == "In_Progress"|task_status == "In Progress")
}

## Main loop to check task status every 300 seconds
repeat {
  update_task_status(task_status = task.status, task_ids = task.ids)

  if (all_tasks_completed(task_status = task.status)) {
    break # Exit loop if all tasks are completed or failed
  } else {
    Sys.sleep(300) # Wait for 5 minutes before checking again
  }
}

#based on experience, it can sometimes easily take 24 hours before downloads are ready. Since the access tokens
#expire much faster, and the loop breaks. You might have to do the steps starting with writing the jwt_claim until writing the
#access-token again before proceeding. You can also not use the above loop but instead wait for an e-mail notifying you, that 
#your downloads are finished. Then, renew your access-token and proceed from here.

#url to find successfully processed data requests
url <- "https://land.copernicus.eu/api/@datarequest_search?status=Finished_ok"

headers <- c(
  "Accept" = "application/json",
  "Authorization" = paste0("Bearer ", access_token)
)

response <- GET(
  url = url,
  add_headers(headers)
)

# extract download links for all 4 datasets
download_url_2000 <- content(response)[[TaskID_2000]]$DownloadURL
download_url_2006 <- content(response)[[TaskID_2006]]$DownloadURL
download_url_2012 <- content(response)[[TaskID_2012]]$DownloadURL
download_url_2018 <- content(response)[[TaskID_2018]]$DownloadURL


# download and unzip the files ##################################################

manage_files <- function(dir, dataset_name, download_url){
  # Structure
  dir.create(dir)
  
  data_dir <- paste0(dir, "/01_Data")
  dir.create(data_dir)
  
  doc_dir <- paste0(dir, "/02_Documentation")
  dir.create(doc_dir)
  
  # Download the .zip file
  file <- file.path(dir, "file.zip")
  download_url <- get(paste0("download_url_", dir))
  GET(url = download_url, write_disk(file, overwrite=T))
  
  # Unzip the file
  unzip(file, exdir = dir)
  file.remove(file)
  
  # Data
  file.copy(from = list.files(paste0(dir, "/Results/", dataset_name, "/", dataset_name), full.names = T, recursive=T), to = data_dir)
  
  # Documentation
  file <- paste0(dir,"/Results/", dataset_name, "_raster100m_tiled_doc.zip")
  unzip(file, exdir = dir)
  file.remove(file)
  
  file.copy(from = list.files(paste0(dir, "/Info/Documents/Raster"), full.names = T, recursive=T), to = doc_dir)
  file.copy(from = list.files(paste0(dir, "/Info/Legend/Raster"), full.names = T, recursive=T), to = doc_dir)
  file.copy(from = list.files(paste0(dir, "/Info/Metadata"), full.names = T, recursive=T), to = doc_dir)
  
  # Clean up
  unlink(paste0(dir, "/Info"), recursive=T)
  unlink(paste0(dir, "/Results"), recursive=T)
  
}

manage_files("2000", "U2006_CLC2000_V2020_20u1")
manage_files("2006", "U2012_CLC2006_V2020_20u1")
manage_files("2012", "U2018_CLC2012_V2020_20u1")
manage_files("2018", "U2018_CLC2018_V2020_20u1")

# importing tif files, obtaining legends, checking for errors ##################
  
#import tifs
CLC2000 <- rast("2000/01_Data/U2006_CLC2000_V2020_20u1.tif")
CLC2006 <- rast("2006/01_Data/U2012_CLC2006_V2020_20u1.tif")
CLC2012 <- rast("2012/01_Data/U2018_CLC2012_V2020_20u1_raster100m.tif") #beware, maybe file name will be changed somtime
CLC2018 <- rast("2018/01_Data/U2018_CLC2018_V2020_20u1.tif")

#extract legend
legend <- readLines("2000/02_Documentation/CLC2006_CLC2000_V2018_20_QGIS.txt")
legend <- legend[-c(1:2)]

# extract relevant info from legend into a data.frame of land cover codes 1:45
legend_df <- data.frame(code=c(0), cover=c(0)) #data.frame with dummy row to preserve colnames
for(i in 1:length(legend)){
  name <- sub(".*?- ", "", legend[i])
  legend_df <- rbind(legend_df, c(i, name))
}
legend_df <- legend_df[-1,] #deletes the dummy row

# function to extract land cover for data.frame of coordinates 
land_cover_of_coordinates <- function(coordinates){
  values <- extract(CLC2000, coordinates)
  coordinates$code <- values[,2]
  coordinates2 <- merge(coordinates, legend_df, by="code")
  return(coordinates2)
  
}

# use function on example coordinates
coordinates <- data.frame(x=c(0.04,0.01,-0.02,-0.05,-0.08), y=c(40.07,40.04,40.01,39.98,39.95))
values <- land_cover_of_coordinates(coordinates)



#check, if script has worked (using CLC2000 for Spain)
if(identical(as.numeric(values$code), c(2, 16, 16, 28, 30))){
  print("Automated download was successfull, you can find your files in the folders called '2000' etc. Refer to the README_global, which is provided with this code. There you find information about the datasets, citation etc.")
} else {
  warning("Some error has occured along the process. To find the problem go to your account on https://land.copernicus.eu/en/all-downloads and check if downloads have been requested and what their status is. Next, check if the file structure is appropriate. Check if you can load the raster files manually and if they contain Land Cover Codes from 1 to 45 and your desired spatial extent (this code checks for values in Spain)")
}
