import sys
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

# ✅ Captura os argumentos passados pelo Step Functions ou CLI
args = getResolvedOptions(sys.argv, [
    'JOB_NAME',
    'ingest_id',
    'bucket',
    'object_key'
])

ingest_id = args['ingest_id']
bucket = args['bucket']
object_key = args['object_key']

# ✅ Inicializa os contextos Glue
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

print(f"[INFO] Starting RAW job for ingest_id={ingest_id}")
print(f"[INFO] Input path: s3://{bucket}/{object_key}")

job.commit()
