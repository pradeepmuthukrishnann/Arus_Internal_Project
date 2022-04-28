
	create or alter proc Org.Sp_branch_insert
		@company varchar(250),
		@branch varchar(250),
		@email varchar(250),
		@contact varchar(50),
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
		
		declare
			@companyid int,
			@addressid int

			select @companyid = company_id
			from Org.company
			where company = @company

			select @addressid = address_id
			from Geo.Address ad
			join Geo.city c on ad.city_id = c.city_id
			join Geo.District d on c.district_id = d.district_id
			join Geo.State s on d.state_id = s.state_id
			join Geo.Country cn on cn.country_id = cn.country_id
			where ad.line_1 = @line1 and
				  ad.line_2 = @line2 and
				  ad.longitude = @longitude and
				  ad.lattitude = @lattitude and
				  c.city = @city and
				  d.district = @district and
				  s.state = @state and
				  cn.country = @country

			merge into Org.branch as tgt
			using (select @companyid as company_id,
						  @branch as branch,
						  @email as email,
						  @contact as contact,
						  @addressid as address_id
						  ) src
				on tgt.company_id = src.company_id and
				   tgt.branch = src.branch and
				   tgt.email = src.email and
				   tgt.contact = src.contact and
				   tgt.address_id = src.address_id

			when matched then
			update set tgt.company_id = src.company_id,
					   tgt.branch = src.branch,
					   tgt.email = src.email,
					   tgt.contact = src.contact,
					   tgt.address_id = src.address_id

			when not matched then 
			insert (company_id,
					branch,
					email,
					contact,
					address_id)
			values (src.company_id,
					src.branch,
					src.email,
					src.contact,
					src.address_id);

	end
