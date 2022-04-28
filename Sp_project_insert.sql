	create proc Org.Sp_project_insert
		@company_name varchar(250),
		@project varchar(250),
		@projectstartingdate date,
		@projectendingdate date
	as
	begin
		
		declare 
			@clientsid int

			select @clientsid = clients_id
			from Org.clients
			where company_name = @company_name

			merge into Org.project as tgt
			using (select @clientsid as clients_id,
						  @project as project,
						  @projectstartingdate as project_starting_date,
						  @projectendingdate as project_ending_date
						  ) src
				on tgt.clients_id = src.clients_id and
				   tgt.project = src.project and
				   tgt.project_starting_date = src.project_starting_date and
				   tgt.project_ending_date = src.project_ending_date

			when matched then
			update set tgt.clients_id = src.clients_id,
					   tgt.project = src.project,
					   tgt.project_starting_date = src.project_starting_date,
					   tgt.project_ending_date = src.project_ending_date

			when not matched then
			insert (clients_id,
					project,
					project_starting_date,
					project_ending_date)
			values (src.clients_id,
					src.project,
					src.project_starting_date,
					src.project_ending_date);

	end


			