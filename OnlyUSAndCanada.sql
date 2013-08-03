USE eanprod ;

delete from activepropertylist
where
	Country ! = 'US' and
	Country ! = 'CA';

delete from airportcoordinateslist
where
	CountryCode ! = 'US' and
	CountryCode ! = 'CA';

delete from jewelsja_eanprod.activepropertylist
where
	SupplierType = 'ESR' and
	EANHotelID in (select
		               EANHotelID
	               from jewelsja_eanprod.regioneanhotelidmapping
	               where RegionID in (select
		                                  RegionID
	                                  from jewelsja_eanprod.regioncentercoordinateslist
	                                  where
		                                  RegionName not like '%Canada%' and
		                                  RegionName not like '%United States of America%'));

delete from jewelsja_eanprod.aliasregionlist
where RegionID in (select
	                   RegionID
                   from jewelsja_eanprod.regioncentercoordinateslist
                   where
	                   RegionName not like '%Canada%' and
	                   RegionName not like '%United States of America%');

delete from jewelsja_eanprod.areaattractionslist
where EANHotelID in (select
	                     EANHotelID
                     from jewelsja_eanprod.regioneanhotelidmapping
                     where RegionID in (select
	                                        RegionID
                                        from jewelsja_eanprod.regioncentercoordinateslist
                                        where
	                                        RegionName not like '%Canada%' and
	                                        RegionName not like '%United States of America%'));

delete from jewelsja_eanprod.citycoordinateslists
where RegionID in (select
	                   RegionID
                   from jewelsja_eanprod.regioncentercoordinateslist
                   where
	                   RegionName not like '%Canada%' and
	                   RegionName not like '%United States of America%');

delete from jewelsja_eanprod.countrylist
where
	CountryCode ! = 'CA' and
	CountryCode ! = 'US';

delete from jewelsja_eanprod.diningdescriptionlist
where EANHotelID in (select
	                     EANHotelID
                     from jewelsja_eanprod.regioneanhotelidmapping
                     where RegionID in (select
	                                        RegionID
                                        from jewelsja_eanprod.regioncentercoordinateslist
                                        where
	                                        RegionName not like '%Canada%' and
	                                        RegionName not like '%United States of America%'));

delete from jewelsja_eanprod.hotelimagelist
where EANHotelID in (select
	                     EANHotelID
                     from jewelsja_eanprod.regioneanhotelidmapping
                     where RegionID in (select
	                                        RegionID
                                        from jewelsja_eanprod.regioncentercoordinateslist
                                        where
	                                        RegionName not like '%Canada%' and
	                                        RegionName not like '%United States of America%'));

delete from jewelsja_eanprod.neighborhoodcoordinateslist
where RegionID in (select
	                   RegionID
                   from jewelsja_eanprod.regioncentercoordinateslist
                   where
	                   RegionName not like '%Canada%' and
	                   RegionName not like '%United States of America%');

delete from jewelsja_eanprod.parentregionlist
where RegionID in (select
	                   RegionID
                   from jewelsja_eanprod.regioncentercoordinateslist
                   where
	                   RegionName not like '%Canada%' and
	                   RegionName not like '%United States of America%');

delete from jewelsja_eanprod.pointsofinterestcoordinateslist
where
	RegionNameLong not like '%Canada%' and
	RegionNameLong not like '%United States of America%';

delete from jewelsja_eanprod.policydescriptionlist
where EANHotelID in (select
	                     EANHotelID
                     from jewelsja_eanprod.regioneanhotelidmapping
                     where RegionID in (select
	                                        RegionID
                                        from jewelsja_eanprod.regioncentercoordinateslist
                                        where
	                                        RegionName not like '%Canada%' and
	                                        RegionName not like '%United States of America%'));

delete from jewelsja_eanprod.propertyamenitieslist
where EANHotelID in (select
	                     EANHotelID
                     from jewelsja_eanprod.regioneanhotelidmapping
                     where RegionID in (select
	                                        RegionID
                                        from jewelsja_eanprod.regioncentercoordinateslist
                                        where
	                                        RegionName not like '%Canada%' and
	                                        RegionName not like '%United States of America%'));

