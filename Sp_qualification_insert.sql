create or alter proc Emp.Sp_qualification_insert
		@qualification varchar(50),
		@qualificationtype varchar(50)
	as
	begin

		merge into Emp.Qualification as tgt
		using (select @qualification as qualification, qualification_type_id 
				from Emp.Qualification_type
				where qualification_type = @qualificationtype ) as src
			on tgt.qualification = src.qualification
			and tgt.qualification_type_id  = src.qualification_type_id
			
		when matched then
			update set
				tgt.qualification = src.qualification,
				tgt.qualification_type_id  = src.qualification_type_id
		when not matched then
			insert (qualification,qualification_type_id )
			values(src.qualification,src.qualification_type_id );

	end


	exec Emp.Sp_qualification_insert 'BCA','ug'

	select * from Emp.Qualification
