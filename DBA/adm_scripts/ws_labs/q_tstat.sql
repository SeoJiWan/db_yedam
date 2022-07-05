SELECT table_name, num_rows, blocks, empty_blocks, to_char(last_analyzed, 'yy/mm/dd hh24:mi:ss') last_analyzed
FROM user_tables
/
