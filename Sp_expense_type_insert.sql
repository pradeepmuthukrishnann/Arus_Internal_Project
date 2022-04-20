	create proc Fin.Sp_expense_type_insert
		@expensetype varchar(50)
	as
	begin

		merge into Fin.Expense_type as tgt
		using (select @expensetype as expense_type) as src
			on tgt.expense_type = src.expense_type

		when matched then
		update set tgt.expense_type = src.expense_type

		when not matched then
		insert ( expense_type )
		values ( src.expense_type );

	end

	exec Fin.Sp_expense_type_insert 'Vendor'

	select * from Fin.Expense_type