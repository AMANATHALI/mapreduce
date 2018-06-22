--file1 is a text data with lower case words

REGISTER /home/hduser/pigudf.jar;

DEFINE ConvertLowerToUpper myudfs.UPPER();

bag1 = load '/home/hduser/file1' using TextLoader() as (name:chararray);

bag2 = foreach bag1 generate ConvertLowerToUpper(name);

dump bag2;


