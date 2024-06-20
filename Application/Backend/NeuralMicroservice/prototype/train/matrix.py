import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.metrics import confusion_matrix
import torch
from torch.utils.data import DataLoader
from torchvision import datasets, transforms

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
    "Гладиолус",
    "Голубика",
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
    "Шалфей",
    "Шиповник",
    "Яблоко"
]


if __name__ == "__main__":
    all_preds = []
    all_labels = []

    device = None

    if torch.cuda.is_available():
        device = torch.device('cuda:0')
        resnet50 = torch.load('resnet50_model.pth')
    else:
        device = torch.device('cpu')
        resnet50 = torch.load('resnet50_model.pth', map_location=torch.device('cpu'))

    resnet50.to(device)
    resnet50.eval()

    test_transforms = transforms.Compose([
        transforms.Resize((224, 224)), 
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
    ])

    test_dataset = datasets.ImageFolder(root='C:/Users/dskot/Downloads/finalDatasetRusSplit/val_test',
                                        transform=test_transforms)

    test_loader = DataLoader(test_dataset, batch_size=32, shuffle=False, num_workers=4)

    with torch.no_grad():
        for images, labels in test_loader:
            images, labels = images.to(device), labels.to(device)
            outputs = resnet50(images)
            _, preds = torch.max(outputs, 1)
            all_preds.extend(preds.cpu().numpy())
            all_labels.extend(labels.cpu().numpy())

    pred_labels = np.array(all_preds)
    true_labels = np.array(all_labels)

    cm = confusion_matrix(true_labels, pred_labels)
    plt.figure(figsize=(30, 30))
    sns.heatmap(cm, annot=False, fmt='d', cmap='coolwarm', xticklabels=plants, yticklabels=plants)
    plt.xlabel('Predicted')
    plt.ylabel('True')
    plt.title('Confusion Matrix')
    plt.show()
    print("happy end")

    errors = cm.sum(axis=1) - np.diag(cm)

    error_dict = {plants[i]: errors[i] for i in range(len(plants))}

    sorted_errors = sorted(error_dict.items(), key=lambda x: x[1], reverse=True)

    print("Classes sorted by the number of errors:")
    for class_name, error_count in sorted_errors:
        print(f"{class_name}: {error_count} errors")
