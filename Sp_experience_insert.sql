	create or alter proc Emp.Sp_experience_insert
		@rollnumber varchar(50),
		@company varchar(250),
		@joiningdate date,
		@releavingdate date,
		@experience decimal,
		@iscurrent bit,
		@contact varchar(50),
		@city varchar(50)
	as
	begin

		declare @employeerid int,
				@personid int,
				@cityid int

			select @personid = person_id 
			from Emp.Person
			where rollnumber = @rollnumber

			select @employeerid = employeer_id 
			from Emp.Employeer 
			where company = @company

			select @cityid = city_id 
			from Geo.City
			where city = @city

		merge into Emp.Experience as tgt
		using (select @personid as person_id,
					  @employeerid as employeer_id,
					  @joiningdate as joining_date,
					  @releavingdate as releaving_date,
					  @experience as experience,
					  @iscurrent as iscurrent,
					  @contact as contact,
					  @cityid as city_id
					  ) as src

			on tgt.person_id = src.person_id and
			   tgt.employeer_id = src.employeer_id and
			   tgt.joining_date = src.joining_date and
			   tgt.releaving_date = src.releaving_date and
			   tgt.experience = src.experience and
			   tgt.iscurrent = src.iscurrent and
			   tgt.contact = src.contact and
			   tgt.city_id = src.city_id

		when not matched then
		insert (person_id,
				employeer_id,
				joining_date,
				releaving_date,
				experience,
				iscurrent,
				contact,
				city_id)
		values (src.person_id,
				src.employeer_id,
				src.joining_date,
				src.releaving_date,
				src.experience,
				src.iscurrent,
				src.contact,
				src.city_id)

		when matched then
		update set  tgt.person_id = src.person_id,
					tgt.employeer_id = src.employeer_id,
					tgt.joining_date = src.joining_date,
					tgt.releaving_date = src.releaving_date,
					tgt.experience = src.experience,
					tgt.iscurrent = src.iscurrent,
					tgt.contact = src.contact,
					tgt.city_id = src.city_id;

	end


