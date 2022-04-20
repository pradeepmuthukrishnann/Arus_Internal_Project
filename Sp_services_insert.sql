	create or alter proc Sp_services_type_insert 
		@servicestype varchar(100)
	as
	begin
		
		merge into Org.Services as tgt
		using (select @servicestype as services_type) as src
			on tgt.services_type = src.services_type
		
		when matched then
		update set tgt.services_type = src.services_type

		when not matched then
		insert (services_type)
		values (src.services_type);

	end

	exec Sp_services_type_insert 'Rate/Hour'

	select * from Org.Services