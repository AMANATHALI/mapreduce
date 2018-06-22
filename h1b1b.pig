h1b = load '/home/hduser/Downloads/H1B' using PigStorage('\t') as (sno, casestatus, employername, socname, jobtitle:chararray, position, wage:double, year:chararray, lat, log);

h1bfilter = foreach h1b generate year,jobtitle;

year1 = filter h1bfilter by year == '2011';

--describe year1;

--year1: {year: chararray,jobtitle: chararray}

group1 = group year1 by jobtitle;

count1 = foreach group1 generate group, (DOUBLE)COUNT(year1.jobtitle);


year2 = filter h1bfilter by year == '2012';

group2 = group year2 by jobtitle;

count2 = foreach group2 generate group, (DOUBLE)COUNT(year2.jobtitle);

--describe count2;


join1 = join count1 by $0, count2 by $0;

growth1 = foreach join1 generate $0, $1, $3, (DOUBLE)((($3 - $1) * 100) / $1);


year3 = filter h1bfilter by year == '2013';

group3 = group year3 by jobtitle;

count3 = foreach group3 generate group, (DOUBLE)COUNT(year3.jobtitle);



join2 = join count2 by $0, count3 by $0;

growth2 = foreach join2 generate $0, $1, $3, (DOUBLE)((($3 - $1) * 100) / $1);



year4 = filter h1bfilter by year == '2014';

group4 = group year4 by jobtitle;

count4 = foreach group4 generate group, (DOUBLE)COUNT(year4.jobtitle);


join3 = join count3 by $0, count4 by $0;

growth3 = foreach join3 generate $0, $1, $3, (DOUBLE)((($3 - $1) * 100) / $1);


year5 = filter h1bfilter by year == '2015';

group5 = group year5 by jobtitle;

count5 = foreach group5 generate group, (DOUBLE)COUNT(year5.jobtitle);


join4 = join count4 by $0, count5 by $0;

growth4 = foreach join4 generate $0, $1, $3, (DOUBLE)((($3 - $1) * 100) / $1);



year6 = filter h1bfilter by year == '2016';

group6 = group year6 by jobtitle;

count6 = foreach group6 generate group, (DOUBLE)COUNT(year6.jobtitle);

--dump count6;

--describe count6;

--count6: {group: chararray,double}


join5 = join count5 by $0, count6 by $0;

growth5 = foreach join5 generate $0, $1, $3, (DOUBLE)((($3 - $1) * 100) / $1);

--dump growth5;

--describe growth5;

--join5: {count5::group: chararray,double,count6::group: chararray,double}

--growth5: {count5::group: chararray,double,double,double}

netjoin = join growth1 by $0, growth2 by $0, growth3 by $0, growth4 by $0, growth5 by $0;

--describe netjoin;

--netjoin: {join1::count1::group: chararray,double,join1::count2::group: chararray,double,join2::count2::group: 
--chararray,double,join2::count3::group: chararray,double,join3::count3::group: chararray,double,join3::count4::group: 
--chararray,double,join4::count4::group: chararray,double,join4::count5::group: chararray,double,join5::count5::group: 
--chararray,double,join5::count6::group: chararray,double}


avggrowth = foreach netjoin generate $0, ($3+$7+$11+$15+$19) / 5;

--dump avggrowth;

--describe avggrowth;

--avggrowth: {join1::count1::group: chararray,double}

top5avg = limit (order avggrowth by $1 desc) 5;

dump top5avg;

























