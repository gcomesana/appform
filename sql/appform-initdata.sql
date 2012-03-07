-- DEFAULT SETUP
-- INSERT DEFAULT PATIENT (NULL PATIENT, TO ENABLE PREVIEW)
-- BASIC TYPES (LABEL, NUMBER AND DECIMAL) TO ENABLE PATTERNS AND BASIC TYPING
begin
	
-- dummy patient to use when previewing questionnaires
insert into patient (codpatient) values '00000000';

insert into answer_item (idansitem, name, description) 
values (100, 'Free text', 'Type of answer for representing strings or labels');
insert into answertype (idanstype) values (100);

insert into answer_item (idansitem, name, description) 
values (101, 'Number', 'Type of answer for representing integers');
insert into answertype (idanstype) values (101);

insert into answer_item (idansitem, name, description) 
values (102, 'Decimal', 'Floating point numbers type');
insert into answertype (idanstype) values (102);

-- Yes-No-NC default datatype
insert into answer_item (idansitem, name, description) 
values (110, 'Yes-No', 'Enumerated type for Yes-No-Not Known');

insert into enumtype (idenumtype) values (110);

insert into enumitem (codenumtype, name, thevalue, listorder)
values (110, 'Yes', 1, 1);
insert into enumitem (codenumtype, name, thevalue, listorder)
values (110, 'No', 2, 2);
insert into enumitem (codenumtype, name, thevalue, listorder)
values (110, 'Not known', 8, 3);

insert into grouptype (idgrouptype, name, description)
values (1, 'COUNTRY', 'This type of groups can hold a template');

insert into grouptype (idgrouptype, name, description)
values (2, 'HOSPITAL', 'This type of group share the same patiens among their users');


-- first, the roles which is going to use the application from the scratch are inserted
insert into role (id, name, description) 
values (1, 'admin', 'An administrator. Controls over the application');
insert into role (name, description) 
values ('editor', 'An questionnaire editor. Can compose questionnaires and do interviews');
insert into role (name, description) 
values ('interviewer', 'A monitor. Just can perform interviews (introduce data)');
insert into role (name, description) 
values ('hospital coordinator', 'Reading access to specific hospital collected data');
insert into role (name, description) 
values ('node coordinator', 'Reading access for node (set of hospitals) collected data');
insert into role (name, description) 
values ('country coordinator', 'Reading access for all data belonging to the same country');
insert into role (name, description) 
values ('project coordinator', 'Reading access for all data belonging to a project');


-- the only user at the beginning of the application is the admin user
-- the insert sentence has to be customized with firstname and lastname
-- and MORE IMPORTANT a valid email
insert into user (iduser, username, passwd, firstname, lastname, email)
values (1, 'adminusr', 'adminusr', 'Admin', 'User', 'anemail@emailserver.com');

insert into user_role (coduser, codrole, username, rolename)
values (1, 1, 'adminusr', 'admin');

commit;

