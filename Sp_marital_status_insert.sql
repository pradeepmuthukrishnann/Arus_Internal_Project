create proc Emp.Sp_marital_status_insert
		@maritalstatustype varchar(50)
	as
	begin
		
		merge into Emp.marital_status as tgt
		using (select @maritalstatustype as marital_status_type) as src
			on tgt. marital_status_type = src. marital_status_type

		when matched then 
		update set tgt. marital_status_type = src. marital_status_type

		when not matched then 
		insert ( marital_status_type)
		values (src. marital_status_type);

	end
		