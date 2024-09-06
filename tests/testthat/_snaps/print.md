# Print general information correctly

    Code
      myrror_output
    Message
      
      -- Myrror Report ---------------------------------------------------------------
      
      -- General Information: --
      
      dfx: survey_data with 16 rows and 6 columns.
      dfy: survey_data_2 with 16 rows and 6 columns.
      Keys: rn.
      
      -- Note: comparison is done for shared columns and rows. --
      
      v Total shared columns (no keys): 6
      ! Non-shared columns in survey_data: 0 ()
      ! Non-shared columns in survey_data_2: 0 ()
      
      v Total shared rows: 16
      ! Non-shared rows in survey_data: 0.
      ! Non-shared rows in survey_data_2: 0.
      
      -- 1. Shared Columns Class Comparison ------------------------------------------
      
      v All shared columns have the same class.
      
      
      -- 2. Shared Columns Values Comparison -----------------------------------------
      
      ! 1 shared column(s) have different value(s):
      i Note: character-numeric comparison is allowed.
      
      
      -- Overview: --
      
    Output
         variable change_in_value na_to_value value_to_na
      1 variable2              16           0           0
    Message
      
      
      
      -- Value comparison: --
      
      ! 1 shared column(s) have different value(s):
      i Note: Only first 5 rows shown for each variable.
      
      -- "variable2" 
    Output
                    diff indexes     rn variable2.x variable2.y
                  <char>  <char> <char>       <num>       <num>
      1: change_in_value       1      1   0.4978505  -1.0717912
      2: change_in_value      10     10  -1.6866933  -0.7092008
      3: change_in_value      11     11   0.8377870  -0.6880086
      4: change_in_value      12     12   0.1533731   1.0255714
      5: change_in_value      13     13  -1.1381369  -0.2847730
    Message
      ...
      
      i Note: run `extract_diff_values()` or `extract_diff_table()` to access the results in list or table format.
      
      v End of Myrror Report.

