from kafka import KafkaConsumer
from detector import detection
import uuid
import os
import sys

bootstrap_servers = ['host.docker.internal:9092']
topic = 'photo-topic'

# Создание объекта консьюмера
consumer = KafkaConsumer(topic,
                         group_id='group1',
                         bootstrap_servers=bootstrap_servers,
                         auto_offset_reset='earliest',
                         value_deserializer=lambda x: x)

print("start")
sys.stdout.flush()
def process_message(message):
    photo_bytes = message.value
    file_name = str(uuid.uuid4()) + '.jpg'
    with open(file_name, 'wb') as f:
        f.write(photo_bytes)
    answer = detection(file_name)
    os.remove(file_name)
    return answer


for message in consumer:
    process_message(message)

