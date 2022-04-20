		
	create or alter proc Emp.Sp_person_insert
		@rollnumber varchar(10),
		@firstname varchar(50),
		@lastname varchar(50),
		@branch varchar(50),
		@department varchar(50),
		@designation varchar(50),
		@persontype varchar(50),
		@personjoiningdate date,
		@personreleavingdate date,
		@companyemail varchar(100),
		@personalemail varchar(100),
		@dob date,
		@maritalstatustype varchar(20),
		@gendertype varchar(20),
		@phonenumber1 varchar(50),
		@phonenumber2 varchar(50),		
		@line1 varchar(250),
		@line2 varchar(250),
		@longitude float,
		@lattitude float,
		@city varchar(50)
	as
	begin	
		declare @branchid int, 
				@departmentid int,
				@designationid int,
				@persontypeid int,
				@gendertypeid int,
				@maritalstatustypeid int,
				@addressid int,
				@cityid  int

		select @persontypeid = person_type_id
		from Emp.Person_type 
		where  person_type = @persontype

		select @branchid = branch_id 
		from Org.Branch 
		where branch = @branch

		select @departmentid = department_id
		from Org.department 
		where department = @department

		select @gendertypeid = gender_id
		from Emp.Gender 
		where gender_type = @gendertype              

		select @maritalstatustypeid = marital_status_id
		from Emp.Marital_status
		where  marital_status_type = @maritalstatustype

		select @designationid = designation_id
		from Emp.Designation 
		where designation = @designation

		select @addressid = address_id, @cityid = c.city_id 
		from Geo.Address ad join Geo.city c on ad.city_id = c.city_id
		where line_1 = @line1 
			and line_2 = @line2  
			and longitude = @longitude 
			and lattitude = @lattitude 
			and c.city = @city 
						
		merge into Emp.person as tgt
		using (	select  @rollnumber as rollnumber,
				@firstname as firstname, 
				@lastname as lastname, 
				@branchid as branch_id,
				@departmentid as department_id, 
				@designationid as designation_id,
				@persontypeid as person_type_id, 
				@personjoiningdate as personjoiningdate, 
				@personreleavingdate as personreleavingdate, 
				@companyemail as companyemail, 
				@personalemail as personalemail, 
				@dob as dob, 
				@gendertypeid as gender_type_id, 
				@maritalstatustypeid as marital_status_type_id, 
				@phonenumber1 as phonenumber1,
				@phonenumber2 as phonenumber2, 
				@addressid as address_id		
			  ) as src
		on tgt.rollnumber = src.rollnumber

		when matched then
		update set
				 tgt.firstname = src.firstname, 
				 tgt.lastname = src.lastname, 
				 tgt.branch_id = src.branch_id , 
				 tgt.department_id = src.department_id, 
				 tgt.designation_id = src.designation_id, 
				 tgt.person_type_id = src.person_type_id, 
				 tgt.joining_date = src.personjoiningdate,
				 tgt.releaving_date = src.personreleavingdate,	
				 tgt.company_email = src.companyemail, 
				 tgt.personal_email = src.personalemail, 
				 tgt.dob = src.dob, 
				 tgt.gender_id = src.gender_type_id,
				 tgt.marital_status_id = src.marital_status_type_id, 
				 tgt.phone_number_1 = src.phonenumber1, 
				 tgt.phone_number_2 = src.phonenumber2, 
				 tgt.address_id = src.address_id
				 			
		when not matched then
		insert( rollnumber, firstname, lastname, branch_id, department_id, designation_id, person_type_id, 
			    joining_date,  releaving_date, company_email, personal_email, dob, gender_id, 
			    marital_status_id, phone_number_1, phone_number_2, address_id
			  )
		values( rollnumber, firstname, lastname, branch_id, department_id, designation_id, person_type_id, 
				personjoiningdate, personreleavingdate,	companyemail, personalemail, dob, gender_type_id, 
				marital_status_type_id, phonenumber1, phonenumber2, address_id
			  );
		end



		exec Emp.Sp_person_insert 'T00001','pradeep','muthukrishnan','it',null,'Trainee','Trainee','2022-01-03',null,
		'pradeep.muthukrishnan@arus.co.in','krishnan.26pradeep@gmail.com','1993-10-30','unmarried','Male','8189944212',
		'9344062307','71/a','ponmuniyandi kovil street',78.0901,9.9257,'ponmeni'


		
		select * from Emp.skill_set







