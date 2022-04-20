	create or alter proc Emp.Sp_designation_insert
		@designation varchar(50)
	as
	begin

		merge into Emp.Designation as tgt
		using (select @designation as designation) as src
			on tgt.designation = src.designation
		when matched then
			update set
				tgt.designation = src.designation
		when not matched then
			insert (designation)
			values(src.designation);
	end


	exec Emp.Sp_designation_insert 'Architect'

	select * from Emp.designation