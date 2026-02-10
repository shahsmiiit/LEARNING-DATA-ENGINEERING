from pyspark.sql import SparkSession
from pyspark.sql.functions import *

if __name__ == '__main__':
    # Initialize Spark
    spark = (SparkSession.builder
             .appName("Spark Streaming Demo")
             .master("local")
             .config("spark.sql.shuffle.partitions", 10)
             .getOrCreate())

    spark.sparkContext.setLogLevel("ERROR") # Reduces console noise

    # 01: Read data from socket
    input_df = spark.readStream \
        .format("socket") \
        .option("host", "localhost") \
        .option("port", 9999) \
        .load()

    # 02: Transformations
    # Split the lines into words and count them
    result_df = input_df.select(
        explode(split(col("value"), " ")).alias("word")
    ).groupBy("word").count()

    # 03: Write data to console
    # We use "complete" mode because we are performing an aggregation (count)
    query = result_df.writeStream \
        .format("console") \
        .outputMode("complete") \
        .start()

    # Keep the process alive until terminated
    query.awaitTermination()
