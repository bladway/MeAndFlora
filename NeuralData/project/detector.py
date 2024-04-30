import torch.nn as nn
import torch
import torchvision.transforms as transform
from PIL import Image
import sys

device = torch.device('cuda:0' if torch.cuda.is_available() else 'cpu')

resnet50 = torch.load('resnet50_model.pth')
resnet50.to(device)
resnet50.eval()


def preprocess_image(image_path):
    image = Image.open(image_path)
    preprocess = transform.Compose([
        transform.Resize((220, 220)),
        transform.ToTensor(),
        transform.Normalize((0.4124234616756439, 0.3674212694168091, 0.2578217089176178),
                            (0.3268945515155792, 0.29282665252685547, 0.29053378105163574))
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

    return [plants[top3_indices[0][0].item()],
            plants[top3_indices[0][1].item()],
            plants[top3_indices[0][2].item()]]


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
