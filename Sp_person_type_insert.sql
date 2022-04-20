	
	
	create proc Emp.Sp_person_type_insert
		@persontype varchar(50)
	as
	begin
		
		merge into Emp.Person_type as tgt
		using (select @persontype as person_type) as src
			on tgt.person_type = src.person_type
		
		when matched then
			update set 
				tgt.person_type = src.person_type
	
		when not matched then
			insert (person_type)
				values (src.person_type);
	
	end
	
			
	select * from Emp.Person_type

	exec Emp.Sp_person_type_insert 'Vendor'


