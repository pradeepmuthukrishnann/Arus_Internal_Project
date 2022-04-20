create or alter proc Emp.Sp_qualificationtype_insert
		@qualificationtype varchar(250)
	as
	begin

		merge into Emp.Qualification_type as tgt
		using (select @qualificationtype as qualification_type) as src
			on tgt.qualification_type = src.qualification_type
		when matched then
			update set
				tgt.qualification_type = src.qualification_type
		when not matched then
			insert (qualification_type)
			values(src.qualification_type);
	end


	select * from Emp.Qualification_type

	exec Emp.Sp_qualificationtype_insert 'PG'
	