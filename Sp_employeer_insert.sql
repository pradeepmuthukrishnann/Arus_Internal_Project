	create or alter proc Emp.Sp_employeer_insert
		@company varchar(50)
	as
	begin

		merge into Emp.Employeer as tgt
		using (select @company as company) as src
			on tgt.company = src.company
		when matched then
			update set
				tgt.company = src.company
		when not matched then
			insert (company)
			values(src.company);
	end


	exec Emp.Sp_employeer_insert @company = 'Arus'

	select * from Emp.Employeer