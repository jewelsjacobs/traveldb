########################################################
## MySQL_create_eanprod.sql                      v2.5 ##
## SCRIPT TO GENERATE EAN DATABASE IN MYSQL ENGINE    ##
## BE CAREFUL AS IT WILL ERASE THE EXISTING DATABASE  ##
## YOU CAN USE SECTIONS OF IT TO RE-CREATE TABLES     ##
## WILL CREATE USER: eanuser / expedia                ##
## table names are lowercase so it will work  in all  ## 
## platforms the same.                                ##
########################################################

DROP DATABASE IF EXISTS eanprod;
## specify utf8 / ut8_unicode_ci to manage all languages properly
## updated from files contain those characters
CREATE DATABASE eanprod CHARACTER SET utf8 COLLATE utf8_unicode_ci;

## users permisions
GRANT ALL ON eanprod.* TO 'eanuser'@'%' IDENTIFIED BY 'Passw@rd1';
GRANT ALL ON eanprod.* TO 'eanuser'@'localhost' IDENTIFIED BY 'Passw@rd1';

## REQUIRED IN WINDOWS as we do not use STRICT_TRANS_TABLE for the upload process
SET @@global.sql_mode= '';

USE eanprod;

########################################################
##                                                    ##
## TABLES CREATED FROM THE EAN RELATIONAL DOWNLOADED  ##
## FILES.                                             ##
##                                                    ##
########################################################

DROP TABLE IF EXISTS airportcoordinateslist;
CREATE TABLE airportcoordinateslist
(
	AirportID INT NOT NULL,
	AirportCode VARCHAR(3) NOT NULL,
	AirportName VARCHAR(70),
	Latitude numeric(9,6),
	Longitude numeric(9,6),
	MainCityID INT,
	CountryCode VARCHAR(2),
  TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (AirportCode)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;

## index by Airport Name to use for text searches
CREATE INDEX idx_airportcoordinatelist_airportname ON airportcoordinateslist(AirportName);
## index by MainCityID to use as relational key
CREATE INDEX idx_airportcoordinatelist_maincityid ON airportcoordinateslist(MainCityID);


DROP TABLE IF EXISTS activepropertylist;
CREATE TABLE activepropertylist
(
	EANHotelID INT NOT NULL,
	SequenceNumber INT,
	Name VARCHAR(70),
	Address1 VARCHAR(50),
	Address2 VARCHAR(50),
	City VARCHAR(50),
	StateProvince VARCHAR(2),
	PostalCode VARCHAR(15),
	Country VARCHAR(2),
	Latitude numeric(8,5),
	Longitude numeric(8,5),
	AirportCode VARCHAR(3),
	PropertyCategory INT,
	PropertyCurrency VARCHAR(3),
	StarRating numeric(2,1),
	Confidence INT,
	SupplierType VARCHAR(3),
	Location VARCHAR(80),
	ChainCodeID VARCHAR(5),
	RegionID INT,
	HighRate numeric(19,4),
	LowRate numeric(19,4),
	CheckInTime VARCHAR(10),
	CheckOutTime VARCHAR(10),
  TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (EANHotelID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;


DROP TABLE IF EXISTS pointsofinterestcoordinateslist;
CREATE TABLE pointsofinterestcoordinateslist
(
	RegionID INT NOT NULL,
	RegionName VARCHAR(255),
## as it will be the key need to be less than 767 bytes (767 / 4 = 191.75)  
	RegionNameLong VARCHAR(191),
	Latitude numeric(9,6),
	Longitude numeric(9,6),
	SubClassification VARCHAR(20),
  TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (RegionNameLong)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;

## index by RegionID to use as relational key
CREATE INDEX idx_pointsofinterestcoordinateslist_regionid ON pointsofinterestcoordinateslist(RegionID);


DROP TABLE IF EXISTS countrylist;
CREATE TABLE countrylist
(
	CountryID INT NOT NULL,
	LanguageCode VARCHAR(5),
	CountryName VARCHAR(255),
	CountryCode VARCHAR(2) NOT NULL,
	Transliteration VARCHAR(255),
	ContinentID INT,
  TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (CountryID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;

## add indexes by country code & country name
CREATE INDEX idx_countrylist_countrycode ON countrylist(CountryCode);
CREATE INDEX idx_countrylist_countryname ON countrylist(CountryName);


DROP TABLE IF EXISTS propertytypelist;
CREATE TABLE propertytypelist
(
	PropertyCategory INT NOT NULL,
	LanguageCode VARCHAR(5),
	PropertyCategoryDesc VARCHAR(255),
  TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (PropertyCategory)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;


DROP TABLE IF EXISTS chainlist;
CREATE TABLE chainlist
(
	ChainCodeID INT NOT NULL,
	ChainName VARCHAR(30),
  TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (ChainCodeID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;


DROP TABLE IF EXISTS propertydescriptionlist;
CREATE TABLE propertydescriptionlist
(
	EANHotelID INT NOT NULL,
	LanguageCode VARCHAR(5),
	PropertyDescription TEXT,
  TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (EANHotelID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;


DROP TABLE IF EXISTS policydescriptionlist;
CREATE TABLE policydescriptionlist
(
	EANHotelID INT NOT NULL,
	LanguageCode VARCHAR(5),
	PolicyDescription TEXT,
  TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (EANHotelID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;


DROP TABLE IF EXISTS recreationdescriptionlist;
CREATE TABLE recreationdescriptionlist
(
	EANHotelID INT NOT NULL,
	LanguageCode VARCHAR(5),
	RecreationDescription TEXT,
  TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (EANHotelID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;


DROP TABLE IF EXISTS areaattractionslist;
CREATE TABLE areaattractionslist
(
	EANHotelID INT NOT NULL,
	LanguageCode VARCHAR(5),
	AreaAttractions TEXT,
  TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (EANHotelID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;


DROP TABLE IF EXISTS diningdescriptionlist;
CREATE TABLE diningdescriptionlist
(
	EANHotelID INT NOT NULL,
	LanguageCode VARCHAR(5),
	DiningDescription TEXT,
    TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (EANHotelID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;

DROP TABLE IF EXISTS spadescriptionlist;
CREATE TABLE spadescriptionlist
(
	EANHotelID INT NOT NULL,
	LanguageCode VARCHAR(5),
	SpaDescription TEXT,
  TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (EANHotelID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;


DROP TABLE IF EXISTS whattoexpectlist;
CREATE TABLE whattoexpectlist
(
	EANHotelID INT NOT NULL,
	LanguageCode VARCHAR(5),
	WhatToExpect TEXT,
  TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (EANHotelID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;


## Multiple rooms per each hotel - so a compound primary key
DROP TABLE IF EXISTS roomtypelist;
CREATE TABLE roomtypelist
(
	EANHotelID INT NOT NULL,
	RoomTypeID INT NOT NULL,
	LanguageCode VARCHAR(5),
	RoomTypeImage VARCHAR(255),
	RoomTypeName VARCHAR(200),
	RoomTypeDescription TEXT,
  TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (EANHotelID, RoomTypeID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;


DROP TABLE IF EXISTS attributelist;
CREATE TABLE attributelist
(
	AttributeID INT NOT NULL,
	LanguageCode VARCHAR(5),
	AttributeDesc VARCHAR(255),
	Type VARCHAR(15),
	SubType VARCHAR(15),
  TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (AttributeID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;


DROP TABLE IF EXISTS propertyattributelink;
CREATE TABLE propertyattributelink
(
	EANHotelID INT NOT NULL,
	AttributeID INT NOT NULL,
	LanguageCode VARCHAR(5),
	AppendTxt VARCHAR(191),
  TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
## table so far do not present the same problem as GDSpropertyattributelink
	PRIMARY KEY (EANHotelID, AttributeID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;



DROP TABLE IF EXISTS gdsattributelist;
CREATE TABLE gdsattributelist
(
	AttributeID INT NOT NULL,
	LanguageCode VARCHAR(5),
	AttributeDesc VARCHAR(255),
	Type VARCHAR(15),
	SubType VARCHAR(15),
  TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (AttributeID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;

DROP TABLE IF EXISTS gdspropertyattributelink;
CREATE TABLE gdspropertyattributelink
(
	EANHotelID INT NOT NULL,
	AttributeID INT NOT NULL,
	LanguageCode VARCHAR(5),
	AppendTxt VARCHAR(191),
  TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
## need all those fields to make a uniquekey
	PRIMARY KEY (EANHotelID, AttributeID, AppendTxt)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;


########### Image Data ####################
## there are multiple images for an hotel 
## even with the same caption
## to make a unique index we need to use
## the URL instead

DROP TABLE IF EXISTS hotelimagelist;
CREATE TABLE hotelimagelist
(
	EANHotelID INT NOT NULL,
	Caption VARCHAR(70),
## URLs are now max 80 chars
	URL VARCHAR(150) NOT NULL,
	Width INT,
	Height INT,
	ByteSize INT,
	ThumbnailURL VARCHAR(300),
	DefaultImage bit,
  TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (URL)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE INDEX idx_hotelimagelist_eanhotelid ON hotelimagelist(EANHotelID);

########## Geography Data ###################

DROP TABLE IF EXISTS citycoordinateslist;
CREATE TABLE citycoordinateslist
(
	RegionID INT NOT NULL,
	RegionName VARCHAR(255),
	Coordinates TEXT,
  TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (RegionID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;


## table to correct search term for a region
## notice there are NO spaces between words
DROP TABLE IF EXISTS aliasregionlist;
CREATE TABLE aliasregionlist
(
	RegionID INT NOT NULL,
	LanguageCode VARCHAR(5),
	AliasString VARCHAR(255),
  TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
## no primary key for this table, need to investigate 
##	PRIMARY KEY (RegionID, AliasString)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE INDEX idx_aliasregionid_regionid ON aliasregionlist(RegionID);


DROP TABLE IF EXISTS parentregionlist;
CREATE TABLE parentregionlist
(
	RegionID INT NOT NULL,
	RegionType VARCHAR(50),
	RelativeSignificance VARCHAR(3),
	SubClass VARCHAR(50),
	RegionName VARCHAR(255),
	RegionNameLong VARCHAR(510),
	ParentRegionID INT,
	ParentRegionType VARCHAR(50),
	ParentRegionName VARCHAR(255),
	ParentRegionNameLong VARCHAR(510),
  TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (RegionID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;


DROP TABLE IF EXISTS neighborhoodcoordinateslist;
CREATE TABLE neighborhoodcoordinateslist
(
	RegionID INT NOT NULL,
	RegionName VARCHAR(255),
	Coordinates TEXT,
  TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (RegionID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;


DROP TABLE IF EXISTS regioncentercoordinateslist;
CREATE TABLE regioncentercoordinateslist
(
	RegionID INT NOT NULL,
	RegionName VARCHAR(255),
	CenterLatitude numeric(9,6),
	CenterLongitude numeric(9,6),
  TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (RegionID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;


DROP TABLE IF EXISTS regioneanhotelidmapping;
CREATE TABLE regioneanhotelidmapping
(
	RegionID INT NOT NULL,
	EANHotelID INT NOT NULL,
  TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (RegionID, EANHotelID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;

#########################################################
################ new files for minorRev=25 ##############
## PropertyLocationList (new)
## DiningDescriptionList
## PropertyAmenitiesList (new)
## PropertyRoomsList (new)
## PropertyBusinessAmenitiesList (new)
## PropertyNationalRatingsList (new)
## WhatToExpectList
## PropertyFeesList (new)
## PropertyMandatoryFeesList (new)
## PropertyRenovationsList (new)
## PropertyDescriptionList
## PolicyDescriptionList
#########################################################
DROP TABLE IF EXISTS propertylocationlist;
CREATE TABLE propertylocationlist
(
	EANHotelID INT NOT NULL,
	LanguageCode VARCHAR(5),
	LocationDescription TEXT,
    TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (EANHotelID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;

DROP TABLE IF EXISTS propertyamenitieslist;
CREATE TABLE propertyamenitieslist
(
	EANHotelID INT NOT NULL,
	LanguageCode VARCHAR(5),
	AmenitiesDescription TEXT,
    TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (EANHotelID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;

DROP TABLE IF EXISTS propertyroomslist;
CREATE TABLE propertyroomslist
(
	EANHotelID INT NOT NULL,
	LanguageCode VARCHAR(5),
	RoomsDescription TEXT,
    TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (EANHotelID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;

DROP TABLE IF EXISTS propertybusinessamenitieslist;
CREATE TABLE propertybusinessamenitieslist
(
	EANHotelID INT NOT NULL,
	LanguageCode VARCHAR(5),
	BusinessAmenitiesDesciption TEXT,
  TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (EANHotelID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;

DROP TABLE IF EXISTS propertynationalratingslist;
CREATE TABLE propertynationalratingslist
(
	EANHotelID INT NOT NULL,
	LanguageCode VARCHAR(5),
	NationalRatingsDescription TEXT,
    TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (EANHotelID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;

DROP TABLE IF EXISTS propertyfeeslist;
CREATE TABLE propertyfeeslist
(
	EANHotelID INT NOT NULL,
	LanguageCode VARCHAR(5),
	FeesDescription TEXT,
    TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (EANHotelID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;

DROP TABLE IF EXISTS propertymandatoryfeeslist;
CREATE TABLE propertymandatoryfeeslist
(
	EANHotelID INT NOT NULL,
	LanguageCode VARCHAR(5),
	MandatoryFeesDescription TEXT,
    TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (EANHotelID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;

DROP TABLE IF EXISTS propertyrenovationslist;
CREATE TABLE propertyrenovationslist
(
	EANHotelID INT NOT NULL,
	LanguageCode VARCHAR(5),
	RenovationsDescription TEXT,
  TimeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (EANHotelID)
) CHARACTER SET utf8 COLLATE utf8_unicode_ci;
