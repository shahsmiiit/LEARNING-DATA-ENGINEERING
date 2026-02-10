from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *

if __name__ == '__main__':
    # Initialize Spark
    spark = (SparkSession.builder
             .appName("Spark Streaming Demo").master("local")
             .config("spark.sql.shuffle.partitions", 10)
             .getOrCreate())

    crime_schema = StructType([
        StructField("code", StringType()),
        StructField("location", StringType()),
        StructField("category", StringType())
    ])

    input_df = spark.readStream.load(
        format="csv",
        schema=crime_schema,
        path="../../../Downloads/npn-dataset/crime_data/input")

    result_df = input_df.groupBy("location").count()
    result_df.writeStream.start(format="console",
                                outputMode="UPDATE").awaitTermination()
