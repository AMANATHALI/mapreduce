


import java.io.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

//to find caller id and their duration in mins for a) long distance b) total duration >60  DATA: phone.txt
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.IntWritable;

import org.apache.hadoop.io.LongWritable;
//import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.*;

//import org.apache.hadoop.mapreduce.Mapper;
//import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.conf.*;
import org.apache.hadoop.fs.*;
import org.apache.hadoop.mapreduce.lib.input.*;
import org.apache.hadoop.mapreduce.lib.output.*;


public class STDCalls {
	
	public static class MapClass extends Mapper<LongWritable,Text,Text, IntWritable>
	   {
          Text phonenumber= new Text();
          IntWritable durationInMinutes=new IntWritable();
		public void map(LongWritable key, Text value, Context context)
	      {	    	  
	    	  
	         try{
	            String[] parts = value.toString().split(",");	 
	           if(parts[4].equals("1")){
	        	   phonenumber.set(parts[0]);
	        	   String callEndTime=parts[3];
	        	   String callStartTime=parts[2];
	        	   long duration=toMillis(callEndTime)-toMillis(callStartTime);
	        	   durationInMinutes.set((int)duration/(1000*60));
	           
	            
	      context.write(phonenumber,durationInMinutes);
	           }
	         }
	         catch(Exception e)
	         {
	            System.out.println(e.getMessage());
	         }
	      }
		        private long toMillis(String date) {
		        	 
		            SimpleDateFormat format = new SimpleDateFormat("yy-MM-dd HH:mm:ss");
		            Date dateFrm = null;
		            try {
		                dateFrm = format.parse(date);

		            } catch (ParseException e) {
		 
		                e.printStackTrace();
		           }
		            return dateFrm.getTime();
		        }
	     
	   }
	
	  public static class ReduceClass extends Reducer<Text,IntWritable,Text,IntWritable>
	   {
		   private IntWritable result = new IntWritable();
		    
		    public void reduce(Text key, Iterable<IntWritable> values,Context context) throws IOException, InterruptedException {
		    	 	int sum=0;
				for (IntWritable val:values) {
					sum+=val.get();
					}
					if(sum>60){
					result.set(sum);
				     context.write(key, result);
		      //context.write(key, new LongWritable(sum));
					}
		    }
	   }
	  public static void main(String[] args) throws Exception {
		    Configuration conf = new Configuration();
		    	    //conf.set("name", "value")
		    conf.set("mapreduce.output.textoutputformat.separator", ",");
		    Job job = Job.getInstance(conf, "duration >60 in mins");
		    job.setJarByClass(STDCalls.class);
		    job.setMapperClass(MapClass.class);
		    //job.setCombinerClass(ReduceClass.class);
		    job.setReducerClass(ReduceClass.class);
		    //job.setNumReduceTasks(0);
		    job.setOutputKeyClass(Text.class);
		    job.setInputFormatClass(TextInputFormat.class);//binding data 
		    job.setOutputFormatClass(SequenceFileOutputFormat.class);//not mandatory above two lines it ll not give op for all
		    //job.setMapOutputValueClass(IntWritable.class);
		   //job.setMapOutputKeyClass(Text.class);
		    job.setOutputValueClass(Text.class);
		    FileInputFormat.addInputPath(job, new Path(args[0]));
		    FileOutputFormat.setOutputPath(job, new Path(args[1]));
		    System.exit(job.waitForCompletion(true) ? 0 : 1);
		  }
}

