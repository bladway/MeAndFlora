# Me&Flora

## Проект по ТП

### Тема:

Мобильное приложение для идентификации растений по фотографиям Me&Flora. Информация о растениях.

### Наша команда:

- [Котов Дмитрий Сергеевич](https://github.com/DmitryKotx) - Руководитель, Back-end разработчик, ML-инженер
- [Телегина Анна Сергеевна](https://github.com/annusshka) - Front-end разработчик, Дизайнер, Технический Писатель
- [Шепляков Владислав Вячеславович](https://github.com/bladway) - Back-end разработчик, QA-инженер, Бизнес аналитик

### Отличительные черты:

- Нейросеть для распознавания растений
- Платформа с рассылкой фотографий отсканированных растений с меткой геопозиции
- Подписка на рассылку информации по выбранным растениям
- Ботаники в качестве нанятых в помощь нейронной сети экспертов

## Навигация по проекту

### Task Manager

- [YouTrack](https://annushka.youtrack.cloud/projects/fa558d91-49ca-4ec1-bd8f-d99f76482b63)

### Miro

- [Miro](https://miro.com/app/board/uXjVNlotI-0=/?share_link_id=423741448147)

### AppMetrica

- [AppMetrica](https://appmetrica.yandex.ru/overview?appId=4568380&period=week&group=day&currency=rub&accuracy=medium&sampling=1)

  Для получения доступа к AppMetrica необходимо использовать следующий аккаунт:
  - Логин: meandflora
  - Пароль: d22-Ha7-mNq-9n4

### MeAndFlora Swagger

- [Server](https://rare-national-snapper.ngrok-free.app/swagger-ui/index.html)
- [Replica](https://mint-classic-dog.ngrok-free.app/swagger-ui/index.html)

  При переходе на сайт подтвердите переход через сервис ngrok и пропустите проверку подлинности SSL сертификата

### Документация

- Техническое задание [(.docx)](Documentation/Техническое_задание.docx) [(.pdf)](Documentation/Техническое_задание.pdf)
- Перечень задач [(.pdf)](Documentation/перечень_задач.pdf)
- Презентация проекта [(.pptx)](Documentation/Green-Modern-Nature-Presentation.pptx) [(.pdf)](Documentation/Green-Modern-Nature-Presentation.pdf)
- Сопроводительное письмо [(.docx)](Documentation/Сопроводительное-письмо.docx) [(.pdf)](Documentation/Сопроводительное-письмо.pdf)
- Курсовая работа [(.docx)](Documentation/Курсовая.docx) [(.pdf)](Documentation/Курсовая.pdf)

### Диаграммы

- [Use Case](Diagrams/Диаграммы-прецедентов)  
- [Sequence](Diagrams/Диаграммы-последовательностей)  
- [Statechart](Diagrams/Диаграммы-состояний)
- [Deployment](Diagrams/Диаграммы-развертывания)
- [Физическая модель БД](Diagrams/Физическая-модель)

### Медиафайлы

- [Видео-презентация](https://www.youtube.com/watch?v=8FzUBrN-DMc)
- [Обзор приложения](https://www.youtube.com/watch?v=WkVfqxSYBmg)
- [Развертывание приложения](https://youtu.be/7fZBU0EG98U)
- [Обзор микросервиса обработки изображений](https://www.youtube.com/watch?v=0YQlkOPAnRs)
- [Обзор основного сервера приложения](https://youtu.be/04m3G0NgrO0)
- [Обзор frontend приложения](https://www.youtube.com/watch?v=TVzHa_HHfDA)

### APK файл мобильного приложения

- [APK](https://drive.google.com/file/d/1ZElXIO6VemzyS2pOfyO6y3pvgBgZI384/view?usp=drive_link)

### Тестовые данные для работы в приложении по ролям

- Анонимный пользователь:
  - Для работы под анонимным пользователем не требуются данные. Можно использовать соответствующий метод авторизации на сервере приложения.
- Авторизированный пользователь:
  - Логин: useruser
  - Пароль: useruser
- Ботаник:
  - Логин: botanistuser
  - Пароль: botanistuser
- Администратор
  - Логин: adminuser
  - Пароль: adminuser

### Развертывания сервера

Для развертывания приложения на сервере достаточно использовать Makefile в соответствующей папке, предоставив ему
.env файл с необходимыми переменными окружения. Развертывание предполагается на Linux-подобной операционной системе
