	create or alter proc Fin.Sp_expense_details_insert
		@rollnumber varchar(20),
		@branch varchar(50),
		@expensetype varchar(250),
		@expensedate datetime,
		@expenseamount decimal
	as
	begin
		
		declare @personid int,
				@branchid int,
				@expensetypeid int

		select @personid = person_id
		from Emp.Person
		where rollnumber = @rollnumber

		select @branchid = branch_id
		from Org.Branch
		where branch = @branch
		
		select @expensetypeid = expense_type_id
		from Fin.Expense_type
		where expense_type = @expensetype
			   
		merge into Fin.Expense_details as tgt
		using (select @personid as person_id,
					  @branchid as branch_id,
					  @expensetypeid as expense_type_id,
					  @expensedate as expense_date,
					  @expenseamount as expense_amount
				) as src
			on  tgt.person_id = src.person_id and
				tgt.branch_id = src.branch_id and
				tgt.expense_type_id = src.expense_type_id and
				tgt.expense_date = src.expense_date and
				tgt.expense_amount = src.expense_amount

		when not matched then
		insert (person_id,
				branch_id,
				expense_type_id,
				expense_date,
				expense_amount)
		values (src.person_id,
				src.branch_id,
				src.expense_type_id,
				src.expense_date,
				src.expense_amount)

		when matched then 
		update set tgt.person_id = src.person_id,
				   tgt.branch_id = src.branch_id,
				   tgt.expense_type_id = src.expense_type_id,
				   tgt.expense_date = src.expense_date,
				   tgt.expense_amount = src.expense_amount;

	end

	
	exec Fin.Sp_expense_details_insert 'T00001','Attipalli','Salary','2022/03/31',20000
	
	