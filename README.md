# CCM-FOR
Корреляционно-кластерные методы выделения функционально-однородных регионов головного мозга

Основные рабочие версии находятся в папке main



## Метод функциональной сегментации

Находится в папке main/FSM, основной скрипт: GetCorrelationRegions.m

Запускается через MATLAB

### Входные данные:
   1. NII файл с основными данными в виде X*Y*Z*T, где X,Y,Z - координаты в пространстве, T - временные отчеты, в ячейках матрицы - значени активности в определенном вокселе в определенный момент времени
   2. NII файл с маской вокселей, которые берутся в анализ

### Параметры:
   1. CORR_CUTOFF - отсечка, по которой выделяются границы регионов по корреляции
   2. MIN_REG_SIZE - минимальный размер выделяемого региона в вокселях

### Вывод скрипта:
   newMap - переменная в окружении MATLAB размера X,Y,Z - координаты в пространстве, в ячейках - номера новых регионов

### Как запускать:
   1. В папке FSM открыть скрипт GetCorrelationRegions.m, задать пути к входным данным (PATH_TO_4D_DATA, PATH_TO_MASK), и параметры метода. Мы советуем следующие параметры:
      CORR_CUTOFF - от 0.7 до 0.85
      MIN_REG_SIZE - 10 (вокселей)
   2. Закомментировать (если не нужно) удаление автокорреляции
   3. Добавить папку 'source' в path. Также внутри папки 'source' лежит папка с библиотекой NIfTI, которую также стоит добавить в path для работы с .nii файлами
   4. Запустить скрипт
   5. После окончания работы скрипта в окружении MATLAB появится переменная newMap. Эта переменная соодержит 3D матрицу размерности X,Y,Z - координаты в пространстве, в ячейках - номера новых регионов 


## Метод кластеризационной сегментации

Находится в папке main/CSM, основной скрипт: GetStabilityRegions.m

Запускается через MATLAB

### Входные данные:
   1. NII файл с основными данными в виде X*Y*Z*T, где X,Y,Z - координаты в пространстве, T - временные отчеты, в ячейках матрицы - значени активности в определенном вокселе в определенный момент времени
   2. NII файл с картой анатомических регионов, которые берутся в анализ

### Параметры:
   1. WINDOW - размер временного окна
   2. STEP - шаг временного окна
   3. NOT_IN_REG_COUNT - процент от количества окон, в которых воксель может отклониться от своего региона
   4. MIN_REG_SIZE - минимальный размер выделяемого региона в вокселях

### Вывод:
   newMap - переменная в окружении MATLAB размера X,Y,Z - координаты в пространстве, в ячейках - номера новых регионов

### Как запускать:
   1. В папке CSM открыть скрипт GetStabilityRegions.m, задать пути к входным данным (PATH_TO_4D_DATA, PATH_TO_MAP), и параметры метода. Мы советуем следующие параметры:
      WINDOW - от 100 до 300 временных отчётов (у нас были данные: 1 отчёт = 2 секундам, всего 1000 временных отчётов);
      STEP - мы рассматриваем шаг размером 50 % от размера окна (половинное перекрытие);
      NOT_IN_REG_COUNT - от 0 до 0.3
      MIN_REG_SIZE - 10 (вокселей)
   2. Закомментировать (если не нужно) удаление автокорреляции. Стоит заметить, что текущая функция удаления автокорреляции уменьшает временной ряд на 2 точки. Это стоит учесть в параметре WINDOW
   3. Добавить папку 'source' в path. Также внутри папки 'source' лежит папка с библиотекой NIfTI, которую также стоит добавить в path для работы с .nii файлами
   4. Запустить скрипт
   5. После окончания работы скрипта в окружении MATLAB появится переменная newMap. Эта переменная соодержит 3D матрицу размерности X,Y,Z - координаты в пространстве, в ячейках - номера новых регионов 
   
   
