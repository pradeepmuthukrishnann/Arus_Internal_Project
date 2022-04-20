	Create or alter proc Emp.Sp_qualification_mapping_insert
		@rollnumber varchar(10),
		@qualification varchar(250),
		@specification varchar(250),
		@yearofpassing date,
		@cgpa decimal(2,1)
	As
	Begin
		Declare @personid int,
				@qualificationid int

		select @personid =  person_id 
		from Emp.Person 
		where rollnumber = @rollnumber;

		
		select @qualificationid = qualification_id 
		from Emp.Qualification
		where qualification = @qualification;
		
		
		Merge into Emp.Qualification_mapping as tgt
		using (select @personid as person_id,
					  @qualificationid as qualification_id,
					  @specification as specification,
					  @yearofpassing as year_of_passing,
					  @cgpa as cgpa) as src
			on tgt.person_id = src.person_id
				and tgt.qualification_id = src.qualification_id
				and tgt.specification = src.specification
				and tgt.year_of_passing = src.year_of_passing
				and tgt.cgpa = src.cgpa


		when not matched then
			insert (person_id,
					qualification_id,
					specification,
					year_of_passing,
					cgpa)
			values (src.person_id,
					src.qualification_id,
					src.specification,
					src.year_of_passing,
					src.cgpa)

		when matched then
			update set
				tgt.person_id = src.person_id,
				tgt.qualification_id = src.qualification_id,
				tgt.specification = src.specification,
				tgt.year_of_passing = src.year_of_passing,
				tgt.cgpa = src.cgpa;
		
	End
			



	exec Sp_qualification_mapping_insert 'T00001','Bsc','computer science','2014',6.4

	select * from Emp.Qualification_mapping

