import torch.nn as nn
import torch
import torchvision.transforms as transform
from PIL import Image
import sys

device = None

if torch.cuda.is_available():
    device = torch.device('cuda:0')
    resnet50 = torch.load('resnet50_model.pth')
else:
    device = torch.device('cpu')
    resnet50 = torch.load('resnet50_model.pth', map_location=torch.device('cpu'))

resnet50.to(device)
resnet50.eval()


def preprocess_image(image_path):
    image = Image.open(image_path)
    preprocess = transform.Compose([
        transform.Resize((256, 256)),
        transform.CenterCrop(224),
        transform.ToTensor(),
        transform.Normalize(
            mean=[0.485, 0.456, 0.406],
            std=[0.229, 0.224, 0.225]
        )
    ])
    return preprocess(image)


def detection(path):
    img = preprocess_image(path)

    m = nn.Softmax(dim=1)
    probabilities = resnet50(img.to(device).unsqueeze(0))

    percentages = m(probabilities) * 100

    top3_indices = torch.argsort(probabilities, descending=True)[:3]

    class_index = top3_indices[0][0].item()
    class_name = plants[class_index]
    probability = percentages[0][class_index].item()
    print(f"Класс: {class_name}, Вероятность: {probability:.2f}%")
    print("----------------------------------")
    sys.stdout.flush()

    return plants[top3_indices[0][0].item()]


plants = [
    "Авокадо",
    "Акация",
    "Ананас",
    "Анютины глазки",
    "Апельсин",
    "Арахис",
    "Арбуз",
    "Астра",
    "Баклажан",
    "Банан",
    "Барбарис",
    "Бергамот",
    "Болгарский перец",
    "Боярышник",
    "Брусника",
    "Василек",
    "Виноград",
    "Вишня",
    "Гвоздика",
    "Георгин",
    "Герань",
    "Гладиолусы",
    "Горох",
    "Гранат",
    "Грейпфрут",
    "Груша",
    "Ежевика",
    "Жасмин",
    "Инжир",
    "Ирис",
    "Кабачок",
    "Какао-бобы",
    "Киви",
    "Клевер",
    "Клубника",
    "Клюква",
    "Кокос",
    "Колокольчик",
    "Космея",
    "Кофе",
    "Крыжовник",
    "Лаванда",
    "Лайм",
    "Лилия",
    "Лимон",
    "Личи",
    "Лотос",
    "Лютик",
    "Магнолия",
    "Мак",
    "Малина",
    "Манго",
    "Маракуйя",
    "Маргаритка",
    "Мимоза",
    "Нарцисс",
    "Нектарин",
    "Облепиха обыкновенная",
    "Одуванчик",
    "Орхидея",
    "Пион",
    "Подснежник",
    "Подсолнечник",
    "Помидор",
    "Роза",
    "Сирень",
    "Слива",
    "Тыква",
    "Тысячелистник",
    "Тюльпан",
    "Укроп",
    "Финик",
    "Флокс",
    "Халапеньо",
    "Хризантема",
    "Хурма",
    "Цикорий",
    "Чёрная смородина",
    "Черника",
    "Шалфей",
    "Шиповник",
    "Яблоко"
]
