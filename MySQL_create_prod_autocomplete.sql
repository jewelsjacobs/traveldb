use eanprod;

drop table if exists eanprod.autocomplete;

create table eanprod.autocomplete
	select
	RegionID as id,
	RegionName as text from
		(
			select
			c.RegionID,
			c.RegionName
			from eanprod.citycoordinateslist c
			union
			select
			p.RegionID,
			p.RegionName
			from eanprod.pointsofinterestcoordinateslist p
			union
			select
			r.RegionID,
			r.RegionName
			from eanprod.regioncentercoordinateslist r
		)
		results;

create index idx_autocomplete_text ON autocomplete ( text ) ;


