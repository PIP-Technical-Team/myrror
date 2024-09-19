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
      # A tibble: 1 x 4
        variable  change_in_value na_to_value value_to_na
        <fct>               <int>       <int>       <int>
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

# Print general information correctly with different keys

    Code
      myrror_output
    Message
      
      -- Myrror Report ---------------------------------------------------------------
      
      -- General Information: --
      
      dfx: survey_data_2 with 16 rows and 6 columns.
      dfy: survey_data_2_cap with 16 rows and 6 columns.
      Keys dfx: country and year.
      Keys dfy: COUNTRY and YEAR.
      
      -- Note: comparison is done for shared columns and rows. --
      
      v Total shared columns (no keys): 4
      ! Non-shared columns in survey_data_2: 0 ()
      ! Non-shared columns in survey_data_2_cap: 0 ()
      
      v Total shared rows: 16
      ! Non-shared rows in survey_data_2: 0.
      ! Non-shared rows in survey_data_2_cap: 0.
      
      -- 1. Shared Columns Class Comparison ------------------------------------------
      
      v All shared columns have the same class.
      
      
      -- 2. Shared Columns Values Comparison -----------------------------------------
      
      v All shared columns have the same values.
      
      v All shared columns have the same values.
      
      v End of Myrror Report.

# Print general information correctly with class differences

    Code
      myrror_output
    Message
      
      -- Myrror Report ---------------------------------------------------------------
      
      -- General Information: --
      
      dfx: survey_data with 16 rows and 6 columns.
      dfy: survey_data_3 with 16 rows and 6 columns.
      Keys: country and year.
      
      -- Note: comparison is done for shared columns and rows. --
      
      v Total shared columns (no keys): 4
      ! Non-shared columns in survey_data: 0 ()
      ! Non-shared columns in survey_data_3: 0 ()
      
      v Total shared rows: 16
      ! Non-shared rows in survey_data: 0.
      ! Non-shared rows in survey_data_3: 0.
      
      -- 1. Shared Columns Class Comparison ------------------------------------------
      
      ! 1 shared column(s) have different classe(s):
      
    Output
          variable class_x   class_y
            <char>  <char>    <char>
      1: variable1 numeric character
    Message
      
      
      -- 2. Shared Columns Values Comparison -----------------------------------------
      
      v All shared columns have the same values.
      
      v All shared columns have the same values.
      
      v End of Myrror Report.

# Print general information correctly with rows differences

    Code
      myrror_output
    Message
      
      -- Myrror Report ---------------------------------------------------------------
      
      -- General Information: --
      
      dfx: survey_data with 16 rows and 6 columns.
      dfy: survey_data_4 with 12 rows and 6 columns.
      Keys: country and year.
      
      -- Note: comparison is done for shared columns and rows. --
      
      v Total shared columns (no keys): 4
      ! Non-shared columns in survey_data: 0 ()
      ! Non-shared columns in survey_data_4: 0 ()
      
      v Total shared rows: 12
      ! Non-shared rows in survey_data: 4.
      ! Non-shared rows in survey_data_4: 0.
      
      i Note: run `extract_diff_rows()` to extract the missing/new rows.
      
      -- 1. Shared Columns Class Comparison ------------------------------------------
      
      v All shared columns have the same class.
      
      
      -- 2. Shared Columns Values Comparison -----------------------------------------
      
      v All shared columns have the same values.
      
      v All shared columns have the same values.
      
      v End of Myrror Report.

