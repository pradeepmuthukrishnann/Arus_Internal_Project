	create or alter proc Org.Sp_clients_type_insert
		@clientstype as varchar(50),
		@sgst decimal(3,1),
		@cgst decimal(3,1)
	as
	begin

		merge into Org.clients_type as tgt
		using (select @clientstype as clients_type,
					  @sgst as sgst,
					  @cgst as cgst
				      ) as src
			on  tgt.clients_type = src.clients_type and
				tgt.sgst = src.sgst and
				tgt.cgst = src.cgst

		when matched then
		update set tgt.clients_type = src.clients_type,
				   tgt.sgst = src.sgst,
				   tgt.cgst = src.cgst

		when not matched then
		insert (clients_type,
				sgst,
				cgst)
		values (src.clients_type,
				src.sgst,
				src.cgst);

	end

	exec Sp_clients_type_insert 'Local',9,9

	select * from Org.Clients_type