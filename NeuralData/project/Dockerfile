FROM pytorch/pytorch:latest

RUN pip install kafka-python Pillow

COPY . /app
WORKDIR /app

CMD ["python", "image_processor.py"]
