h1b = load '$input' using PigStorage('\t') as (sno, casestatus:chararray, employername, socname, jobtitle:chararray, position, wage, year, lat, log);

--h1b10 = h1b limit 10;

--dump h1b10;

h1bfilter = foreach h1b generate jobtitle, casestatus;

group1 = group h1bfilter by jobtitle;

countall = foreach group1 generate group, (DOUBLE)COUNT(h1bfilter.casestatus);

csfilter = filter h1bfilter by LOWER(casestatus) == 'certified' OR LOWER(casestatus) == 'certified withdrawn';

group2 = group csfilter by jobtitle;

countboth = foreach group2 generate group, (DOUBLE)COUNT(csfilter.casestatus);

netjoin = join countall by $0, countboth by $0;

success = foreach netjoin generate $0, $1, $3, (($3 * 100) / $1);

final = filter success by $3 > 70.00 AND $1 >= 1000;

finalorder = order final by $3 desc;

store finalorder into '$out';

--dump finalorder;

--describe finalorder;

--finalorder: {countall::group: chararray,double,double,double}











