
import copy
import time
import numpy as np
import torch
import torchvision
import torchvision.transforms as transform
from torchvision.datasets import ImageFolder
from torch.utils.data import DataLoader, random_split, ConcatDataset
import torch.nn as nn
import matplotlib.pyplot as plt


def train_method(seed, epochs, model):
    print('Creating a model {}...'.format(seed))

    model.to(device)
    criterion = nn.CrossEntropyLoss()
    if seed == 0 or seed == 3:
        optimizer = torch.optim.Adam(model.fc.parameters(), lr=0.001, betas=(0.9, 0.999), eps=1e-08, weight_decay=1e-5)
    else:
        optimizer = torch.optim.Adam(model.classifier.parameters(), lr=0.001, betas=(0.9, 0.999), eps=1e-08,
                                     weight_decay=0)
    scheduler = torch.optim.lr_scheduler.ReduceLROnPlateau(optimizer, mode='max', factor=0.1, patience=3, verbose=True)
    since = time.time()
    best_model = copy.deepcopy(model.state_dict())
    best_acc = 0.0
    for epoch in range(epochs):
        for phase in ['train', 'val']:
            if phase == 'train':
                model.train()
            else:
                model.eval()

            running_loss = 0.0
            running_corrects = 0.0

            for inputs, labels in loaders[phase]:
                inputs, labels = inputs.to(device), labels.to(device)
                optimizer.zero_grad()

                with torch.set_grad_enabled(phase == 'train'):
                    outp = model(inputs)
                    _, pred = torch.max(outp, 1)
                    loss = criterion(outp, labels)

                    if phase == 'train':
                        loss.backward()
                        optimizer.step()

                running_loss += loss.item() * inputs.size(0)
                running_corrects += torch.sum(pred == labels.data)

            if phase == 'train':
                acc = 100. * running_corrects.double() / dataset_sizes[phase]
                scheduler.step(acc)

            epoch_loss = running_loss / dataset_sizes[phase]
            epoch_acc = running_corrects.double() / dataset_sizes[phase]
            losses[phase].append(epoch_loss)
            accuracies[phase].append(epoch_acc)
            if phase == 'train':
                print('Epoch: {}/{}'.format(epoch + 1, epochs))
            print('{} - loss:{}, accuracy{}'.format(phase, epoch_loss, epoch_acc))
            lr.append(scheduler.get_last_lr())

            if phase == 'val':
                print('Time: {}m {}s'.format((time.time() - since) // 60, (time.time() - since) % 60))
                print('==' * 31)
            if phase == 'val' and epoch_acc > best_acc:
                best_acc = epoch_acc
                best_model = copy.deepcopy(model.state_dict())
    time_elapsed = time.time() - since
    print('CLASSIFIER TRAINING TIME {}m {}s'.format(time_elapsed // 60, time_elapsed % 60))
    print('==' * 31)

    model.load_state_dict(best_model)

    for param in model.parameters():
        param.requires_grad = True

    optimizer = torch.optim.Adam(model.parameters(), lr=0.0001, betas=(0.9, 0.999), eps=1e-08, weight_decay=0)
    scheduler = torch.optim.lr_scheduler.ReduceLROnPlateau(optimizer, factor=0.1, patience=2, verbose=True)
    for epoch in range(epochs):
        for phase in ['train', 'val']:
            if phase == 'train':
                model.train()
            else:
                model.eval()

            running_loss = 0.0
            running_corrects = 0.0

            for inputs, labels in loaders[phase]:
                inputs, labels = inputs.to(device), labels.to(device)

                optimizer.zero_grad()

                with torch.set_grad_enabled(phase == 'train'):
                    outp = model(inputs)
                    _, pred = torch.max(outp, 1)
                    loss = criterion(outp, labels)

                    if phase == 'train':
                        loss.backward()
                        optimizer.step()

                running_loss += loss.item() * inputs.size(0)
                running_corrects += torch.sum(pred == labels.data)

            if phase == 'train':
                acc = 100. * running_corrects.double() / dataset_sizes[phase]
                scheduler.step(acc)

            epoch_loss = running_loss / dataset_sizes[phase]
            epoch_acc = running_corrects.double() / dataset_sizes[phase]
            losses[phase].append(epoch_loss)
            accuracies[phase].append(epoch_acc)
            if phase == 'train':
                print('Epoch: {}/{}'.format(epoch + 1, epochs))
            print('{} - loss:{}, accuracy{}'.format(phase, epoch_loss, epoch_acc))
            lr.append(scheduler.get_last_lr())

            if phase == 'val':
                print('Time: {}m {}s'.format((time.time() - since) // 60, (time.time() - since) % 60))
                print('==' * 31)
            if phase == 'val' and epoch_acc > best_acc:
                best_acc = epoch_acc
                best_model = copy.deepcopy(model.state_dict())
    time_elapsed = time.time() - since
    print('ALL NET TRAINING TIME {}m {}s'.format(time_elapsed // 60, time_elapsed % 60))
    print('==' * 31)

    model.load_state_dict(best_model)
    return model


if __name__ == '__main__':
    print(torch.cuda.is_available())
    device = torch.device('cuda:0' if torch.cuda.is_available() else 'cpu')

    path_1 = 'C:/Users/dskot/Downloads/finalDatasetRus'

    transformer = {
        'original': transform.Compose([
            transform.Resize((220, 220)),
            transform.ToTensor(),
            transform.Normalize((0.4124234616756439, 0.3674212694168091, 0.2578217089176178),
                                (0.3268945515155792, 0.29282665252685547, 0.29053378105163574))
        ]),
        'dataset1': transform.Compose([
            transform.Resize((220, 220)),
            transform.ColorJitter(brightness=0.2, contrast=0.2, saturation=0.2),
            transform.RandomRotation(5),
            transform.RandomAffine(degrees=11, translate=(0.1, 0.1), scale=(0.8, 0.8)),
            transform.ToTensor(),
            transform.Normalize((0.4124234616756439, 0.3674212694168091, 0.2578217089176178),
                                (0.3268945515155792, 0.29282665252685547, 0.29053378105163574)),
        ]),
        'dataset2': transform.Compose([
            transform.Resize((220, 220)),
            transform.RandomHorizontalFlip(),
            transform.RandomRotation(10),
            transform.RandomAffine(translate=(0.05, 0.05), degrees=0),
            transform.ToTensor(),
            transform.RandomErasing(inplace=True, scale=(0.01, 0.23)),
            transform.Normalize((0.4124234616756439, 0.3674212694168091, 0.2578217089176178),
                                (0.3268945515155792, 0.29282665252685547, 0.29053378105163574))]),
        'dataset3': transform.Compose([
            transform.Resize((220, 220)),
            transform.RandomHorizontalFlip(p=0.5),
            transform.RandomRotation(15),
            transform.RandomAffine(translate=(0.08, 0.1), degrees=15),
            transform.ToTensor(),
            transform.Normalize((0.4124234616756439, 0.3674212694168091, 0.2578217089176178),
                                (0.3268945515155792, 0.29282665252685547, 0.29053378105163574))

        ])
    }

    print("create datasets")
    bs = 50

    original = ImageFolder(path_1, transform=transformer['original'])

    train_val = ConcatDataset([original,
                               ImageFolder(path_1, transform=transformer['dataset1']),
                               ImageFolder(path_1, transform=transformer['dataset2']),
                               ImageFolder(path_1, transform=transformer['dataset3'])])

    train_size = int(len(train_val) * 0.9)
    val_size = len(train_val) - train_size
    train, val = random_split(train_val, [train_size, val_size])

    loaders = {
        'train': DataLoader(train, batch_size=bs, num_workers=4, pin_memory=True, shuffle=True),
        'val': DataLoader(val, batch_size=bs, num_workers=4, pin_memory=True, shuffle=True),
    }

    dataset_sizes = {
        'train': len(train),
        'val': len(val),
    }

    print(len(train))
    print(len(val))

    del train
    del val

    print('Classes:', original.classes)
    print('Number of classes:', len(original.classes))

    losses = {'train': [], 'val': []}
    accuracies = {'train': [], 'val': []}
    lr = []

    resnet50 = torchvision.models.resnet50(pretrained=True)
    for param in resnet50.parameters():
        param.grad_requires = False

    resnet50.fc = nn.Linear(in_features=resnet50.fc.in_features, out_features=len(original.classes), bias=True)

    num_models = 1
    epochs = 10

    model_list = [resnet50]

    for seed in range(num_models):
        train_method(seed=seed, epochs=epochs, model=model_list[seed])

    torch.save(resnet50, "resnet50_model.pth")
    print("happy end")

    fig, ax = plt.subplots(2, 2, figsize=(15, 15))
    model_name = ['ResNet101']


    def to_numpy_array(data):
        if isinstance(data[0], float):
            return np.array(data[0:20])
        else:
            return np.array([tensor.cpu().numpy() for tensor in data[0:20]])


    train_accuracies = to_numpy_array(accuracies['train'])
    val_accuracies = to_numpy_array(accuracies['val'])
    train_loss = to_numpy_array(losses['train'])
    val_loss = to_numpy_array(losses['val'])

    epoch_list = list(range(1, epochs * 2 + 1))

    ax[0][0].plot(epoch_list, train_accuracies, '-o', label='Train Accuracy')
    ax[0][0].plot(epoch_list, val_accuracies, '-o', label='Validation Accuracy')
    ax[0][0].plot([epochs for x in range(20)], np.linspace(min(train_accuracies), max(train_accuracies), 20), color='r',
                  label='Unfreeze net')
    ax[0][0].set_xticks(np.arange(0, epochs * 2 + 1, 5))
    ax[0][0].set_ylabel('Accuracy Value')
    ax[0][0].set_xlabel('Epoch')
    ax[0][0].set_title('Accuracy {}'.format(model_name[0]))
    ax[0][0].legend(loc="best")

    ax[0][1].plot(epoch_list, train_loss, '-o', label='Train Loss')
    ax[0][1].plot(epoch_list, val_loss, '-o', label='Validation Loss')
    ax[0][1].plot([epochs for x in range(20)], np.linspace(min(train_loss), max(train_loss), 20), color='r',
                  label='Unfreeze net')
    ax[0][1].set_xticks(np.arange(0, epochs * 2 + 1, 5))
    ax[0][1].set_ylabel('Loss Value')
    ax[0][1].set_xlabel('Epoch')
    ax[0][1].set_title('Loss {}'.format(model_name[0]))
    ax[0][1].legend(loc="best")
    fig.tight_layout()
    fig.subplots_adjust(top=1.5, wspace=0.3)
