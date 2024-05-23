import kafka
from detector import detection
import uuid
import os
import sys

request_topic = 'request_topic'
return_topic = 'return_topic'

bootstrap_servers = ['bootstrap_servers']

username = 'username'
password = 'password'

consumer = kafka.KafkaConsumer(request_topic,
                               group_id=None,
                               bootstrap_servers=bootstrap_servers,
                               auto_offset_reset='earliest',
                               enable_auto_commit=False,
                               value_deserializer=lambda x: x,
                               security_protocol='SASL_PLAINTEXT',
                               sasl_mechanism='PLAIN',
                               sasl_plain_username=username,
                               sasl_plain_password=password)

producer = kafka.KafkaProducer(bootstrap_servers=bootstrap_servers,
                               value_serializer=lambda x: x.encode('utf-8'),
                               security_protocol='SASL_PLAINTEXT',
                               sasl_mechanism='PLAIN',
                               sasl_plain_username=username,
                               sasl_plain_password=password)

print("start")
sys.stdout.flush()


def process_message():
    photo_bytes = message.value
    file_name = str(uuid.uuid4()) + '.jpg'
    with open(file_name, 'wb') as f:
        f.write(photo_bytes)
    answer = detection(file_name)
    os.remove(file_name)
    return answer


for message in consumer:
    flora_name = process_message()
    consumer.commit()
    producer.send(
        return_topic,
        key=message.key,
        value=flora_name,
        headers=message.headers,
        partition=int(message.key.hex(), base=16)
    )
    print("Сообщение успешно отправлено")
    print("----------------------------------")
    sys.stdout.flush()
