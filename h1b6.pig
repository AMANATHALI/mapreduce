h1b = load '$input' using PigStorage('\t') as (sno, casestatus:chararray, employername, socname, jobtitle, position, wage, year:chararray, lat, log);

--h1b10 = limit h1b 10;

--dump h1b10;

h1bfilter = foreach h1b generate casestatus,year;

--dump h1bfilter;

byboth = group h1bfilter by (year,casestatus);

--byboth1 = limit byboth 1;

--dump byboth1;

--group by year and count of casestatus seperately

bycount = foreach byboth generate FLATTEN(group) as (year,casestatus), COUNT(h1bfilter.casestatus) as eachcount;

--dump bycount;

byyear = group h1bfilter by year;

--byyear1 = limit byyear 1;

--dump byyear1;

byyearcount = foreach byyear generate group, COUNT(h1bfilter.casestatus) as countall;

--dump byyearcount;

joined = join bycount by $0, byyearcount by $0;

--dump joined;

netjoin = foreach joined generate $0, $1, (DOUBLE)$2, (DOUBLE)$4;

--dump netjoin;

percent = foreach netjoin generate $0, $1, $2, $3, ROUND_TO((DOUBLE)(($2 * 100) / $3),2);

store percent into '$out';


--dump percent;













