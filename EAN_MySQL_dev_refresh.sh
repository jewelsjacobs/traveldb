#!/bin/bash
#########################################################################
## Process tested in Windows, using Cygwin                             ##
## other than the default of the instalation you will need to install: ##
## -> wget                                                             ##
## -> unzip                                                            ##
## -> database client MySQL                                            ##
## you can select by searching for them in the Cygwin packages during  ##
## the install.                                                        ##
#########################################################################

### Environment ###
STARTTIME=$(date +%s)
## for Linux: CHKSUM_CMD=md5sum
## cksum should be available in all Unix versions
CHKSUM_CMD=md5sum
MYSQL_DIR=/usr/local/mysql/bin/
# for simplicity I added the MYSQL bin path to the Windows 
# path environment variable, for Windows set it to ""
#MYSQL_DIR=""
#MySQL user, password, host (Server)
MYSQL_USER=root
MYSQL_PASS=
MYSQL_HOST=localhost
MYSQL_DB=eanprod
PROJECT_DIR=/Users/jjacobs/WebstormProjects/traveldb/
# home directory of the user (in our case "eanuser")
HOME_DIR=/Users/jjacobs
# protocol TCP All, SOCKET Unix only, PIPE Windows only, MEMORY Windows only
MYSQL_PROTOCOL=SOCKET
# 3336 as default,MAC using MAMP is 8889
MYSQL_PORT=3306
## directory under HOME_DIR
FILES_DIR=eanfiles
## Import files ###
#####################################
# the list should match the tables ##
# created by create_ean.sql script ##
#####################################
#LANG=ja_JP
FILES=(
ActivePropertyList
AirportCoordinatesList
AliasRegionList
AreaAttractionsList
AttributeList
ChainList
CityCoordinatesList
CountryList
DiningDescriptionList
GDSAttributeList
GDSPropertyAttributeLink
HotelImageList
NeighborhoodCoordinatesList
ParentRegionList
PointsOfInterestCoordinatesList
PolicyDescriptionList
PropertyAttributeLink
PropertyDescriptionList
PropertyTypeList
RecreationDescriptionList
RegionCenterCoordinatesList
RegionEANHotelIDMapping
RoomTypeList
SpaDescriptionList
WhatToExpectList
#ActivePropertyList_${LANG}
#AliasRegionList_${LANG}
#AreaAttractionsList_${LANG}
#AttributeList_${LANG}
#CountryList_${LANG}
#DiningDescriptionList_${LANG}
#PolicyDescriptionList_${LANG}
#PropertyAttributeLink_${LANG}
#PropertyDescriptionList_${LANG}
#PropertyTypeList_${LANG}
#RecreationDescriptionList_${LANG}
#RegionList_${LANG}
#RoomTypeList_${LANG}
#SpaDescriptionList_${LANG}
#WhatToExpectList_${LANG}
#
# minorRev=25 added files
#
PropertyLocationList
PropertyAmenitiesList
PropertyRoomsList
PropertyBusinessAmenitiesList
PropertyNationalRatingsList
PropertyFeesList
PropertyMandatoryFeesList
PropertyRenovationsList
)

## home where the process will execute
#cd C:/data/EAN/DEV/database
## this will be CRONed so it needs the working directory absolute path
## change to your user home directory
cd ${HOME_DIR}

echo "Starting at working directory..."
pwd
## create subdirectory if required
if [ ! -d ${FILES_DIR} ]; then
   echo "creating download files directory..."
   mkdir ${FILES_DIR}
fi

## all clear, move into the working directory
cd ${FILES_DIR}

### Parameters that you may need:
### If you use LOW_PRIORITY, execution of the LOAD DATA statement is delayed until no other clients are reading from the table.
CMD_MYSQL="${MYSQL_DIR}mysql  --local-infile=1 --default-character-set=utf8 --protocol=${MYSQL_PROTOCOL} --port=${MYSQL_PORT} --user=${MYSQL_USER} --host=${MYSQL_HOST} --database=${MYSQL_DB}"

echo "Downloading files using wget..."
for FILE in ${FILES[@]}
do
	### Download Data ###
    ## capture the current file checksum
	if [ -e ${FILE}.zip ]; then
		echo "File exist $FILE.zip..."
    	CHKSUM_PREV=`$CHKSUM_CMD $FILE.zip | cut -f1 -d' '`
    else
    	CHKSUM_PREV=0   
	fi
    ## download the files via HTTP (no need for https), using time-stamping, -nd no host directories
    wget  -t 30 --no-verbose -r -N -nd http://www.ian.com/affiliatecenter/include/V2/$FILE.zip
    CHKSUM_NOW=`$CHKSUM_CMD $FILE.zip | cut -f1 -d' '`
    ## check if we need to update or not based on file changed
    if [ "$CHKSUM_PREV" != "$CHKSUM_NOW" ]; then
    	echo "Update, checksum change ($CHKSUM_PREV) to ($CHKSUM_NOW) on file ($FILE.zip)..."
    	## unzip the files
    	unzip -L `find . -iname $FILE.zip`
    	## rename files to CamelCase format
    	mv `echo $FILE | tr \[A-Z\] \[a-z\]`.txt $FILE.txt

   		### Update MySQL Data ###
   		## table name are lowercase
   		tablename=`echo $FILE | tr "[[:upper:]]" "[[:lower:]]"`
   		echo "Uploading ($FILE) to ($MYSQL_DB.$tablename) with REPLACE option..."
   		## let's try with the REPLACE OPTION
   		$CMD_MYSQL --execute="LOAD DATA LOCAL INFILE '$FILE.txt' REPLACE INTO TABLE $tablename CHARACTER SET utf8 FIELDS TERMINATED BY '|' IGNORE 1 LINES;"
   		## we need to erase the records, NOT updated today
   		echo "erasing old records from ($tablename)..."
   		$CMD_MYSQL --execute="DELETE FROM $tablename WHERE datediff(TimeStamp, now()) < 0;"
    fi
done
echo "Updates done."

echo "Running Stored Procedures..."
### Run stored procedures as required for extra functionality       ###
### you can use this section for your own stuff                     ###
CMD_MYSQL="${MYSQL_DIR}mysql  --default-character-set=utf8 --protocol=${MYSQL_PROTOCOL} --port=${MYSQL_PORT} --user=${MYSQL_USER} --host=${MYSQL_HOST} --database=eanextras"
$CMD_MYSQL --execute="CALL eanextras.sp_fill_fasttextsearch();"
### create a new link table that contain the regular ChainList association
### and add records that where blank by matching the name of the Chain to the Property Name
$CMD_MYSQL --execute="CALL eanextras.sp_fill_chainlistlink();"
echo "Stored Procedures done."


echo "Verify database against files..."
### Verify entries in tables against files ###
CMD_MYSQL="${MYSQL_DIR}mysqlshow --count ${MYSQL_DB} --protocol=${MYSQL_PROTOCOL} --port=${MYSQL_PORT} --user=${MYSQL_USER} --host=${MYSQL_HOST}"
$CMD_MYSQL

### find the amount of records per datafile
### should match to the amount of database records
echo "+---------------------------------+----------+------------+"
echo "|             File                |       Records         |"
echo "+---------------------------------+----------+------------+"
for FILE in ${FILES[@]}
do
## to count the number of output records minus the header
##    records=$(($(wc -l $FILE.txt | awk '{print $1}')-1))
   records=`wc -l < $FILE.txt | tr -d ' '`
   (( records-- ))
   { printf "|" && printf "%33s" $FILE && printf "|" && printf "%23d" $records && printf "|\n"; }
done
echo "+---------------------------------+----------+------------+"
echo "Verify done."


echo "script (import_db.sh) done."

## display endtime for the script
ENDTIME=$(date +%s)
secs=$(( $ENDTIME - $STARTTIME ))
h=$(( secs / 3600 ))
m=$(( ( secs / 60 ) % 60 ))
s=$(( secs % 60 ))
printf "total script time: %02d:%02d:%02d\n" $h $m $s

## create autocomplete table
${MYSQL_DIR}mysql < ${PROJECT_DIR}MySQL_create_dev_autocomplete.sql --verbose
