
	create or alter proc Emp.Generate_rollnumber 
	@a varchar(50)
	as
	begin
		declare @b int
			select @a = person_type from Emp.Person_type
			where person_type = @a
	
	if @a = 'Employee'
		begin
			select @b = max(cast(substring(rollnumber,2,5)as int))
			from Emp.Person
			where rollnumber  like 'E%'

			set @b = isnull(@b,0)
			set @b = @b+1

			select ( 'E'+format(@b,'00000')) as rollnumber
		end

	else if @a = 'Trainee'
		begin
			select @b = max(cast(substring(rollnumber,2,5)as int))
			from Emp.Person
			where rollnumber  like 'T%'

			set @b = isnull(@b,0)
			set @b = @b+1

			select ( 'T'+format(@b,'00000')) as rollnumber
		end

	else if @a = 'Director'
		begin
			select @b = max(cast(substring(rollnumber,2,5)as int))
			from Emp.Person
			where rollnumber  like 'D%'

			set @b = isnull(@b,0)
			set @b = @b+1

			select ( 'D'+format(@b,'00000')) as rollnumber
		end

	else if @a = 'Intern'
		begin
			select @b = max(cast(substring(rollnumber,2,5)as int)) 
			from Emp.Person
			where rollnumber  like 'I%'

			set @b = isnull(@b,0)
			set @b = @b+1

			select ( 'I'+format(@b,'00000')) as rollnumber
		end
	else if @a = 'Contract'
		begin
			select @b = max(cast(substring(rollnumber,2,5)as int)) 
			from Emp.Person
			where rollnumber  like 'C%'

			set @b = isnull(@b,0)
			set @b = @b+1
		
			select ( 'C'+format(@b,'00000')) as rollnumber
		end
	else
		 begin
			print 'Did not have this person type'
		end
	end


exec Emp.Generate_rollnumber @a = 'employee' 
end
end
