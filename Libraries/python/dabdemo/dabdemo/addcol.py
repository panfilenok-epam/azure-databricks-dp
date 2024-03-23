import pyspark.sql.functions as F
import logging

def start():
  logging.info("Starting processing job.")

def with_status(df):
  return df.withColumn("status", F.lit("checked"))