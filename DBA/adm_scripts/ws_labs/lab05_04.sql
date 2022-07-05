set echo on
conn / as sysdba
show parameter resource_limit
alter system set resource_limit=true
/
create profile sales_prof LIMIT
	failed_login_attempts 2
	password_life_time 30
	password_grace_time 5
              sessions_per_user 2
              connect_time 5
              idle_time 1
              password_reuse_max 2
/
 select resource_name, limit, resource_type from dba_profiles
 where profile='SALES_PROF';
/
alter user sales profile sales_prof
/
select username, profile from dba_users
/
set echo off