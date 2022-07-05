begin
     dbms_fga.add_policy(
     object_name => 'X_EMP', 
     policy_name => 'FGA_XEMP', 
     audit_column => 'ID, NAME',
      statement_types => 'SELECT, UPDATE',
     audit_column_opts => DBMS_FGA.ALL_COLUMNS);
     end;
    /

