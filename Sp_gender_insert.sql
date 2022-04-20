	create proc Emp.Sp_gender_insert
		@gendertype varchar(50)
	as
	begin
		
		merge into Emp.Gender as tgt
		using (select @gendertype as gender_type) as src
			on tgt.gender_type = src.gender_type

		when matched then 
		update set tgt.gender_type = src.gender_type

		when not matched then 
		insert (gender_type)
		values (src.gender_type);

	end
		