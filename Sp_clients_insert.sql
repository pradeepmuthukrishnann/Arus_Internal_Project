	create or alter proc Org.Sp_clients_insert 
		@companyname varchar(100),
		@clientstype varchar(50),
		@email varchar(100),
		@contact varchar(100),
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
		
		declare @clientstypeid int,
				@addressid int
								
				select @clientstypeid = clients_type_id 
				from Org.Clients_type
				where clients_type = @clientstype

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
		
		merge into Org.clients as tgt
		using (select @companyname as company_name,
					  @clientstypeid as clients_type_id,
					  @email as email,
					  @contact as contact,
					  @addressid as address_id
					  ) src
			on tgt.company_name = src.company_name and
			   tgt.clients_type_id = src.clients_type_id and
			   tgt.email = src.email and
			   tgt.contact = src.contact and
			   tgt.address_id = src.address_id

		when matched then
		update set tgt.company_name = src.company_name,
				   tgt.clients_type_id = src.clients_type_id,
			       tgt.email = src.email,
			       tgt.contact = src.contact,
			       tgt.address_id = src.address_id

		when not matched then
		insert (company_name,
				clients_type_id,
				email,
				contact,
				address_id)
		values (src.company_name,
				src.clients_type_id,
				src.email,
				src.contact,
				src.address_id);
				
	end