	create proc Geo.Sp_geography_insert 
		@line1 varchar(250),
		@line2 varchar(250),
		@longitude float,
		@lattitude float,
		@city varchar(100),
		@district varchar(100),
		@state varchar(100),
		@country varchar(100)
	as
	begin
		declare @countryid int,
				@stateid int,
				@districtid int,
				@cityid int
			
			select @countryid = country_id 
			from Geo.country
			where country = @country

			select @stateid = state_id
			from Geo.state
			where state = @state

			select @districtid = district_id
			from Geo.District
			where district = @district

			select @cityid = city_id
			from Geo.city
			where city = @city


			merge into Geo.country as tgt
			using (select @country as country) as src
				on tgt.country = src.country

			when matched then
			update set tgt.country = src.country

			when not matched then 
			insert (country)
			values (src.country);


			merge into Geo.state as tgt
			using (select @state as state,
						  @countryid as country_id) as src
				on tgt.state = src.state and
				   tgt.country_id = src.country_id
				
			when matched then
			update set tgt.state = src.state,
					   tgt.country_id = src.country_id
			
			when not matched then 
			insert (state,
					country_id)
			values (src.state,
					src.country_id);


			merge into Geo.district as tgt
			using (select @district as district,
						  @stateid as state_id) as src
				on tgt.district = src.district and
				   tgt.state_id = src.state_id

			when matched then
			update set tgt.district = src.district,
					   tgt.state_id = src.state_id

			when not matched then 
			insert (district,
					state_id)
			values (src.district,
					src.state_id);


			merge into Geo.city as tgt
			using (select @city as city,
						  @districtid as district_id) as src
				on tgt.city = src.city and
				   tgt.district_id = src.district_id

			when matched then
			update set tgt.city = src.city,
					   tgt.district_id = src.district_id

			when not matched then 
			insert (city,
					district_id)
			values (src.city,
					src.district_id);


			merge into Geo.address as tgt
			using (select  @line1 as line_1,
						   @line2 as line_2,
						   @longitude as longitude,
						   @lattitude as lattitude,
						   @cityid as city_id
						   ) as src
				on tgt.line_1 = src.line_1 and
				   tgt.line_2 = src.line_2 and
				   tgt.longitude = src.longitude and
				   tgt.lattitude = src.lattitude and
				   tgt.city_id = src.city_id

			when matched then
			update set  tgt.line_1 = src.line_1,
						tgt.line_2 = src.line_2,
						tgt.longitude = src.longitude,
						tgt.lattitude = src.lattitude,
						tgt.city_id = src.city_id

			when not matched then 
			insert (line_1,
					line_2,
					longitude,
					lattitude,
					city_id)
			values (src.line_1,
					src.line_2,
					src.longitude,
					src.lattitude,
					src.city_id);

	end
		





