FROM pytorch/pytorch:latest

# Установка дополнительных зависимостей
RUN pip install kafka-python Pillow

# Добавляем ваш код в образ
COPY . /app
WORKDIR /app

# Убедитесь, что ваш код будет запущен при старте контейнера
CMD ["python", "image_processor.py"]