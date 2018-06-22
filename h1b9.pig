onea  = LOAD  '/home/hduser/Downloads/H1B'  USING  PigStorage()  AS (s_no, case_status:chararray, employer_name: chararray, soc_name: chararray, job_title:chararray, full_time_position:chararray,prevailing_wage:long,year:chararray, worksite:chararray, longitute: double, latitute: double );

ninegen = foreach onea generate employer_name,case_status,year;

ninefil = filter ninegen by LOWER(case_status) == 'certified' OR LOWER(case_status) == 'certified withdrawn';

ninegrp = GROUP ninefil by employer_name;
ninecount = foreach ninegrp generate group, COUNT(ninefil.case_status);

ninebgrp = GROUP ninegen by employer_name;
ninebcount = foreach ninebgrp generate group, COUNT(ninegen.case_status);

ninejoine = join ninecount by $0, ninebcount by $0;

ninecal = foreach ninejoine generate $0, $1, $3, (DOUBLE)(($1*100)/$3);

ninecalfilt = filter ninecal by $3 > 70.00 AND $2 >= 1000;

dump ninecalfilt;
