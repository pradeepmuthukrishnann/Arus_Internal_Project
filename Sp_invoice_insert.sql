
	create proc Fin.Sp_invoice_insert 
		@project varchar(250),
		@servicestype varchar(250),
		@branch varchar(250),
		@invoicedate datetime,
		@invoiceamount decimal(18,2)
	as
	begin
		
		declare 
			@projectid int,
			@servicesid int,
			@branchid int

			select @projectid = project_id
			from Org.project
			where project = @project

			select @servicesid = services_id
			from Org.Services
			where services_type = @servicestype

			select @branchid = branch_id 
			from Org.branch
			where branch = @branch

		merge into Org.invoice as tgt
		using (select @projectid as project_id,
					  @servicesid as services_id,
					  @branchid as branch_id,
					  @invoicedate as invoice_date,
					  @invoiceamount as invoice_amount
					  ) src
			on tgt.project_id = src.project_id and
			   tgt.services_id = src.services_id and
			   tgt.branch_id = src.branch_id and
			   tgt.invoice_date = src.invoice_date and
			   tgt.invoice_amount = src.invoice_amount

		when matched then
		update set  tgt.project_id = src.project_id,
					tgt.services_id = src.services_id,
					tgt.branch_id = src.branch_id,
					tgt.invoice_date = src.invoice_date,
					tgt.invoice_amount = src.invoice_amount

		when not matched then
		insert (project_id,
				services_id,
				branch_id,
				invoice_date,
				invoice_amount)
		values (src.project_id,
				src.services_id,
				src.branch_id,
				src.invoice_date,
				src.invoice_amount);
	end
