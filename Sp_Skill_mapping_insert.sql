
	create or alter proc Emp.Sp_skill_mapping_insert
		@rollnumber varchar(250),
		@skilltype varchar(250)
	as
	begin
		
		declare @personid int,
				@skillid int

		select @personid = person_id
		from Emp.Person
		where rollnumber = @rollnumber

		merge into Emp.Skill_mapping as tgt
		using ( select @personid as person_id ,skill_id
				from Emp.Skill_set 
				where skill_type in( select value from string_split( @skilltype,','))
				) as src
			on  tgt.person_id = src.person_id and
				tgt.skill_id  = src.skill_id

		when matched then
		update set tgt.person_id = src.person_id,
				   tgt.skill_id  = src.skill_id

		when not matched then
		insert ( person_id,
				 skill_id )
		values ( src.person_id,
				 src.skill_id);

	end


	Exec Emp.Sp_skill_mapping_insert 'T00001','T-sql,Azure,Power Apps,MYSQL,SSIS'

	select * from Emp.Skill_mapping
