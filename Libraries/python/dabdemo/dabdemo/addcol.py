import pyspark.sql.functions as F
import logging

logging.basicConfig(format='%(asctime)s - %(message)s',
                    datefmt='%Y-%m-%d %H:%M:%S',
                    level=logging.INFO,
                    )

def start():
  logging.info("Starting processing job.")

def with_status(df):
  return df.withColumn("status", F.lit("checked"))