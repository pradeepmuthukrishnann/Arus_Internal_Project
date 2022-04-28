	create or alter proc Org.Sp_department_insert
		@department varchar(100)
	as
	begin
		
		merge into Org.Department as tgt
		using (select @department as department) as src
			on tgt.department = src.department

		when matched then
		update set tgt.department = src.department

		when not matched  then
		insert (department)
		values (src.department);
	end
			
