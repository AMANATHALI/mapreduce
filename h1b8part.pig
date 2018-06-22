h1b = load '/home/hduser/Downloads/H1B' using PigStorage('\t') as (sno, casestatus:chararray, employername, socname, jobtitle:chararray, position:chararray, wage:double, year:chararray, lat, log);

--h1b10 = limit h1b 10;

--dump h1b10;

h1bfilter = foreach h1b generate casestatus, jobtitle, position, wage, year;

--h1bfilter10 = limit h1bfilter 10;

--dump h1bfilter10;

csfilter = filter h1bfilter by LOWER(casestatus) == 'certified' OR LOWER(casestatus) == 'certified-withdrawn';

--csfilter20 = limit csfilter 20;

--dump csfilter20;


parttime = filter csfilter by LOWER(position) == 'n';

--parttime5 = limit parttime 5;

--dump parttime5;


partbyboth = group parttime by (year,jobtitle);

--partbyboth5 = limit partbyboth 5;

--dump partbyboth5;




partbysum = foreach partbyboth generate FLATTEN(group) as (year,jobtitle), parttime.casestatus, parttime.position, SUM(parttime.wage) as sum, COUNT(parttime.wage) as count;

--partbysum10 = limit partbysum 10;

--dump partbysum10;



partbyavg = foreach partbysum generate $0, $1, ROUND_TO((DOUBLE)($4 / $5),2) as average;

yearavg = filter partbyavg by $0 == '2011';

byorder = order yearavg by $2 desc;

byorder20 = limit byorder 20;

dump byorder20;

describe byorder;
















